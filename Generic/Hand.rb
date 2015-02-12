# Simple class that defines a collection of cards currently
# held by a player
module Generic
	class Hand
		attr_reader :cards, :bet
		def initialize
			@cards = []
			@bet = 0
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
	end
end