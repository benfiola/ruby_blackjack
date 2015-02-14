require_relative "./BlackjackCard.rb"
require_relative "./BlackjackDealer.rb"
require_relative "./BlackjackHand.rb"
require_relative "./BlackjackPlayer.rb"
require_relative "./BlackjackDeck.rb"
require_relative "../Display/Display.rb"
require_relative "../Display/Message.rb"

# This helper class lets us check to see if a String input
# is numeric
class String
	def is_number?
		begin
			Integer(self)
			return true
		rescue
			return false
		end
	end
end

class BlackjackGame
	attr_reader :players, :curr_player, :dealer, :deck

	# when we first start the game, there's a few things we need
	# to retrieve before the game starts - this initializer will
	# fetch the number of players desired, and initialize all the
	# players in the game (the deck is re-initialized every round, 
	# you can find this in )
	def initialize(display)
		@display = display
		num_players = get_num_players
		@players = []
		for i in 0...num_players
			@players.push(BlackjackPlayer.new(i+1, 1000, self))
		end
		@dealer = BlackjackDealer.new self
	end

	# this method is mainly just the game loop.  since we call exit
	# when the user manually exits the game, the only exit condition we're
	# looking for is the one out of our user's control - when all players
	# have run out of money.
	def go
		while @players.length > 0
			reset_round
			do_round
		end
		game_over
	end

	# can't have a complete game without a game over screen.
	def game_over
		message_arr = []
		message_arr.push(Message.new("Game over!  Thanks for playing!", "green"))
		@display.send_data_to_game_window(message_arr)
		@display.press_key_to_continue
		exit(0)
	end

	# before a round is started, we need to initialize the round-state.
	# we do this here.
	def reset_round
		# just so we never need to worry about running out of cards
		# lets add decks depending on how many players are playing.
		# for every 10 players, let's add another deck (assuming an average of 5 cards
		# per person per round)
		@deck = BlackjackDeck.new((@players.length/10)+1)

		# re-setting a round just means that we clear all hands
		# and add empty hands to all players (including the dealer)
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

	# this method does a round of blackjack.
	def do_round		
		# first, all players need to make a bet
		for player in @players
			@curr_player = player
			player.place_bet(get_bet, player.curr_hand)
			update_display
		end

		# now, the dealer needs a card (just one) that's visible to all players
		@dealer.curr_hand.add_card(@deck.grab_card)

		# now, let's deal cards to all players
		for player in @players
			player.curr_hand.add_card(@deck.grab_card)
			player.curr_hand.add_card(@deck.grab_card)
		end

		update_display

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

		@curr_player = nil

		# finally the dealer takes action
		@dealer.take_action

		# dole out the winnings (if there are any)
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
				else 
					hand.set_winnings 0
				end
			end
		end

		# update our display and give the user the chance to process what happened
		update_display
		message_arr = []
		message_arr.push(Message.new("The round has ended.\n"))
		@display.press_key_to_continue(message_arr)

		# let's get rid of all players who have no money and can no longer gamble
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

	# since all players have access to the 'game' object, when they 
	# want a card, they request it from the game itself (since the game
	# holds the deck)
	def request_card
		@deck.grab_card
	end


	## INPUT RELATED METHODS ##
	# this method handles retrieving a bet for each user.
	def get_bet
		update_display
		message_arr = []
		message_arr.push(*print_quit_message)
		message_arr.push(Message.new("Player #{@curr_player.number}'s bet : "))
		bet = prompt_user_for_input(message_arr)
		while( bet != "q" && (!bet.is_number? || bet.to_i <= 0 || bet.to_i > @curr_player.money) )
			bet = prompt_user_for_input(message_arr)
		end
		if(bet == "q")
			exit(0)
		end
		return bet.to_i
	end

	# this method handles a particular player's turn with a given hand.
	def handle_action(player)
		update_display
		message_arr = []
		message_arr.push(*print_quit_message)
		message_arr.push(*player.get_action_message)
		while(!player.take_action(prompt_user_for_input(message_arr)))
			update_display
			message_arr = []
			message_arr.push(*print_quit_message)
			message_arr.push(*player.get_action_message)
		end
	end

	# this method handles retrieving the number of players at the beginning
	# of the game.
	def get_num_players
		message_arr = []
		message_arr.push(*print_quit_message)
		message_arr.push(Message.new("How many players?\n"))
		num_players = prompt_user_for_input(message_arr)
		while(num_players != "q" && (!num_players.is_number? || num_players.to_i <= 0) )
			num_players = prompt_user_for_input(message_arr)
		end
		if(num_players == "q")
			exit(0)
		end
		return num_players.to_i
	end

	# convenience method to collect input from the user.
	def prompt_user_for_input(message)
		@display.send_data_to_input_window(message)
		return @display.fetch_data_from_input_window
	end

	## OUTPUT (?) RELATED METHODS ##
	# a convenience method to refresh the game window
	def update_display
		@display.send_data_to_game_window(self.to_message)
	end

	# this is a convenience method to prepare a 'quit'
	# message that can later be sent to the screen
	def print_quit_message
		message_arr = []
		message_arr.push(Message.new("Type "))
		message_arr.push(Message.new("q", "red"))
		message_arr.push(Message.new(" to quit.\n"))
		return message_arr
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
