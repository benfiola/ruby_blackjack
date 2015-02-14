require_relative "./Blackjack/BlackjackGame.rb"
require_relative "./Display/Display.rb"

# this is the main entry point for the application
# all we do here is initialize our display and pass it to our game
# the go method is the run_loop of the game.

# the blackjack-specific stuff is in the blackjack folder
# the underlying, generic functionality of cards, decks, hands, suits, ranks in the generic folder
# anything pertinent to the display is in the display folder.
# finally, for compatibility with windows (whose curses support lacks some UTF-8 support), i borrowed
# some code i found off of stackoverflow for detecting platform.
begin
	d = Display.new
	bg = BlackjackGame.new d
	bg.go
rescue SystemExit, Interrupt
	d.close
end



