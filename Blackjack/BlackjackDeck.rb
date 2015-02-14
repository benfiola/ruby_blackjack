require_relative "../Generic/Deck.rb"
require_relative "./BlackjackCard.rb"

# a deck is simply a collection of cards.  assuming single-card blackjack 
# could be problematic if someone decided to have 30 players play, so let's
# be sure to support as many decks as needed to accommodate a ton of players.
# also, don't forget to shuffle!
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