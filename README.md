#Blackjack in Ruby

I was asked to create a simple blackjack game written entirely in Ruby.  

The requirements were as follows :
* Command-line driven
* Variable amount of players
* Support for betting (each player starts with $1000)
* Support for basic blackjack behaviors (hit, stay, double, split)
* Dealer that will hit until he reaches 17
* No unnecessary dependencies

##No dependencies?
So, this program is almost entirely pure, standard Ruby.  I did choose to include one dependency for aesthetic reasons.  

The dependency I went with is the 'curses' gem for Ruby.  Why?  Mainly, I just didn't want to constantly print to new lines in the terminal.  After using system resource monitors like [https://github.com/nicolargo/glances](glances) where the terminal is basically a text buffer that can be overwritten at will, I thought it'd be cool to use a similar idea for this project.  Granted, I had no experience with curses before this project, but I'm really glad I got the chance to check it out - it's pretty cool!

##Installation
Getting up and running with this code is simple.  All you need to do is install the curses gem!

On Mac OS X or Linux, you can install curses by typing 
```
gem install curses
```

Unfortunately, if you're on a Windows machine, you're going to need to do a bit more work because the ruby-devkit needs a few things to build the native extension.

First, you're going to need to download the pdcurses distribution [http://sourceforge.net/projects/pdcurses/files/pdcurses/3.4/](pdc34dllw.zip).

Then, unzip this file somewhere.  In this example, unzip the files into a C:\pdcurses directory.  

Within the C:\pdcurses directory, make three new folders called 'bin', 'include' and 'lib'.  You're going to want to move the *.h files you extracted into the 'include' folder, the *.dll file into the 'bin' folder and the *.lib file into the lib folder.  

Now, install the curses gem by typing
```
gem install curses --platform=ruby -- --with-curses-lib="C:\pdcurses\lib" --with-curses-include="C:\pdcurses\include"
```

Should everything go as intended, you should have been able to successfully install the curses gem for Ruby.

##Running the program
Once you've downloaded the source and extracted it somewhere convenient, simply navigate to the root directory and type 

```
ruby Main.rb
```
You should be good to go.  If, for whatever reason, you REALLY want to exit the program, you can always press Control + C.
