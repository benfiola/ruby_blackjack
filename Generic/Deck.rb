require_relative "./Card.rb"

module Generic
	class Deck
		attr_reader :cards

		def initialize(num_decks) 
			raise RuntimeError, "Can't initialize generic deck"
		end

		def shuffle
			@cards = @cards.shuffle
		end

		def grab_card
			to_return = @cards.delete_at(0)
			if to_return == nil
				throw RuntimeError, "Tried to grab card from empty deck."
			end
			return to_return
		end

		def to_str
			to_s
		end

		def to_s
			to_return = ""
			for card in @cards
				to_return = to_return + " #{card}"
			end
			to_return.strip!
			return to_return
		end

		def to_message
			to_return = []
			for card in @cards
				to_return.push(*card.to_message)
			end
			return to_return
		end
	end
end