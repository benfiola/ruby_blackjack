require_relative "../Generic/Deck.rb"
require_relative "./BlackjackCard.rb"

class BlackjackDeck < Generic::Deck
	def initialize(num_decks)
		@cards = []
		@num_decks = num_decks
		for i in 0...num_decks
			for j in 0...52
				@cards.push BlackjackCard.Create(j)
			end
		end
		shuffle
	end
end