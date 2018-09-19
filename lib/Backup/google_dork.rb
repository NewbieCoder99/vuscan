module Google

	$url 		= 'http://google.co.id/search?q='
	$wl 		= 'wordlists/dork.txt'
	$p_tmp 		= 'logs/google_dork/google_scanpage_url_temp.json'
	$countPage	= 'logs/google_dork/google_scanpage_count_temp.txt'
	$html_page	= 'logs/google_dork/google_scanpage_temp.html'
	$getHasil	= /resultStats\"\>([0-9a-zA-Z\s\.]+)/
	$getLink	= /h3 class="r"><a\shref\=\"([a-zA-Z0-9\:\/\.\&\+\=\-\_\?\;\']+)"/
	$getPage 	= /href\=\"([\/a-zA-Z0-9\?\=\&\;\:\+\&\-\_\.]+)\"/
	$sock_file	= "logs/socks_list.txt"
	$ua_list	= "wordlists/ua-list.txt"

	class Dork

		def initialize
			print "- Use proxy? (Y/y) Or (N/n) : "
			use_proxy = gets.chomp

			if use_proxy == "Y" || use_proxy == "y" 
				print "- Do you want to update proxy list? (y or Y) if you want to update : "
				prxy 	= "--proxies"
				update_proxy = gets.chomp
			else
				prxy 	= "N"
			end

			if update_proxy == "Y" || update_proxy == "y"
				Get::Proxy.new()
			end

			if system("gedit " + $wl) == true
				wl 			= File.readlines($wl)
				wl_count 	= 0..wl.size.to_i - 1
				wl_count.each_with_index do |x|
					_main_("search?q=" + URI::encode(wl[x]) + "&start=0",prxy)
					ua()
				end
			end
		end

		def _main_(dork,use_proxy)

			proxies 	= get_proxy()
			proxy_addr	= proxies[0].gsub("\n","")
			proxy_port	= proxies[1].gsub("\n","")

			if use_proxy == "--proxies"
				puts "- Connecting with proxy #{proxy_addr}:#{proxy_port} ..."
			else
				puts "- Connecting without proxy ..."
			end

			sys_proc = system("php helpers/google_dork/curl.php #{proxy_addr} #{proxy_port} #{use_proxy} #{dork}")
			sleep(3)
			if sys_proc == true
				fjson 	= JSON.parse(open($p_tmp).read)
				if fjson['code'] == 200
					parsing()
				elsif fjson['code'] == 503
					puts "- Captcha detected.!".yellow
				else
					puts  "- Request timed out, Try again.".yellow
					sleep(1)
					_main_(dork,use_proxy)
				end
			end
		end

		def parsing()
			ftemp 		= open($html_page).read
			getHasil 	= scan_source(ftemp,$getHasil)
			puts "- Pencarian #{getHasil[0]}"

			getLink = scan_source(ftemp,$getLink)
			cl 	= 0..getLink.length
			if getLink.length >= 1
				cl.each_with_index do |i|
					puts "- 	#{getLink[i]} ".yellow
				end
			end
		end

		def ua
			ua_list  =  File.readlines($ua_list)
			count 	 = 	ua_list.size.to_i - 1
			ua 		 =  ua_list[rand(count)].gsub("\n","")
			LOG.new.delete("logs/google_dork/ua_temp.txt")
			LOG.new.create("logs/google_dork/ua_temp.txt", "#{ua}")
		end

		def get_proxy
			p_list 	= File.readlines($sock_file)
			count 	= p_list.size.to_i - 1
			proxies	= p_list[rand(count)].split(":")
			return [proxies[0],proxies[1]]
		end

		def scan_source(str,regex)
			results = str.scan(regex).flatten { |w|  return true }
			return results
		end

	end # End Class

end # End Module