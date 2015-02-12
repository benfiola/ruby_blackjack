module Generic
	class Player
		attr_reader :hands, :curr_hand, :number, :game

		def initialize(number, money, game)
			raise RuntimeError, "Can't initialize generic Player"
		end

		def clear_hands 
			@hands = []
			@curr_hand = nil
		end

		def set_hand(hand)
			@curr_hand = hand
			@hands.push(@curr_hand)
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

		def to_s_for_display(display)

		end
	end
end