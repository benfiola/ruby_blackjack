require "./Blackjack/BlackjackGame.rb"
require "./Display/ConsoleDisplay.rb"

class BlackjackController
	attr_reader :display, :game
	def initialize
		@display = ConsoleDisplay.new
		@game = BlackjackGame.new(1)
	end
end