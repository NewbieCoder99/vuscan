#!/usr/bin/ruby
Mongo::Logger.logger.level = ::Logger::FATAL

begin

	$dbcon = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'vuscan')

rescue Excetion => e
	puts e.message
	exit
end