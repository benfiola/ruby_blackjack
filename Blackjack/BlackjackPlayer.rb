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
			if @curr_hand.can_hit
				receive_card @game.request_card
			end
		elsif(action == "p")
			if @curr_hand.can_split
				# remove a card from the current hand and request a new card from the game
				removed = @curr_hand.remove_card(@curr_hand.cards.last)
				receive_card @game.request_card

				# build a new hand with another card requested from the game as well as
				# the card we just removed
				new_hand = BlackjackHand.new
				new_hand.add_card(removed)
				new_hand.add_card(@game.request_card)

				# add this new hand to our list of hands
				@hands.push(new_hand)

				# place an equal bet on thes new hand
				place_bet(@curr_hand.bet, new_hand)
			end
		elsif(action == "d")
			if @curr_hand.can_double
				# double our bet and receive the next card
				place_bet(@curr_hand.bet, @curr_hand)
				receive_card @game.request_card

				# we want to set the flag for the hand - we're not allowed
				# to do anything else after doubling down.
				@curr_hand.double
			end
		end
	end
end