#!/usr/bin/env ruby

require "rexml/document"

# Create a DayOne entry in a journal named "LiveJournal"
def create_dayone_entry(subject, date, text)
  journal_name = 'LiveJournal'
  
  f = File.new("/tmp/entry", "w+")
  f.puts subject
  f.puts text
  f.close
  return `cat /tmp/entry | dayone2 --journal=#{journal_name} --date="#{date}" new`
end

# Iterate over all files on the command line
ARGV.each do |arg|

  # Read file and load <entry> objects into an array
  ljdata = REXML::Document.new(File.new(arg))
  entries = REXML::XPath.each(ljdata, "//entry").to_a

  entries.each do |e|
    event = e.elements["event"].text
    subject = e.elements["subject"].text
    eventdate = e.elements["eventtime"].text
    
    # convert <lj-cut> instances into <hr> tags
    event.gsub!(/<lj-cut.*?">/, '<hr />')
    event.gsub!(/<\/lj-cut>/, "\n")

    # convert <lj-user> tags to bold links
    event.gsub!(/<lj user="(.*?)"(\s*\/)*>/, '<a href="https://\1.livejournal.com"><b>\1</b></a>')

    # Use Pandoc for HTML to Markdown conversion
    File.write('/tmp/event', event)
    event = `cat /tmp/event | pandoc -f html -t gfm --wrap=none`

    # Create entry, making subject an <h1> if provided
    if subject.nil?
      puts create_dayone_entry('', eventdate, event)
    else
      puts create_dayone_entry('# ' + subject, eventdate, event)
    end
    puts "Entry from " + eventdate + " added."
  end

end
