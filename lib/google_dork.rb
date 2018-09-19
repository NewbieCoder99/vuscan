module Google

	$url 		= 'https://www.google.co.id/search?q='
	$wl 		= 'wordlists/dork.txt'
	$p_logs		= 'logs/dorks.txt'
	$getHasil	= /resultStats\"\>([0-9a-zA-Z\s\.]+)/
	$getLink	= /h3 class="r"><a href="\/url\?q\=([A-Za-z0-9\_\+\.\-\?\=\/\:]+)/
	$nextPage 	= /text\-align\:left\"\>\<a\sclass\=\"fl\"\shref\=\"([\/a-zA-Z0-9\?\=\&\;\:\+\&\-\_\.]+)\"/
	$p1			= '&start='

	class Dork

		def initialize
			if system("gedit " + $wl) == true
				wl 			= File.readlines($wl)
				wl_count 	= 0..wl.size.to_i - 1
				wl_count.each_with_index do |x|
					_main_(wl[x],0)
				end
			end
		end

		def _main_(dork,startpage)
			begin
				google 		= open("#{$url}#{dork}#{$p1}#{startpage}").read
				getHasil 	= scan_source(google,$getHasil)
				puts "- #{getHasil[0]}"

				getLink = scan_source(google,$getLink)
				cl 	= 0..getLink.length - 1
				cl.each_with_index do |i|
					puts "- 	#{getLink[i]} ".yellow
					LOG.new.create($p_logs,getLink[i])
				end

				if getHasil.length == 1
					startpage = startpage + 10
					sleep(10)
					_main_(dork,startpage)
				else
					exit
				end

			rescue Exception => e
				exit
			end
		end

		def scan_source(str,regex)
			results = str.scan(regex).flatten { |w|  return true }
			return results
		end

	end # End Class

end # End Module