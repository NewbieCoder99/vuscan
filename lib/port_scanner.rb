module Port

	class Scanner

		def initialize()
			if system("gedit " + 'wordlists/domain_target.txt') == true
				print "- To end port check : "
				endport = gets.to_i
				wl 			= File.readlines('wordlists/domain_target.txt')
				wl_count 	= 0..wl.size.to_i - 1
				wl_count.each_with_index do |x|
					url = wl[x].gsub("\n","")
					puts "==================================================================".white
					puts "- #{url}" + " processing...".yellow
					begin
						_main_(url,endport)
					rescue Exception => e
						puts "- " + e.message.yellow
					end
				end
			end
		end

		def _main_(urip,endport)

			if IPVALID.new.check_ip(urip) == true # Cek Jika memasukan IP Address
				ip = urip
			else
				ip = IPSocket::getaddress(urip.gsub(/^https?\:\/\/(www.)?/,''))
			end

			filepath = 'logs/portscan_'+ ip +'.log'

			if endport > 19

				# Hapus file log jika sudah ada
				LOG.new.delete(filepath)

				ports = 19..endport
				ports.each do |scan|
					begin
						Timeout::timeout(1) { TCPSocket.new(ip, scan) }
					rescue
						puts "- ............... Port #{scan} is closed on #{ip}".yellow
					else
						# Buat log
						LOG.new.create(filepath,"#{ip}:#{scan}")
						puts "- ............... Port #{scan} is open on #{ip}".green
					end
				end
				puts "\n Done! File log has been created : #{filepath}\n\n"
			else
				puts "port must exceed than 19"
			end
		end

	end # End Class

end # End Module