require "./Generic/Player.rb"
require "./Blackjack/BlackjackHand.rb"

class BlackjackPlayer < Generic::Player
	def initialize(number, money, game)
		@number = number
		@money = money
		@game = game
	end

	def take_action(*args)
		action = args[0]
		if(action == "h")
			receive_card @game.request_card
		elsif(action == "p")

		elsif(action == "d")

		end
	end
end