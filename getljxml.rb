#!/usr/bin/env ruby
require 'cgi'
require 'yaml'
require 'fileutils'

# Put your username and password in the lj.yaml file, like so.
# "last_year" defaults to the current
#
# username: chipotle
# password: password
# first_year: 2001
# last_year: 2015

lj = YAML.load_file('lj.yml')

# You shouldn't have to change these, but here they are just in case!
lj_login_url = 'http://www.livejournal.com/interface/flat' # LJ API url
lj_archive_url = 'http://www.livejournal.com/export_do.bml' # XML download URL

# Build login string, then log into LJ and save the cookie.

loginstring = 'mode=sessiongenerate&user=' + CGI.escape(lj['username']) +
  '&password=' + CGI.escape(lj['password'])

lj_session_cookie = `curl --data #{loginstring.dump} #{lj_login_url.dump}`.lines

# if we logged in successfully, write out the cookie
if lj_session_cookie[0] =~ /ljsession/
  open('cookies.txt', 'w') do |f|
    f.puts("#HttpOnly_.livejournal.com\tTRUE\t/\tFALSE\t0\tljsession\t" +
      lj_session_cookie[1])
  end
else
  abort('ERROR: Could not log in to LiveJournal.')
end

# Make sure we actually logged in
abort('Error: Could not log in to LiveJournal') unless File.exist? 'cookies.txt'

FileUtils.mkdir_p 'lj-xml'

if lj['last_year']
  last_month = 12
  last_year = lj['last_year']
else
  last_month = Time.now.month
  last_year = Time.now.year
end

(lj['first_year']..last_year).each do |current_year|
  months = (current_year == last_year) ? 1..last_month : 1..12
  months.each do |current_month|
    poststring = 'what=journal&year=' + current_year.to_s + '&month=' +
      current_month.to_s +
      '&format=xml&header=on&encid=2&field_eventtime=on&field_subject=on&field_event=on'
    filename = format('lj-xml/%04d-%02d.xml', current_year, current_month)
    xml = `curl -L --cookie cookies.txt --data #{poststring.dump} #{lj_archive_url.dump}`.encode('UTF-8')
    if xml !~ %r{<livejournal>\n</livejournal>}
      File.write(filename, xml)
      puts "* #{filename} written"
    else
      puts "- #{filename} empty, skipped"
    end

    sleep(1)
  end
end

File.delete 'cookies.txt'
