module Benchmarks

	class Record

		def initialize(report)
			puts "- Benchmark results : "
			Benchmark.bm do |x|
			  x.report { report }
			end
		end

	end # End Class

end # End Module