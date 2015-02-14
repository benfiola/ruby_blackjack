require_relative "./Hand.rb"
require_relative "./Card.rb"

module Generic
	class Player
		attr_reader :hands, :curr_hand, :number, :game, :money

		def initialize(number, money, game)
			raise RuntimeError, "Can't initialize generic Player"
		end

		def clear_hands 
			@hands = []
			@curr_hand = nil
		end

		def add_hand(hand)
			@hands.push(hand)
		end

		def set_curr_hand(hand)
			@curr_hand = hand
		end

		def place_bet(bet, hand) 
			if bet > @money
				raise RuntimeError, "Player placing bet larger than current money"
			end
			@money = @money - bet
			hand.place_bet(bet)
		end

		def receive_money(to_add)
			@money = @money + to_add
		end

		def receive_card(card)
			@curr_hand.add_card(card)
		end

		def take_action(*args)
			raise RuntimeError, "Generic player cannot take an action."
		end

		def to_str
			to_s
		end

		def to_s
			"Player #{@number} - $#{@money} - #{@curr_hand}"
		end

		def to_message
			to_return = []
			if @game.curr_player == self
				to_return.push(Message.new(">"))
			else
				to_return.push(Message.new(" "))
			end
			to_return.push(Message.new("Player #{@number} ("))
			to_return.push(Message.new("$#{@money}", "green"))
			to_return.push(Message.new(")\t"))
			to_return.push(*@curr_hand.to_message)
			for hand in @hands
				if hand != @curr_hand
					to_return.push(Message.new("\n\t\t"))
					to_return.push(*hand.to_message)
				end
			end
			return to_return
		end
	end
end