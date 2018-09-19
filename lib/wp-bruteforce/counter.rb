module Wp

	$p_log 	= "logs/wp-bruteforce/"
	$b 		= 0
	$f 		= 1
	$g 		= 1

	class Counter

		def initialize(lc)
			delete_logs(lc)
			if_1()
			if_2()
			if_3()
			if_4()
			if_5()
			if_6()
			if_7()
		end

		def delete_logs(lc)
			for x in 1..7
				if x == lc
					LOG.new.delete("#{$p_log}#{x}.txt")
				end
			end
		end

		def kal(numb)
			kal = 1
			for x in 1..numb
				kal = 4 * kal
			end # Menghitung banyaknya yang harus dikalikan
			return kal
		end

		def if_1()
			for x in 1..4
				LOG.new.create("#{$p_log}1.txt","#{x}")
			end
		end

		def if_2()
			kal = kal(2)
			for x in 1..4
				for i in 1..kal
					if i % 4 == 0
						$b = $b + 1
						if $b >= 5
							$b = 1
						end
						LOG.new.create("#{$p_log}2.txt","#{x}|#{$b}")
					end
				end
			end
		end

		def if_3()
			kal = kal(3)
			for x in 1..4
				for i in 1..kal
					if i % 4 == 0
						$b = $b + 1
						if $b >= 5
							$b = 1
							$c = $c + 1
							if $c >= 5
								$c =1
							end
						end
						LOG.new.create("#{$p_log}3.txt","#{x}|#{$b}|#{$c}")
					end
				end
			end
		end

		def if_4()
			kal = kal(4)
			for x in 1..4
				for i in 1..kal
					if i % 4 == 0
						$b = $b + 1
						if $b >= 5
							$b = 1
							$c = $c + 1
							if $c >= 5
								$c =1
								$d = $d + 1
								if $d >= 5
									$d = 1
								end
							end
						end
						LOG.new.create("#{$p_log}4.txt","#{x}|#{$b}|#{$c}|#{$d}")
					end
				end
			end
		end

		def if_5()
			kal = kal(5)
			for x in 1..4
				for i in 1..kal
					if i % 4 == 0
						$b = $b + 1
						if $b >= 5
							$b = 1
							$c = $c + 1
							if $c >= 5
								$c =1
								$d = $d + 1
								if $d >= 5
									$d = 1
									$e = $e + 1
									if $e >= 5
										$e = 1
									end
								end
							end
						end
						LOG.new.create("#{$p_log}5.txt","#{x}|#{$b}|#{$c}|#{$d}|#{$e}")
					end
				end
			end
		end

		def if_6()
			kal = kal(6)
			for x in 1..4
				for i in 1..kal
					if i % 4 == 0
						$b = $b + 1
						if $b >= 5
							$b = 1
							$c = $c + 1
							if $c >= 5
								$c =1
								$d = $d + 1
								if $d >= 5
									$d = 1
									$e = $e + 1
									if $e >= 5
										$e = 1
										$f = $f + 1
										if $f >= 5
											$f = 1
										end
									end
								end
							end
						end
						LOG.new.create("#{$p_log}6.txt","#{x}|#{$b}|#{$c}|#{$d}|#{$e}|#{$f}")
					end
				end
			end
		end

		def if_7()
			kal = kal(7)
			for x in 1..4
				for i in 1..kal
					if i % 4 == 0
						$b = $b + 1
						if $b >= 5
							$b = 1
							$c = $c + 1
							if $c >= 5
								$c =1
								$d = $d + 1
								if $d >= 5
									$d = 1
									$e = $e + 1
									if $e >= 5
										$e = 1
										$f = $f + 1
										if $f >= 5
											$f = 1
											$g = $g + 1
											if $g >= 5
												$g = 1
											end
										end
									end
								end
							end
						end
						LOG.new.create("#{$p_log}7.txt","#{x}|#{$b}|#{$c}|#{$d}|#{$e}|#{$f}|#{$g}")
					end
				end
			end
		end

	end # End Class

end # End Module