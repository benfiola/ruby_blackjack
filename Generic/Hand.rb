# Simple class that defines a collection of cards currently
# held by a player

# generally, it would make sense that a hand contains a collection
# of cards.  it would also make sense to have a hand hold the bet that's
# placed on it.  for display purposes, i thought it'd also be useful
# to store whatever winnings this hand achieved.
module Generic
	class Hand
		attr_reader :cards, :bet, :winnings
		def initialize
			@cards = []
			@bet = 0
		end

		def set_winnings(winnings)
			@winnings = winnings
		end

		def add_card(card)
			@cards.push card
		end

		def remove_card(card)
			@cards.delete card
		end 

		def place_bet(bet)
			@bet = @bet + bet
		end

		def get_value
			value = 0
			for card in @cards
				value = value + card.get_value
			end
			return value
		end

		def to_s
			str = "["
			for card in @cards
				str += "#{card} "
			end
			str.strip!
			str += "]"
			return str
		end

		def to_str
			to_s
		end

		def to_message
			to_return = []
			bet_str = ""
			if @bet > 0
				bet_str = "Bet $#{@bet}"
			end
			to_return.push(Message.new("#{bet_str}", "red"))
			to_return.push(Message.new("\t"))
			for card in @cards
				to_return.push(*card.to_message)
			end
			return to_return
		end
	end
end