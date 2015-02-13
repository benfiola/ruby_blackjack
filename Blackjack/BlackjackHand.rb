require_relative "./BlackjackCard.rb"
require_relative "../Generic/Hand.rb"
require_relative "../Display/Message"

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
		return get_value == 21 && @cards.length == 2
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

	def get_blackjack_winnings
		return ((@bet) + (@bet * 1.2)).to_i
	end

	def get_regular_winnings
		return @bet + @bet
	end

	def get_action_message(player_money)
		message_arr = []
		if(can_hit)
			message_arr.push(Message.new("["))
			message_arr.push(Message.new("h", "red"))
			message_arr.push(Message.new("]it, "))
		end
		if(can_double && player_money >= @bet)
			message_arr.push(Message.new("["))
			message_arr.push(Message.new("d", "red"))
			message_arr.push(Message.new("]ouble down, "))
		end
		if(can_split && player_money >= @bet)
			message_arr.push(Message.new("s["))
			message_arr.push(Message.new("p", "red"))
			message_arr.push(Message.new("]lit, "))
		end
		message_arr.push(Message.new("or ["))
		message_arr.push(Message.new("s", "red"))
		message_arr.push(Message.new("]tay :"))
		return message_arr
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

	def to_message
		message_arr = super
		if @winnings != nil
			message_arr.push(Message.new("\t\t"))
			if @winnings == @bet
				message_arr.push(Message.new("+$#{@winnings}", "yellow"))
			else
				message_arr.push(Message.new("+$#{@winnings}", "green"))
			end
		end
		return message_arr
	end
end