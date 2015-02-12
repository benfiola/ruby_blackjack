require "./Blackjack/BlackjackGame.rb"
require "./Display/Display.rb"

# this is the main entry point for the application
# all we do here is initialize our display and pass it to our game
# the go method is the run_loop of the game.
d = Display.new
bg = BlackjackGame.new d
bg.go




