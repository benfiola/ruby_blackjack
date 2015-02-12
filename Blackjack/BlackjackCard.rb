require './Generic/Card.rb'

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
