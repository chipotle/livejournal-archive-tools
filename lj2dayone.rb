#!/usr/bin/env ruby

require "rexml/document"

# This assumes you're using a modern version of Day One, with the "dayone2"
# command line app installed.

# Create a DayOne entry in a journal named "LiveJournal"
def create_dayone_entry(subject, date, text)
  dayone_cmd = 'dayone2'		
  dayone_cmd_options = '--journal=LiveJournal'

  f = File.new("/tmp/entry", "w+")
  f.puts subject
  f.puts text
  f.close
  return `cat /tmp/entry | #{dayone_cmd} #{dayone_cmd_options} --date="#{date}" new`
end

# It's very likely that we're going to be iterating over multiple files, so
# let's try to handle that intelligently!
ARGV.each do |arg|
  ljdata = REXML::Document.new(File.new(arg))
  # puts ljdata

# Extract the relevant data from the ljdata xml object
  entries = REXML::XPath.each(ljdata, "//entry").to_a

# Iterate over the array; subjects[] is used to derive the index number, but
# that's an arbitrary choice; all three arrays should be the same length

  entries.each do |e|
    event = e.elements["event"].text
    # This gets rid of <lj-cut> garbage in a semi-intelligent way;
    # If the cut had a caption associated, we pull that out and
    # format it nicely, otherwise use an <hr />
    event.gsub!(/<lj-cut\s+text="(.*?)">/, '<p>(\1)</p>')
    event.gsub!(/<lj-cut>/, "<hr />")
    event.gsub!(/<\/lj-cut>/, "\n")

    # <lj-user> instances are converted to HTML links
    event.gsub!(/<lj user="(.*?)"(\s*\/)*>/, '<a href="https://\1.livejournal.com"><b>\1</b></a>')

    # Use pandoc for less naive HTML-to-Markdown conversion
    File.write('/tmp/event', event)
    event = `cat /tmp/event | pandoc -f html -t gfm --wrap=none`

    subject = e.elements["subject"].text
    eventdate = e.elements["eventtime"].text
    if subject.nil?
      puts create_dayone_entry('', eventdate, event)
    else
      # Give subjects <h1> headings
      puts create_dayone_entry('# ' + subject, eventdate, event)
    end
    puts "Entry from " + eventdate + " added."
  end
end
