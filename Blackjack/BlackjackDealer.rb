require_relative "./BlackjackPlayer.rb"
require_relative "../Display/Message.rb"

# My implementation initially featured a dealer that functioned
# similar to what you'd expect in a casino.  It made more sense
# semantically, however, to have the game object handle the cards, 
# and to have the dealer simply function as a computer-controller player
# who doesn't have money or place bets.
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
		" Dealer - #{@curr_hand}"
	end

	def to_message
		to_return = []
		if @game.curr_player == self
			to_return.push(Message.new(">"))
		else
			to_return.push(Message.new(" "))
		end
		to_return.push(Message.new("Dealer\t\t"))
		to_return.push(*curr_hand.to_message)
		return to_return
	end
end
