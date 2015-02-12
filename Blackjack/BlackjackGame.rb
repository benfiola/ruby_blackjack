require "./Blackjack/BlackjackDealer.rb"
require "./Blackjack/BlackjackPlayer.rb"
require "./Blackjack/BlackjackDeck.rb"
require "curses"

class BlackjackGame
	attr_reader :players, :curr_player, :dealer, :deck
	def initialize(display)
		@display = display
		num_players = get_num_players.to_i
		if num_players <= 0
			throw RuntimeException, "Need a positive number of players"
		end
		@players = []
		for i in 0...num_players
			@players.push(BlackjackPlayer.new(i+1, 1000, self))
		end
		@dealer = BlackjackDealer.new self
		@deck = BlackjackDeck.new(1)
	end

	def get_num_players
		@display.send_data_to_input_window("How many players?\n")
		return @display.fetch_data_from_input_window
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
		for player in @players
			@curr_player = player
			player.place_bet(get_bet, player.curr_hand)
		end
		@dealer.curr_hand.add_card(@deck.grab_card)
		for player in @players
			player.curr_hand.add_card(@deck.grab_card)
		end
		for player in @players
			player.curr_hand.add_card(@deck.grab_card)
			@curr_player = player
			while(get_action(player))
			end
		end
		@dealer.take_action
	end

	def get_bet
		@display.send_data_to_game_window("#{self}")
		@display.send_data_to_input_window("Player #{@curr_player.number} 's bet : ")
		bet = @display.fetch_data_from_input_window
		return bet.to_i
	end

	def get_action(player)
		@display.send_data_to_game_window("#{self}")
		@display.send_data_to_input_window("What would Player #{@curr_player.number} like to do?\nPlayer #{@curr_player.number} can choose to [h]it, [s]tay, [d]ouble, s[p]lit, or [q]uit : \n")
		action = @display.fetch_data_from_input_window
		if(action == "q")
			exit(0)
		elsif(action == "s")
			return false
		else
			player.take_action(action)
		end
	end

	def request_card
		@deck.grab_card
	end

	def to_s
		str = "\r#{dealer}\n"
		for player in @players
			str = str + "#{player}\n"
		end
		str += "=========================\n"
		return str
	end
end
