module Github

	$domain 	= "https://github.com"
	$path_logs	= "logs/github_commit_logs"

	class Dorker

		def initialize()
			print "\n- Input your keyword :  "
			keyword = gets.chomp.gsub(/\s/,'+')
			LOG.new.delete_folder($path_logs)
			get_first_page(keyword)
		end # End Methode initialize

		def get_first_page(keyword)

			begin

				uri  		= URI($domain + "/search?utf8=%E2%9C%93&q=#{keyword.chomp}&type=Commits")
				http 		= Net::HTTP.new(uri.host, uri.port)
				http.use_ssl = true
				response 	= http.request(Net::HTTP::Get.new(uri))
				
				if response.code == '200'
					gp 		= response.body.scan(/\/search\?p\=([a-z0-9]+)/).flatten { |x| return true }
					mnp 	= 0
					if gp.length > 0
						for i in 0..gp.length - 1
							if gp[i].to_i > mnp.to_i
								mnp = gp[i]
							end
						end
						for x in 1..mnp.to_i
							page = $domain + "/search?p=#{x.to_i}&q=#{keyword}&type=Commits&utf8=%E2%9C%93"
							puts "- Scrap to page " + "#{page}".white
							get_to_page(page,keyword)
							sleep(1)
						end
					else
						puts "- We couldn’t find any commits matching '#{keyword}'".yellow
					end
				else
					puts "- Error code #{response.code} load page!"
				end

			rescue Exception => e
				puts e.message
			end

		end # End Methode get_first_page

		def get_to_page(page,keyword)
			begin
				uri  		= URI(page)
				http 		= Net::HTTP.new(uri.host, uri.port)
				http.use_ssl = true
				response 	= http.request(Net::HTTP::Get.new(uri))

				if response.code == '200'
					gc 	= response.body.scan(/data\-pjax\=\"true\"\shref\=\"([a-zA-Z0-9\/\-\.\_\+]+)/).flatten { |x| return true }

					if gc.length >= 1
						for i in 0..gc.length - 1
							create_folder = LOG.new.create_folder($path_logs + gc[i])
							if create_folder
								page = $domain + gc[i]
								get_to_commit(page,$path_logs + gc[i])
								# puts "-	" + $path_logs + "#{gc[i]}".yellow + " created."
								sleep(1)
							end

						end
					else
						puts "- Cannot inspect commit."
					end

				else
					puts "- Error code #{response.code} load page!"
				end

			rescue Exception => e
				puts e.message
			end
		end

		def get_to_commit(page, folder)
			begin

				uri  		= URI(page)
				http 		= Net::HTTP.new(uri.host, uri.port)
				http.use_ssl = true
				response 	= http.request(Net::HTTP::Get.new(uri))
				if response.code == '200'
					fsplit = folder.split("/")
					filenamed 	= "#{folder}/#{fsplit[3]}.html"
					create_file = LOG.new.create(filenamed,response.body)
					if create_file
						puts "-	  " + "#{filenamed}".yellow + " created."
					end
				else
					puts "- Cannot load to page #{page}".yellow
				end

			rescue Exception => e
				puts e.message
			end
		end

	end # End Class
end # End Module