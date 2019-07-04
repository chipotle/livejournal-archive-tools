# LiveJournal Archive Tools

These include:

* LiveJournal downloader
* Day One importer (for downloaded XML files)

## Credits / Changelog

Written by [@papatangosierra](https://github.com/papatangosierra). This version was modified by [@chipotle](https://github.com/chipotle) (Watts Martin) to make the following changes:

**getljxml.rb:**

* Move configuration to YAML file
* Add `last_year` configuration
* Only write month files that actually have entries

**lj2dayone.rb:**

* Drop "classic" Day One support
* Use Pandoc for real Markdown processing
* Refactor XML handling
* Write to "LiveJournal" journal

**General:**

* More idiomatic Ruby

The original files do not specify a license, so I'm stumped for what these should be licensed as, although I'd personally probably pick GPL. -- wm

----

## getljxml.rb: download LiveJournal XML

Download `getljxml.rb` and put it in a directory somewhere. Your LiveJournal will be downloaded to a folder in this directory named `lj-xml`.

Using a text editor, create a file named `lj.yml` in the same directory. This is a configuration file that should look like this:

	username: chipotle
	password: "my-crazy-password"
	first_year: 2001

Put in your own username and password, of course. This script sends them to the LiveJournal server just like your browser, and doesn't send them anywhere else, so your password is not being stolen. (You'll probably need quote marks around the password if it has any remotely unusual characters in it.) Change `first_year` to the first year you want to import. If you don't want to export all of your journal, you can also add a `last_year` line, like `last_year: 2015`.

**NOTE:** Make sure that your username and password are surrounded with single straight quotes, not curly quotes!

Open up a terminal window and `cd` to the directory that `getljxml.rb` is in. Type:

	chmod u+x getljxml.rb

(That only has to be done once, not every time you want to run the script.) Then, run the script with:

	./getljxml.rb

After the script finishes, you should now have a new `lj-xml` folder. In that folder, you'll have a bunch of .xml files, each one corresponding to a month of entries from your Livejournal. Months with no entries won't have files for them.

### Running on Windows

First, you'll need to install Ruby: https://rubyinstaller.org/downloads/

Then, you'll need to install cURL: https://help.zendesk.com/hc/en-us/articles/229136847-Installing-and-using-cURL#install

Then you should be able to follow the steps above.

## lj2dayone.rb: Import LiveJournal XML to Day One

* You must install [Pandoc](https://pandoc.org).
* You must have Day One version 2 or higher.
* You must have installed the command line tool ("Install Command Line Tools..." in Day One's menu). This installs a command called `dayone2`.

And, you must install Pandoc, which converts from the HTML-in-XML entries downloaded by getljxml.rb to Markdown formatting used by Day One: https://pandoc.org

Download the `lj2dayone.rb` script to the same folder you put `getljxml.rb` in.

Create a new journal called "LiveJournal" in Day One. The entries will be imported here. (If you want to change this, you can edit the `lj2dayone.rb` script; look for the `journal_name = 'LiveJournal'` line and enter a different name.)

Open up a terminal window and `cd` to the directory that `lj2dayone.rb` is in. Type:

	chmod u+x lj2dayone.rb

(That only has to be done once, not every time you want to run the script.) Then,  run the script with:

	./lj2dayone.rb lj-xml/*.xml

The `lj-xml/*.xml` part is the path to the LiveJournal XML files; if they're somewhere else, use that path.

Depending on how many LJ entries you have to import, this could take a few minutes. Once's it's finished, you can open up Day One and gaze upon your beautiful new archive.
