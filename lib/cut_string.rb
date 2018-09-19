module Cut

	class String

		def initialize(string,startSplit,endSplit)

			x1 	= string.split("#{startSplit}")
			x2	= x1[1].split("\n")
			return x2[0]
		end

	end # End Class

end # End Module

