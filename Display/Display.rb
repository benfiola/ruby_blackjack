require "curses"
require "pry"
include Curses
class Display
	attr_reader :game_window, :input_window

	def initialize
		@main_window = Window.new(0, 0, 0, 0)
		@game_window = @main_window.subwin(@main_window.maxy-3, 0, 0, 0)
		@input_window = @main_window.subwin(3, 0, @main_window.maxy-3, 0)
		start_color
		use_default_colors
		init_color(COLOR_GREEN, 0, 0, 1000)
		init_color(COLOR_RED, 1000, 0, 0)
		init_color(COLOR_BLUE, 0, 0, 1000)
		init_color(COLOR_WHITE, 1000, 1000, 1000)
		init_pair(COLOR_GREEN, COLOR_GREEN, -1)
		init_pair(COLOR_RED, COLOR_RED, -1)
		init_pair(COLOR_WHITE, COLOR_WHITE, -1)   
		init_pair(COLOR_BLUE, COLOR_BLUE, -1)   
		@main_window.refresh

	end

	def send_data_to_game_window(data)
		@game_window.clear
		for message in data
			case message.color 
				when "white"
					attribute = (color_pair(COLOR_WHITE)|A_BOLD)
				when "red"
					attribute = (color_pair(COLOR_RED)|A_NORMAL)
				when "green"
					attribute = (color_pair(COLOR_BLUE)|A_NORMAL)
			end
			@game_window.attron(attribute)
			@game_window.addstr(message.data)
			@game_window.attroff(attribute)

		end
		@game_window.refresh
	end

	def send_data_to_input_window(data)
		@input_window.clear
		for message in data
			case message.color 
				when "white"
					attribute = (color_pair(COLOR_WHITE)|A_NORMAL)
				when "red"
					attribute = (color_pair(COLOR_RED)|A_NORMAL)
				when "green"
					attribute = (color_pair(COLOR_GREEN)|A_NORMAL)
			end
			@input_window.attron(attribute)
			@input_window.addstr(message.data)
			@input_window.attroff(attribute)
		end
		@input_window.refresh
	end

	def press_key_to_continue(message)
		@input_window.clear
		for data in message
			@input_window.addstr(data.data)
		end
		@input_window.addstr("Press any key to continue.")
		return @input_window.getch
	end

	def fetch_data_from_input_window
		return @input_window.getstr
	end 
end