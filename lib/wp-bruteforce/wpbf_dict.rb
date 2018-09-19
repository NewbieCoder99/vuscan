module Wpbf

	class Dict

		def initialize(x)
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