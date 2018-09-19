module Reverse

	$uri_parse1 = 'https://www.yougetsignal.com/tools/web-sites-on-web-server/'
	$uri_parse2 = 'https://domains.yougetsignal.com/domains.php'

	class Ip

		def initialize()
			if system("gedit " + 'wordlists/domain_target.txt') == true
				wl 			= File.readlines('wordlists/domain_target.txt')
				wl_count 	= 0..wl.size.to_i - 1
				wl_count.each_with_index do |x|
					url = wl[x].gsub(/^https?\:\/\/(www.)?|\/|\n/,'')
					puts "==================================================================".white
					puts "- #{url}" + " processing...".yellow
					begin
						_main_(url)
					rescue Exception => e
						puts "- " + e.message.yellow
					end
				end
			end
		end

		def _main_(target)
			uri1  	= URI($uri_parse1)
			uri2  	= URI($uri_parse2)
			begin
				response = Net::HTTP.get_response(uri1)
				if response.code == '200'
					x 		= 	Net::HTTP::post_form(uri2,"key" => "", "remoteAddress" => target)
					parser 	= 	JSON.parse(x.body)
					if(parser['status'] == "Success")
						domainArray = parser['domainArray']
						count 		= 0..parser['domainArray'].size.to_i - 1
						count.each_with_index do |i|
							puts "-	#{domainArray[i][0]}".white
							LOG.new.create("logs/#{target}.txt",domainArray[i][0])
						end
					else
						puts "-	#{parser['message']}".yellow
					end
					# LOG.new.delete("logs/#{target}.txt")
				else
					puts "- Page not responding."
				end
			rescue Exception => e
				puts "- #{e.message}"
			end
		end

		# def get_proxy
		# 	p_list 	= File.readlines("logs/socks_list.txt")
		# 	count 	= p_list.size.to_i - 1
		# 	proxies	= p_list[rand(count)].split(":")
		# 	return [proxies[0],proxies[1]]
		# end

		def read_file
			return 'wordlists/reverse_ip.txt'
		end

	end # End Class

end # End Module