#!/usr/bin/ruby
require './loaders'

class Main

	def _main
		begin
			system("cat ascii.txt")
			data 	= read_db()
			for i in 0..data.size.to_i - 1
				splt = data[i].gsub("\n","")
				puts"#{i+1}).\s#{splt}"
			end

			print "\n" + EXPLOIT_INITIALIZE.new.func_name + " "
			numb = gets.to_i

			if Integer(numb) > 0
				dsplit = data[numb - 1].gsub(/\n/,'')
				print EXPLOIT_INITIALIZE.new.func_name + " #{dsplit}" + " [ selected ]\n".yellow
				if numb == 1
					Port::Scanner.new()
				elsif numb == 2
					Phpmyadmin::Scanner.new()
				elsif numb == 3
					Wp_plugin::Scanner.new()
				elsif numb == 4
					Cpanel::Bruteforce.new()
				elsif numb == 5
					Github::Dorker.new()
				elsif numb == 6
					Md5::Decrypter.new()
				elsif numb == 7
					Reverse::Ip.new()
				elsif numb == 8
					Google::Dork.new()
				elsif numb == 9
					Bypass::Login.new()
				elsif numb == 10
					Wp::Bruteforce.new()
				elsif numb == 11
					Wp::Dictionary.new()
				elsif numb == 12
					Url::Scrapper.new()
				else
					puts "Please select option with number 1 to #{data.size.to_i}"
				end
			else
				puts "Please select option with number 1 to #{data.size.to_i}"
			end
			puts "\n"
		rescue Interrupt => e
			puts "Bye Bye..."
		end
	end # ./End Method _Main

	def read_db
		return File.readlines('exploit.vuscan')
	end

end # ./End Class Main

Main.new._main