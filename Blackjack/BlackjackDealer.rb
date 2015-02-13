require "./Blackjack/BlackjackPlayer.rb"
require "./Display/Message.rb"

class BlackjackDealer < BlackjackPlayer

	def initialize(game)
		@game = game
	end

	def take_action
		while !@curr_hand.is_blackjack && !@curr_hand.is_bust &&
			if @curr_hand.get_value < 17 
				card = @game.request_card
				@curr_hand.add_card(card)
				next 
			end
		end
	end

	def to_str
		to_s 
	end

	def to_s
		"Dealer - #{@curr_hand}"
	end

	def to_message
		to_return = []
		to_return.push(Message.new("Dealer - "))
		to_return.push(*curr_hand.to_message)
		return to_return
	end
end
