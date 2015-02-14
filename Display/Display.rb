require "curses"
require_relative "./Message.rb"

include Curses

# For this class, the main_window represents the entire terminal window.
# The game_window is the section of the main_window that communicates data 
# about the game in its current state.
# The input_window is the bottom section of the main_window that prompts the
# user for input.
class Display
	attr_reader :game_window, :input_window

	def initialize
		@main_window = Window.new(0, 0, 0, 0)
		@game_window = @main_window.subwin(@main_window.maxy-3, 0, 0, 0)
		@game_window.setscrreg(0, @main_window.maxy-3)
		@game_window.scrollok(true)
		@input_window = @main_window.subwin(3, 0, @main_window.maxy-3, 0)
		start_color
		use_default_colors
		Curses.TABSIZE=12
		init_pair(COLOR_GREEN, COLOR_GREEN, -1)
		init_pair(COLOR_RED, COLOR_RED, -1)
		init_pair(COLOR_WHITE, COLOR_WHITE, -1)   
		init_pair(COLOR_BLUE, COLOR_BLUE, -1)
		init_pair(COLOR_YELLOW, COLOR_YELLOW, -1)   
		init_pair(COLOR_MAGENTA, COLOR_MAGENTA, -1)
		@main_window.refresh
	end

	# sends data to the main window of the application (showing all players, hands, etc.)
	def send_data_to_game_window(data)
		@game_window.clear
		flush_data(data, @game_window)
		@game_window.refresh
	end

	# sends data to the window at the bottom of the application (prompting user for input)
	def send_data_to_input_window(data)
		@input_window.clear
		flush_data(data, @input_window)
		@input_window.refresh
	end

	# it's good practice to close all open windows once the application
	# terminates.
	def close
		@input_window.close
		@game_window.close
		@main_window.close
	end

	# send data to curses window, making sure to set the correct
	# color attributes before doing so.
	def flush_data(data, window)
		for message in data
			case message.color 
				when "white"
					attribute = (color_pair(COLOR_WHITE)|A_NORMAL)
				when "red"
					attribute = (color_pair(COLOR_RED)|A_NORMAL)
				when "green"
					attribute = (color_pair(COLOR_GREEN)|A_NORMAL)
				when "yellow"
					attribute = (color_pair(COLOR_YELLOW)|A_NORMAL)
				when "blue"
					attribute = (color_pair(COLOR_BLUE)|A_NORMAL)
				when "magenta"
					attribute = (color_pair(COLOR_MAGENTA)|A_NORMAL)
			end
			window.attron(attribute)
			window.addstr(message.data)
			window.attroff(attribute)
		end
	end

	# This method is a particular case - say we want to print something
	# to the input_window and prompt the user to 'press any key' to continue.
	# We might not necessarily need to say anything besides 'Press any key to continue'
	# so we make arguments optional.  If there is anything to print, it will be in args[0].
	def press_key_to_continue(*args)
		@input_window.clear
		if(args.length > 0) 
			flush_data(args[0], @input_window)
		end
		@input_window.addstr("Press any key to continue.")
		return @input_window.getch
	end

	# Gets a string input from the window (blocks until 'enter' is pressed)
	def fetch_data_from_input_window
		return @input_window.getstr
	end 
end