# encoding: utf-8

class Raffle

	PluginLoader.registerPlugin("Raffle", self)

	def self.getInstance(messager = nil, logger = nil)
		if @instance == nil
			@instance = Raffle.new(messager, logger)
		end
		return @instance
	end

	def initialize(messager, logger)
		@messager = messager
		@users = []
		@running = false
	end

	def start()
		@users = []
		@running = true
		@messager.message("Raffle started. Type !raffle into chat to enter.")
	end

	def end
		@running = false
		if @users.length > 0
			@messager.message("User " + @users.sample + " wins the raffle.")
		else
			@messager.message("No user entered the raffle.")
		end

	end

	def add(user)
		@users << user if @running and !(@users.include?(user))
	end

	def self.addPlugin()
		PluginLoader.addCommand(Command.new("!startraffle", lambda do |data, priv, user|

			if priv <= 10
				getInstance.start
			end
		end))
		PluginLoader.addCommand(Command.new("!endraffle", lambda do |data, priv, user|
			if priv <= 10
				getInstance.end()
			end
		end))
		PluginLoader.addCommand(Command.new("!raffle", lambda do |data, priv, user|
			getInstance.add(user)
		end))
	end
end
