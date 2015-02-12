require "curses"

class Display
	attr_reader :game_window, :input_window

	def initialize
		@main_window = Curses::Window.new(0, 0, 0, 0)
		@game_window = @main_window.subwin(@main_window.maxy-3, 0, 0, 0)
		@input_window = @main_window.subwin(3, 0, @main_window.maxy-3, 0)   
		@main_window.refresh
	end

	def send_data_to_game_window(data)
		@game_window.clear
		@game_window.addstr(data)
		@game_window.refresh
	end

	def send_data_to_input_window(data)
		@input_window.clear
		@input_window.addstr(data)
		@input_window.refresh
	end

	def press_key_to_continue(message)
		@input_window.clear
		@input_window.addstr("#{message}\nPress any key to continue.")
		return @input_window.getch
	end

	def fetch_data_from_input_window
		return @input_window.getstr
	end 
end