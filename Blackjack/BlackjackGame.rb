require "./Blackjack/BlackjackCard.rb"
require "./Blackjack/BlackjackDealer.rb"
require "./Blackjack/BlackjackHand.rb"
require "./Blackjack/BlackjackPlayer.rb"
require "./Blackjack/BlackjackDeck.rb"
require "./Display/Display.rb"
require "./Display/Message.rb"

class String
	def is_number?
		begin
			Float(self)
			return true
		rescue
			return false
		end
	end
end

class BlackjackGame
	attr_reader :players, :curr_player, :dealer, :deck
	def initialize(display)
		@display = display
		num_players = get_num_players
		@players = []
		for i in 0...num_players
			@players.push(BlackjackPlayer.new(i+1, 1000, self))
		end
		@dealer = BlackjackDealer.new self
	end

	def go
		while @players.length > 0
			reset_round
			do_round
		end
		game_over
	end

	def game_over
		message_arr = []
		message_arr.push(Message.new("Game over!  Thanks for playing!", "green"))
		@display.send_data_to_game_window(message_arr)
		@display.press_key_to_continue
		exit(0)
	end

	def reset_round
		# just so we never need to worry about running out of cards
		# lets add decks depending on how many players are playing
		# for every 10 players, lets add another deck (assuming an average of 5 cards
		# per person per round)
		@deck = BlackjackDeck.new((@players.length/10)+1)
		@dealer.clear_hands
		new_hand = BlackjackHand.new
		@dealer.add_hand(new_hand)
		@dealer.set_curr_hand(new_hand)
		for player in @players
			player.clear_hands
			new_hand = BlackjackHand.new
			player.add_hand(new_hand)
			player.set_curr_hand(new_hand)
		end
	end

	def do_round
		to_remove = []
		# first, all players need to make a bet
		for player in @players
			@curr_player = player
			player.place_bet(get_bet, player.curr_hand)
			@display.send_data_to_game_window(self.to_message)
		end

		@display.send_data_to_game_window(self.to_message)

		# now, the dealer needs a card (just one) that's visible to all players
		@dealer.curr_hand.add_card(@deck.grab_card)

		# now, let's deal cards to all players
		for player in @players
			player.curr_hand.add_card(@deck.grab_card)
			player.curr_hand.add_card(@deck.grab_card)
		end

		# here, each player will take a turn handling their hands - this means
		# a nested loop in the event that someone splits (which could theoretically happen)
		# multiple times.
		for player in @players
			@curr_player = player
			for hand in @curr_player.hands
				@curr_player.set_curr_hand hand
				while(handle_action(player))
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
						hand.set_winnings hand.get_blackjack_winnings
						player.receive_money(hand.get_blackjack_winnings)
					else
						hand.set_winnings hand.get_regular_winnings
						player.receive_money(hand.get_regular_winnings)
					end
				elsif hand.is_push(@dealer.curr_hand.get_value)
					hand.set_winnings hand.bet
					player.receive_money(hand.bet)
				end
			end
		end

		@curr_player = nil
		@display.send_data_to_game_window(self.to_message)
		message_arr = []
		message_arr.push(Message.new("The round has ended."))
		@display.press_key_to_continue(message_arr)

		# sometimes, when you gamble, you lose all your money.  
		# rather than have these party-poopers suck up all the fun,
		# we'll delete them from our 'table' here.
		to_remove = []
		for player in @players
			if player.money <= 0
				to_remove.push player
			end
		end

		for player_to_remove in to_remove
			@players.delete player_to_remove
		end
	end


	def get_bet
		@display.send_data_to_game_window(self.to_message)
		message_arr = []
		message_arr.push(Message.new("Player #{@curr_player.number}'s bet : "))
		bet = prompt_user_for_input(message_arr)
		while(!bet.is_number? || bet.to_i <= 0 || bet.to_i > @curr_player.money)
			bet = prompt_user_for_input(message_arr)
		end
		return bet.to_i
	end

	def handle_action(player)
		@display.send_data_to_game_window(self.to_message)
		action = prompt_user_for_input(player.get_action_message)
		while(player.take_action(action))
			@display.send_data_to_game_window(self.to_message)
			action = prompt_user_for_input(player.get_action_message)
		end
	end


	def get_num_players
		message_arr = []
		message_arr.push(Message.new("How many players?\n"))
		num_players = prompt_user_for_input(message_arr)
		while(!num_players.is_number? || num_players.to_i <= 0)
			num_players = prompt_user_for_input(message_arr)
		end
		return num_players.to_i
	end

	def prompt_user_for_input(message)
		@display.send_data_to_input_window(message)
		return @display.fetch_data_from_input_window
	end


	# since all players have access to the 'game' object, when they 
	# want a card, they request it from the game itself (since the game
	# holds the deck)
	def request_card
		@deck.grab_card
	end

	# for debugging purposes, it doesn't hurt to be able to also
	# serialize the game (using ruby's string interpolation)
	def to_s
		str = "\r#{dealer}\n"
		for player in @players
			str = str + "#{player}\n"
		end
		return str
	end

	# this method converts the game into a displayable 'message'
	# that's passed to our display
	def to_message
		to_return = []
		to_return.push(*dealer.to_message)
		to_return.push(Message.new("\n"))
		for player in @players
			to_return.push(*player.to_message)
			to_return.push(Message.new("\n"))
		end
		return to_return
	end

end
