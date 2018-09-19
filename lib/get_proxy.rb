module Get
	class Proxy

		def initialize()
			LOG.new.delete("logs/socks_list.txt")
			server_url 	= server_url()
			count 		= 0..server_url.size.to_i - 1
			count.each_with_index do |x|
				curl(server_url[x])
			end
		end

		def curl(target)

			print "- connecting to server #{target} .......\n".yellow
			source = open("http://www.#{target}").read
			getTitle = source.scan(/\sitemprop\=\'name\'>\n<a href\s*=\s*'(http:[^"]*[^"]*[\/0-9a-zA-Z\-\.]*html)/).flatten { |x| return true }
			if source
				for i in 0..getTitle.length - 1
					source 	= open(getTitle[i]).read
					getLists = source.scan(/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,5})/).flatten { |x| return true }
					print "- fetching proxy lists from server #{target} .......".green
					print "[#{getLists.length} proxy added] \n"
					for x in 0..getLists.length
						if getLists[x] != "" || getLists[x] != nil
							LOG.new.create("logs/socks_list.txt","#{getLists[x]}")
						end
					end
				end

			else
				exit
			end

		end

		def server_url
			return 	[
						"live-socks.net",
						"socks24.org"
					]
		end

	end
end