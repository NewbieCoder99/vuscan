module Md5

	$b 			= 	0
	$c 			= 	1
	$d 			= 	1
	$e 			= 	1
	$hk 		= 	'wordlists/hk.txt'
	$hb			=	'wordlists/hb.txt'
	$ak			= 	'wordlists/ak.txt'
	$sym		=	'wordlists/sym.txt'
	$tmp_f		=	'logs/tmp.txt'
	$cache_path	=	'cache'
	$arr 		= []

	class Decrypter

		def initialize()
			print "\n- How long character password your check now? : "
			lchar = gets.to_i
			print "- Input md5 password : "
			password = gets.chomp
			if password == ""
				puts "Please input your md5 password!"
				exit
			elsif lchar == ""
				puts "Please input long character!"
				exit
			end
			_main_(lchar,password)
		end

		def _main_(lchar,password)
			LOG.new.delete($tmp_f)
			kal = 1

			for x in 1..lchar.to_i
				kal = 4 * kal
			end # Menghitung banyaknya yang harus dikalikan

			for x in 1..4
				if lchar > 1
					for i in 1..kal
						if i % 4 == 0

							if lchar == 2

								$b = $b + 1
								if $b >= 5
									$b = 1
									# puts
								end
								LOG.new.create($tmp_f,"#{x}|#{$b}")

							elsif lchar == 3

								$b = $b + 1
								if $b >= 5
									$b = 1
									$c = $c + 1
									if $c >= 5
										$c =1
										# puts
									end
								end
								LOG.new.create($tmp_f,"#{x}|#{$b}|#{$c}")

							elsif lchar == 4

								$b = $b + 1
								if $b >= 5
									$b = 1
									$c = $c + 1
									if $c >= 5
										$c =1
										$d = $d + 1
										if($d >= 5)
											$d = 1
										end
									end
								end
								LOG.new.create($tmp_f,"#{x}|#{$b}|#{$c}|#{$d}")

							elsif lchar == 5

								$b = $b + 1
								if $b >= 5
									$b = 1
									$c = $c + 1
									if $c >= 5
										$c =1
										$d = $d + 1
										if($d >= 5)
											$d = 1
											$e = $e + 1
											if($e >= 5)
												$e = 1
											end
										end
									end
								end
								LOG.new.create($tmp_f,"#{x}|#{$b}|#{$c}|#{$d}|#{$e}")
							end

						end
					end
				else
					LOG.new.create($tmp_f,"#{x}")
				end
			end

			if lchar == 1
				if_1(password)
			elsif lchar == 2
				if_2(password)
			elsif lchar == 3
				if_3(password)
			elsif lchar == 4
				if_4(password)
			elsif lchar == 5
				if_5(password)
			end

		end

		def search_in_db(xpass)
			data = $dbcon[:password].find({:_id => xpass})
			data.each_with_index do |x|
				puts
				puts "- MD5 password : #{x['_id']} | Plaintext : #{x['text']}".white
				puts
			end
		end

		def insert_to_db(_id,text)
			begin
				data = {:_id => "#{_id}", :text => "#{text}"}
				$dbcon[:password].insert_one(data, {:unique => true})
				$dbcon.close
			rescue
			end
		end

		def if_1(password)

			if $dbcon[:password].count({:_id => password}) == 1
				search_in_db(password)
			else
				files = File.readlines($tmp_f)
				fsize = 0..files.size.to_i - 1
				fsize.each_with_index do |l|
					a = get_dict(rmv_nl(files[l]))

					x_Array 	= 0..a.size.to_i - 1
					x_Array.each do |x|
						msg = rmv_nl("#{a[x]}")
						passEnc = Digest::MD5.hexdigest("#{msg}")
						if passEnc == password
							msg 	= "\n- #{password} match With #{passEnc} #{msg}\n".green
							puts msg
							LOG.new.delete("logs/md5/#{passEnc}.txt")
							LOG.new.create("logs/md5/#{passEnc}.txt","#{msg}")
							exit
						else

							puts "- #{passEnc} #{msg} #{l + 1}/#{files.size.to_i}"
							insert_to_db(passEnc,msg)
						end
					end

				end
			end
		end

		def if_2(password)

			if $dbcon[:password].count({:_id => password}) == 1
				search_in_db(password)
			else
				files = File.readlines($tmp_f)
				fsize = 0..files.size.to_i - 1
				fsize.each_with_index do |l|

					splitData = files[l].split("|")
					a = get_dict(rmv_nl(splitData[0]))
					b = get_dict(rmv_nl(splitData[1]))

					x_Array 	= 0..a.size.to_i - 1
					y_Array 	= 0..b.size.to_i - 1

					x_Array.each_with_index do |x|
						y_Array.each_with_index do |y|
							msg = rmv_nl("#{a[x]}#{b[y]}")
							passEnc = Digest::MD5.hexdigest("#{msg}")
							if passEnc == password
								msg 	= "\n- #{password} match With #{passEnc} #{msg}\n".green
								puts msg
								LOG.new.delete("logs/md5/#{passEnc}.txt")
								LOG.new.create("logs/md5/#{passEnc}.txt","#{msg}")
								exit
							else
								puts "- #{passEnc} #{msg} #{l + 1}/#{files.size.to_i}"
								insert_to_db(passEnc,msg)
							end
						end
					end

				end
			end

		end

		def if_3(password)
			if $dbcon[:password].count({:_id => password}) == 1
				search_in_db(password)
			else
				files 	= File.readlines($tmp_f)
				fsize 	= 0..files.size.to_i - 1
				fsize.each_with_index do |l|

					splitData = files[l].split("|")
					a = get_dict(rmv_nl(splitData[0]))
					b = get_dict(rmv_nl(splitData[1]))
					c = get_dict(rmv_nl(splitData[2]))

					x_Array 	= 0..a.size.to_i - 1
					y_Array 	= 0..b.size.to_i - 1
					z_Array 	= 0..c.size.to_i - 1

					x_Array.each_with_index do |x|
						y_Array.each_with_index do |y|
							z_Array.each_with_index do |z|
								msg = rmv_nl("#{a[x]}#{b[y]}#{c[z]}")
								passEnc = Digest::MD5.hexdigest("#{msg}")
								if passEnc == password
									msg 	= "\n- #{password} match With #{passEnc} #{msg}\n".green
									puts msg
									LOG.new.delete("logs/md5/#{passEnc}.txt")
									LOG.new.create("logs/md5/#{passEnc}.txt","#{msg}")
									exit
								else
									puts "- #{passEnc} #{msg} #{l + 1}/#{files.size.to_i}"
									insert_to_db(passEnc,msg)
								end
							end
						end
					end

				end
			end
		end

		def if_4(password)
			if $dbcon[:password].count({:_id => password}) == 1
				search_in_db(password)
			else
				files 	= File.readlines($tmp_f)
				fsize 	= 0..files.size.to_i - 1
				fsize.each_with_index do |l|

					splitData = files[l].split("|")

					a = get_dict(rmv_nl(splitData[0]))
					b = get_dict(rmv_nl(splitData[1]))
					c = get_dict(rmv_nl(splitData[2]))
					d = get_dict(rmv_nl(splitData[3]))

					x_Array 	= 0..a.size.to_i - 1
					y_Array 	= 0..b.size.to_i - 1
					z_Array 	= 0..c.size.to_i - 1
					x1_Array 	= 0..d.size.to_i - 1

					x_Array.each_with_index do |x|
						y_Array.each_with_index do |y|
							z_Array.each_with_index do |z|
								x1_Array.each_with_index do |x1|
									msg = rmv_nl("#{a[x]}#{b[y]}#{c[z]}#{d[x1]}")
									passEnc = Digest::MD5.hexdigest("#{msg}")

									if passEnc == password
										msg 	= "\n- #{password} match With #{passEnc} #{msg}\n".green
										puts msg
										LOG.new.delete("logs/md5/#{passEnc}.txt")
										LOG.new.create("logs/md5/#{passEnc}.txt","#{msg}")
										exit
									else
										puts "- #{passEnc} #{msg} #{l}/#{files.size.to_i}"
										insert_to_db(passEnc,msg)
									end
								end
							end
						end
					end

				end
			end

		end

		def if_5(password)

			files = File.readlines($tmp_f)
			fsize = 0..files.size.to_i - 1

			fsize.each do |l|

				splitData = files[l].split("|")

				a = get_dict(rmv_nl(splitData[0]))
				b = get_dict(rmv_nl(splitData[1]))
				c = get_dict(rmv_nl(splitData[2]))
				d = get_dict(rmv_nl(splitData[3]))
				e = get_dict(rmv_nl(splitData[4]))

				x_Array 	= 0..a.size.to_i - 1
				y_Array 	= 0..b.size.to_i - 1
				z_Array 	= 0..c.size.to_i - 1
				x1_Array 	= 0..d.size.to_i - 1
				y1_Array 	= 0..e.size.to_i - 1

				x_Array.each_with_index do |x|
					y_Array.each_with_index do |y|
						z_Array.each_with_index do |z|
							x1_Array.each_with_index do |x1|
								y1_Array.each_with_index do |y1|
									msg = rmv_nl("#{a[x]}#{b[y]}#{c[z]}#{d[x1]}#{e[y1]}")
									passEnc = Digest::MD5.hexdigest("#{msg}")
									if passEnc == password
										msg 	= "\n- #{password} match With #{passEnc} #{msg}\n".green
										puts msg
										LOG.new.delete("logs/md5/#{passEnc}.txt")
										LOG.new.create("logs/md5/#{passEnc}.txt","#{msg}")
										exit
									else
										puts "- #{passEnc} #{msg} #{l + 1}/#{files.size.to_i}"
									end
								end # End Loop y
							end # End Loop x1
						end # End Loop z
					end # End Loop y 
				end # End Loop x
			end

		end

		def msg_show(password,plaintext,cachePath,formula)
			passEnc = Digest::MD5.hexdigest("#{plaintext}")
			if passEnc == password
				msg 	= "\n- #{formula} ||  #{password} match With #{passEnc} #{plaintext} [Cracked]\n".green
				print msg
				LOG.new.delete("logs/md5/#{passEnc}.txt")
				LOG.new.create("logs/md5/#{passEnc}.txt","#{plaintext}")
				exit
			else
				print "- #{passEnc} #{plaintext} #{formula}"
			end
		end

		def rmv_nl(param)
			return param.gsub("\n","")
		end

		def get_dict(x)
			if x.to_i == 1
				return File.readlines($hk)
			elsif x.to_i == 2
				return File.readlines($hb)
			elsif x.to_i == 3
				return File.readlines($ak)
			elsif x.to_i == 4
				return File.readlines($sym)
			else
				return false
			end
		end

	end # End Class
end # End Module