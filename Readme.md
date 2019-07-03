# Hello!

If you're still using [LiveJournal](https://www.livejournal.com), odds are you've got a _lot_ of stuff there. LJ does let you download your archives, but their tool only lets you do it one month at a time.

My personal archives on LJ go back to 2002, and the idea of individually downloading well in excess of a hundred files by hand seems absurd. So here's a way to get your whole LJ archive without doing that.

First of all, you need to be able to run Ruby scripts. If you're on a Mac or Linux machine, you already can. If you're running Windows, it takes a little bit of doing, but you can still do it!

## How to use getljxml.rb on a Mac

(I'm going to assume some familiarity with the command line.)

First, download the file. Then put it in the directory where you want your LJ archives to be downloaded.

Then, using a text editor, create a file named `lj.yml` in the same directory. DO NOT PANIC at this point. Make a file that looks like this:

```yaml
username: chipotle
password: "my-crazy-password"
first_year: 2001
```

Put in your own username and password, of course. This script sends them to the LiveJournal server just like your browser, and doesn't send them anywhere else, so your password is not being stolen. (You'll probably need quote marks around the password if it has any remotely unusual characters in it.) Change `first_year` to the first year you want to import. If you don't want to export all of your journal, you can also add a `last_year` line here.

**NOTE:** Make sure that your username and password are surrounded with single straight quotes, not curly quotes!

Open up a terminal window and change to the directory that `getljxml.rb` is in. (If you're on a Mac, you can type `cd `, put a space after it, and then drag the folder containing `getljxml.rb` into the terminal window. Then hit `return`.)

Now, type two things.

> `chmod u+x getljxml.rb` (Then hit return!)

> `./getljxml.rb` (Hit return again!)

Now you should see a bunch of stuff happening. When stuff stops happening, look at your folder again. You should now have a new `lj-xml` folder. In that folder, you'll have a bunch of .xml files, each one corresponding to a month of entries from your Livejournal. Months with no entries won't have files for them.

## How to use getljxml on a Linux machine

It's the same as doing it on a Mac! 

## How to use getljxml on a Windows machine

This takes a little work. You'll need to install a couple of things that don't come with Windows by default. 

### Installing Ruby on Windows

First, you'll need to install Ruby.

1. Go to https://rubyinstaller.org/downloads/
2. Click on one of the Ruby installers to download and run. 
	If you're not sure which one of the installers to choose, read the text on the right-hand side of the page under 'Which Versions to Download?'. This is a fairly simple script, and will probably run with any version of Ruby, so don't stress too much over what to pick. 
3. Run the installer. 

### Installing cURL on Windows

Next you'll need to install cURL, which is basically a web browser that your script can use from the command line. Unfortunately, this can be a bit fiddly. The simplest set of instructions that I've found are available here: https://help.zendesk.com/hc/en-us/articles/229136847-Installing-and-using-cURL#install

If you follow them step by step, you should get it working. 

### Running the getljxml script

Okay, now that you've done that, you're almost home free. 
First, download the `getljxml.rb` file:

1. From https://github.com/papatangosierra/livejournal-archive-tools, click the **Clone or download** button. 
2. Click **Download ZIP**
3. Extract the contents of the zip file and copy the getljxml.rb script to a folder where you want your files to be backed up. 

Then, using a text editor, create a file named `lj.yml` in the same directory. DO NOT PANIC at this point. Make a file that looks like this:

```yaml
username: chipotle
password: "my-crazy-password"
first_year: 2001
```

Put in your own username and password, of course. This script sends them to the LiveJournal server just like your browser, and doesn't send them anywhere else, so your password is not being stolen. (You'll probably need quote marks around the password if it has any remotely unusual characters in it.) Change `first_year` to the first year you want to import. If you don't want to export all of your journal, you can also add a `last_year` line here.

**NOTE:** Make sure that your username and password are surrounded with single straight quotes, not curly quotes!

Now you're ready to run the script. 

1. Click **Start** and type `cmd` to open a command-line window. 
2. Type `cd` followed by the path to the folder where the getljxml.rb script is located. 
	To find the path, browse to the folder in Windows Explorer. Click in an empty part of the address bar of the window to show  and select the path. Press Ctrl+C to copy the path. Right-click in the command-line window and select paste to paste the path you have copied. 
3. Type `ruby getljxml.rb` to run the script. 

Now you should see a bunch of stuff happening. When stuff stops happening, look at your folder again. You should now have a new `lj-xml` folder. In that folder, you'll have a bunch of .xml files, each one corresponding to a month of entries from your Livejournal. Months with no entries won't have files for them.

## How to use lj2dayone.rb

This has a few more complicated requirements:

* You must install [Pandoc](https://pandoc.org).
* You must have Day One version 2 or higher.
* You must have installed the command line tool ("Install Command Line Tools..." in Day One's menu).

Got it? Okay!

1. Create a new journal called "LiveJournal" in Day One.

2. Put the `lj2dayone.rb` file in the same folder as all your LJ XML files.

3. Open up a terminal window (I know, I know) and type

	`chmod u+x lj2dayone.rb` (Hit return.)

	`./lj2dayone.rb *.xml` (And hit return again)

Depending on how many LJ entries you have to import, this could take a few minutes. Once's it's finished, you can open up Day One and gaze upon your beautiful new archive.

----

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

The original files do not specify a license.