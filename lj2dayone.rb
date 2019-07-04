#!/usr/bin/env ruby

require 'rexml/document'

# Create a Day One entry
def create_dayone_entry(subject, date, text)
  journal_name = 'LiveJournal'

  subject = if subject.nil? then '' else '# ' + subject end
  f = File.new('/tmp/entry', 'w+')
  f.puts subject
  f.puts text
  f.close
  `cat /tmp/entry | dayone2 --journal=#{journal_name} --date="#{date}" new`
end

# Check if a file exists on a path
# taken from https://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each do |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      return exe if File.executable?(exe) && !File.directory?(exe)
    end
  end
  return nil
end

# Process an individual monthly XML file
def process_file(xmlfile)
  ljdata = REXML::Document.new(File.new(xmlfile))
  entries = REXML::XPath.each(ljdata, '//entry').to_a

  entries.each do |e|
    event = e.elements['event'].text
    subject = e.elements['subject'].text
    eventdate = e.elements['eventtime'].text

    # convert <lj-cut> instances into <hr> tags
    event.gsub!(/<lj-cut.*?>/, '<hr />')
    event.gsub!(%r{</lj-cut>}, "\n")

    # convert <lj-user> tags to bold links
    event.gsub!(%r{<lj user="(.*?)"(\s*/)*>},
      '<a href="https://\1.livejournal.com"><b>\1</b></a>')

    # Use Pandoc for HTML to Markdown conversion
    File.write('/tmp/event', event)
    event = `cat /tmp/event | pandoc -f html -t gfm --wrap=none`

    puts create_dayone_entry(subject, eventdate, event)
    puts "Entry from #{eventdate} added."
  end
end

# --- start execution here ---

abort("Pandoc not found! Install from https://pandoc.org") unless
  which('pandoc')

ARGV.each do |arg|
  process_file(arg)
end
