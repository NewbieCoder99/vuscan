module Wp_plugin

	class Scanner

		def initialize()
			if system("gedit " + 'wordlists/domain_target.txt') == true
				print "- Do you want to update plugin list before run...? (Y/N or y/n) : "
				opt = gets.chomp
				if opt == 'Y' || opt == 'y'
					list_updater()
				end
				wl 			= File.readlines('wordlists/domain_target.txt')
				wl_count 	= 0..wl.size.to_i - 1
				wl_count.each_with_index do |x|
					url = wl[x].gsub("\n","")
					puts "==================================================================".white
					puts "- #{url}" + " processing...".yellow
					begin
						if /https|http/.match(url)
							scanning(url)
						else
							puts "Please input domain with http:// or https://"
						end
					rescue Exception => e
						puts "- " + e.message.yellow
					end
				end
			end
		end # End Methode initialize

		def _main_(target,opt)
			if opt == 'Y' || opt == 'y'
				list_updater(target)
			elsif opt == 'N' || opt == 'n'
				scanning(target)
			else
				puts 'You can type N or Y'
			end
		end # End Methode _main_

		def scanning(target)
			lines = File.readlines(get_list())
			count = lines.size.to_i

			for i in 0..count - 1
				uri_path 		= "#{target}/wp-content/plugins/#{lines[i].chomp}/"
				response_code 	= detect_wp_plugin(uri_path)
				if response_code == "302" or response_code == "200" or response_code == "403"
					file_name 	= 'logs/live_wp_plugin.log'
					write_file("#{file_name}","#{uri_path}")
					puts "- ............... #{lines[i].chomp} [#{response_code}] ".green
				else
					puts "- ............... #{lines[i].chomp} [#{response_code}] ".yellow
				end
			end
		end # End Methode scanning

		def detect_wp_plugin(target)
			begin
				uri 		= URI.parse(target)
				http 		= Net::HTTP.new(uri.host, uri.port)
				if uri.scheme == "https"
					http.use_ssl = true
				end
				request 	= Net::HTTP::Get.new(uri.request_uri)
				response 	= http.request(request)
				return response.code
			rescue
				return exit
			end
		end # End Methode detect_plugin

		def list_updater()

			print "- Update from plugin? beta, popular, featured : "
			from_page = gets.chomp

			print "- Update to end page? : "
			end_page = gets.to_i

			if Integer(end_page) > 0
				for i in 1..end_page
					scrap_page_wp_vendor("https://wordpress.org/plugins/browse/#{from_page}/page/#{i}/")
				end
			else
				puts "Please select option with number 1 to ..."
			end

		end # End Methode list_updater

		def scrap_page_wp_vendor(url)
			source 	= open(url).read
			getPlug = source.scan(/<h2 class="entry-title"><a href\s*=\s*"https:[^"]*[^"]*wordpress.org[^"]*plugins[^"]([^"]*)/).flatten { |x| return true }

			for i in 0..getPlug.length - 1
				rnp = getPlug[i].gsub("/","")
				if word_exists_in_file("#{rnp}") == false
					puts "- ............... #{rnp}".green + " [added]".yellow
					write_file(get_list(),"#{rnp}")
				else
					puts "- ............... #{rnp}".red + " [exist plugin]".yellow
				end
			end

		end # End Methode scrap_page_wp_vendor

		def get_list
			return 'wordlists/wp_plugins.txt'
		end # End Methode get_list

		def write_file(file_name,val)
			open(file_name, 'a') { |f|
				f << "#{val}\n"
			}
		end # End Methode write_file

		def word_exists_in_file(param)
		   f = File.open(get_list()) #opens the file for reading
		   f.each do |line|
		      if line.match /#{param}/
		         return true
		      end
		   end
		   false
		end # End Methode word_exists_in_file

	end # End Class

end # End Module