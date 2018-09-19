require './lib/wp-bruteforce/counter'
require './lib/wp-bruteforce/wpbf_execution'
require './lib/wp-bruteforce/wpbf_one'
require './lib/wp-bruteforce/wpbf_two'
require './lib/wp-bruteforce/wpbf_three'

module Wp

	$ua = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:59.0) Gecko/20100101 Firefox/59.0"

	class Bruteforce

		def initialize
			print 		"- Input Target : "
			target 	 	= gets.chomp
			print 		"- Input Username : "
			username 	= gets.chomp
			print 		"- Input Delay : "
			delay 		= gets.to_i
			print 		"- How long check password : "
			lc			= gets.to_i
			if /http|https/.match(target)
				puts "- Create log temp ..."
				Wp::Counter.new(lc.to_i)
				if lc == 1
					Wpbf::One.new(target,username,delay)
				elsif lc == 2
					Wpbf::Two.new(target,username,delay)
				elsif lc == 3
					Wpbf::Three.new(target,username,delay)
				end
			else
				puts "- Input domain with HTTP or HTTPS, Example : http://www.domain.com/".yellow
			end
		end

	end # End Class

end # End Module