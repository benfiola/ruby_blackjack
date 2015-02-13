class Message
	attr_reader :data, :color

	# initializes a Message with one or two arguments
	# the first should always be the data in the message
	# the second should always be the color of the message
	def initialize(*args)
		if args.length == 1
			@data = args[0]
			@color = "white"
		elsif args.length >= 2
			@data = args[0]
			@color = args[1]
		end
	end

	def to_s
		"Message - data : #{@data}, color : #{@color}"
	end

	def to_str
		to_s
	end
end