require "./Blackjack/BlackjackDealer.rb"
require "./Blackjack/BlackjackPlayer.rb"
require "./Blackjack/BlackjackDeck.rb"
require "curses"

class BlackjackGame
	attr_reader :players, :curr_player, :dealer, :deck
	def initialize(display)
		@display = display
		num_players = get_num_players("").to_i
		while num_players <= 0
			num_players = get_num_players("Please enter a positive integer.\n").to_i
		end
		@players = []
		for i in 0...num_players
			@players.push(BlackjackPlayer.new(i+1, 1000, self))
		end
		@dealer = BlackjackDealer.new self
		@deck = BlackjackDeck.new(1)
	end

	def go
		while(true)
			reset_round
			do_round
		end
	end

	def reset_round
		@dealer.clear_hands
		@dealer.set_hand(BlackjackHand.new)
		for player in @players
			player.clear_hands
			player.set_hand(BlackjackHand.new)
		end
	end

	def do_round
		# first, all players need to make a bet
		for player in @players
			@curr_player = player
			player.place_bet(get_bet(""), player.curr_hand)
		end

		# now, the dealer needs a card (just one) that's visible to all players
		@dealer.curr_hand.add_card(@deck.grab_card)

		# now, let's deal cards to all players
		for player in @players
			player.curr_hand.add_card(@deck.grab_card)
			player.curr_hand.add_card(@deck.grab_card)
		end

		# here, each player will take a turn handling their hands - this means
		# a nested loop in the event that someone does split (which could theoretically happen)
		# multiple times.
		for player in @players
			@curr_player = player
			for hand in @curr_player.hands
				while(get_action(player, ""))
				end
			end
		end

		# finally the dealer takes action
		# and the round is finished after every hand is evaluated 
		@dealer.take_action

		for player in @players
			for hand in player.hands
				if hand.is_winner(@dealer.curr_hand.get_value)
					if hand.is_blackjack
						player.receive_money(((hand.bet) + (hand.bet * 1.2)).to_i)
					else
						player.receive_money(hand.bet + hand.bet)
					end
				elsif hand.is_push(@dealer.curr_hand.get_value)
					player.receive_money(hand.bet)
				end
			end
		end
		@display.send_data_to_game_window("#{self}")
		@display.press_key_to_continue("The round has ended.")
	end


	def get_bet(more_text)
		@display.send_data_to_game_window("#{self}")
		@display.send_data_to_input_window("Player #{@curr_player.number} 's bet : ")
		bet = @display.fetch_data_from_input_window
		return bet.to_i
	end

	def get_action(player, more_text)
		@display.send_data_to_game_window("#{self}")
		action_string = "Player #{@curr_player.number} can choose to "
		if(@curr_player.curr_hand.can_hit)
			action_string += "[h]it, "
		end
		if(@curr_player.curr_hand.can_double)
			action_string += "[d]ouble down, "
		end
		if(@curr_player.curr_hand.can_split)
			action_string += "s[p]lit, "
		end
		action_string += "[s]tay or [q]uit : \n"
		@display.send_data_to_input_window("#{action_string}")
		action = @display.fetch_data_from_input_window
		if(action == "q")
			exit(0)
		elsif(action == "s")
			return false
		else
			player.take_action(action)
			return true
		end
	end


	def get_num_players(more_text)
		@display.send_data_to_input_window("#{more_text}How many players?\n")
		return @display.fetch_data_from_input_window
	end

	def request_card
		@deck.grab_card
	end

	def to_s
		str = "\r#{dealer}\n"
		for player in @players
			str = str + "#{player}\n"
		end
		return str
	end
end
