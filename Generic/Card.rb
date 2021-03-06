require_relative "../Utils/OS.rb"

# This collection of classes serves to define a generic playing card.
# We don't want to intertwine the rules of Blackjack with the implementation
# of our cards (what if we want to use these to make a Poker game?)
module Generic
	class Card
		attr_reader :suit, :rank

		# Logically, we'd build a card based upon its rank and suit.
		def initialize(suit, rank)
			raise RuntimeError, "Can't initialize generic card"
		end

		# This method is solely for convenience for creating cards in batch.
		# (Like initializing all 52 cards at once.)
		def self.Create(card_number)
			suit = card_number/13
			rank = card_number%13
			self.new(suit, rank)
		end

		def to_s
			to_return = []
			to_return.push(@rank.to_message)
			to_return.push(@suit.to_message)
			return to_return
		end

		def to_str
			to_s
		end

		def to_message
			to_return = []
			to_return.push(Message.new("["))
			to_return.push(*@rank.to_message)
			to_return.push(*@suit.to_message)
			to_return.push(Message.new("]"))
			return to_return
		end
	end

	class Suit
		SUIT_HEART=0
		SUIT_CLUB=1
		SUIT_SPADE=2
		SUIT_DIAMOND=3

		attr_reader :value

		# We accept values of 0-3 when building a Suit - these
		# directly correspond with the 4 suits of a standard playing
		# card deck.
		def initialize(suit_number)
			if suit_number > 3
				raise RuntimeError, "Invalid suit number : #{suit_number}."
			end
			@value = suit_number
		end
		
		def to_s
			to_return = ""
			if @value == SUIT_HEART
				if !OS.windows?
					to_return = "\u2665".force_encoding("utf-8")
				else
					to_return = "H"
				end
			elsif @value == SUIT_CLUB
				if !OS.windows?				
					to_return = "\u2663".force_encoding("utf-8")
				else
					to_return = "C"
				end
			elsif @value == SUIT_SPADE
				if !OS.windows?
					to_return = "\u2660".force_encoding("utf-8")
				else
					to_return = "S"
				end
			elsif @value == SUIT_DIAMOND
				if !OS.windows?
					to_return = "\u2666".force_encoding("utf-8")
				else 
					to_return = "D"
				end
			end
			return to_return
		end

		def to_str
			to_s
		end

		def to_message
			message_arr = []
			if @value == SUIT_HEART || @value == SUIT_DIAMOND
				message_arr.push(Message.new("#{to_s}", "red"))
			else 
				message_arr.push(Message.new("#{to_s}", "blue"))
			end
			return message_arr
		end
	end

	class Rank
		RANK_JACK = 11
		RANK_QUEEN = 12
		RANK_KING = 13
		RANK_ACE = 14

		attr_reader :value

		# rank_number will be a number between 0 and 12 inclusive
		# however, we do add 2 to the value because card rank numbering
		# actually starts at 2.  
		def initialize(rank_number)
			if rank_number > 12
				raise RuntimeError, "Invalid rank number : #{rank_number}."
			end
			@value = rank_number + 2
		end

		def to_s
			to_return = ""
			if @value >= 11
				if @value == RANK_JACK
					to_return = "J"
				elsif @value == RANK_QUEEN
					to_return = "Q"
				elsif @value == RANK_KING
					to_return = "K"
				elsif @value = RANK_ACE
					to_return = "A"
				end
			else
				to_return = "#{@value}"
			end
			if to_return.length == 1
				to_return = " " + to_return 
			end
			return to_return
		end
			
		def to_str
			to_s
		end

		def to_message
			to_return = []
			to_return.push(Message.new("#{to_s}"))
			return to_return
		end
	end
end