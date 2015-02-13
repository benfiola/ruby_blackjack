#Blackjack in Ruby

I was asked to create a simple blackjack game written entirely in Ruby.  

The requirements were as follows :
*Command-line driven
*Variable amount of players
*Support for betting (each player starts with $1000)
*Support for basic blackjack behaviors (hit, stay, double, split)
*Dealer that will hit until he reaches 17
*No unnecessary dependencies

##No dependencies?
So, this program is almost entirely pure, standard Ruby.  I did choose to include one dependency for aesthetic reasons.  

The dependency I went with is the 'curses' gem for Ruby.  Why?  I just liked the idea of treating the terminal window like a real text buffer where I have the freedom to clear the buffer and re-write to the same space over and over again.  Generally, one could implement this command-line driven program simply by printing to console every time a new game event changes the state of the game.  However, this means that old game state gets shifted up in the terminal as each new iteration of the game board is printed - by the end of the game, you could have hundreds of lines of output or more.  I wasn't familiar with curses before I started this project, but I'm glad I checked it out - it's really cool!

##Installation
Getting up and running with this code is simple.

First, you're going to want to install curses.   

On Mac OS X or Linux, you can install curses by typing 
```
gem install curses
```

Unfortunately, if you're on a Windows machine, you're going to need to do a bit more work because the ruby-devkit needs a few things to build the curses gem.

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
