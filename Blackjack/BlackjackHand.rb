require "./Generic/Hand.rb"
require "./Blackjack/BlackjackCard.rb"

class BlackjackHand < Generic::Hand	
	def initialize
		super
		@has_doubled = false
	end
	# given the current hand, let's define what we can do.
	def can_split
		return @cards.length == 2 && @cards.first.rank.value == @cards.last.rank.value && !is_blackjack
	end

	def can_double
		return @cards.length == 2 && !is_blackjack
	end

	def can_hit
		return !@has_doubled && !is_bust && !is_blackjack
	end

	# these methods all help us determine whether our hand is a winning
	# or losing hand.
	def is_bust
		return get_value > 21
	end

	def is_blackjack
		return get_value == 21
	end

	def is_winner(dealer_value)
		return !is_bust && ( (dealer_value <= 21 && get_value > dealer_value) || dealer_value > 21)
	end

	def is_push(dealer_value)
		return !is_bust && get_value == dealer_value
	end

	def is_loser(dealer_value)
		return is_bust || (get_value < dealer_value && dealer_value < 21)
	end

	# this helper method will let us keep track of whether we've doubled
	def double
		@has_doubled = true
	end

	# finally, this method helps us determine the blackjack value of the current hand
	def get_value
		aces_in_hand = 0
		value = 0
		for card in @cards
			if card.rank.is_ace
				aces_in_hand = aces_in_hand + 1
			end
			value = value + card.get_value
		end
		while aces_in_hand > 0 && value > 21
			value = value - 10
			aces_in_hand = aces_in_hand - 1
		end
		return value
	end
end