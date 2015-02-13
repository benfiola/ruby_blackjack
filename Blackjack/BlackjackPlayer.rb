require_relative "./BlackjackCard.rb"
require_relative "./BlackjackHand.rb"
require_relative "./BlackjackGame.rb"
require_relative "../Generic/Player.rb"
require_relative "../Display/Message"

class BlackjackPlayer < Generic::Player
	def initialize(number, money, game)
		@number = number
		@money = money
		@game = game
	end

	def get_action_message
		message_arr = []
		message_arr.push(Message.new("Player #{@number} can choose to "))
		message_arr.push(*@curr_hand.get_action_message(@money))
		return message_arr
	end

	def take_action(*args)
		action = args[0]
		if action == "q"
			exit(0)
		elsif action == "s"
			return false
		elsif(action == "h")
			if @curr_hand.can_hit
				receive_card @game.request_card
			end
		elsif(action == "p")
			if @curr_hand.can_split && @curr_hand.bet <= money
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
			if @curr_hand.can_double && @curr_hand.bet <= @money
				# double our bet and receive the next card
				place_bet(@curr_hand.bet, @curr_hand)
				receive_card @game.request_card

				# we want to set the flag for the hand - we're not allowed
				# to do anything else after doubling down.
				@curr_hand.double
			end
		end

		return true
	end
end