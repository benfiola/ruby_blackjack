require_relative '../Generic/Card.rb'

# This class just implements the blackjack-specific things we 
# might want out of these series of classes.  
# (I decided to make an empty BlackjackSuit class just so that there's an analogue
# between every generic class and Blackjack-specific class)

# Look at '../Generic/Card.rb' for more of the underlying implementation.
class BlackjackCard < Generic::Card
	def initialize(suit, rank)
		@suit = BlackjackSuit.new(suit)
		@rank = BlackjackRank.new(rank)
	end

	def get_value
		to_return = @rank.value
		if @rank.value >= 11
			if @rank.is_ace
				to_return = 11
			else
				to_return = 10
			end
		end
		return to_return
	end
end

class BlackjackSuit < Generic::Suit

end

class BlackjackRank < Generic::Rank
	def is_ace
		return @value == RANK_ACE
	end
end
