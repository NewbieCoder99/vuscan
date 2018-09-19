#!/usr/bin/ruby

module Url

	$webhost = 'https://idwebhost.com/';

	class Scrapper

		def initialize()
			puts "- URL Scrapper running ..."
			puts "- Connect to webhost ..."
			begin
				_main_
			rescue Exception => e
				puts "- " + e.message.yellow
			end
		end

		def _main_

			data 		= data_arr()
			count_data 	= 0..data.length - 1

			count_data.each_with_index do |x|
				res = curl($webhost + "Hosting_Klien_Kami/sort/#{data[x]}")
				if res.code == '200'
					body = res.body

					match_page = body.match('Page 1 of')

					if match_page
						number = body.scan(/Page\s1\sof\s([0-9]+)/).flatten { |x| return true }
						get_page("#{data[x]}","#{number[0]}")
					else
						get_page("#{data[x]}",1)
					end

				else
					puts '- Error code ' + res.code
				end
			end

		end # End Of Method

		def get_page(alphabet,number)
			puts "- Page Total : #{number}"
			numbs = 1..number.to_i
			numbs.each_with_index do |x|
				url = $webhost + "Hosting_Klien_Kami/sort/#{alphabet}/#{x}"
				res = curl(url)
				puts "- " + url
				get_domain(res.body)
			end
		end

		def get_domain(res)
			# domain = res.scan(/\<p\>(http|https)\:\/\/([A-Za-z0-9\-\_.\/]+)/).flatten { |x| return true }
			domain = res.scan(/\<p\>([A-Za-z0-9\-\_.\/\/\:]+)/).flatten { |x| return true }
			for i in 0..domain.length
				if URLVALID.new.check_url(domain[i])
					begin
						res = curl(domain[i])
						if res.code == '200'
							LOG.new.create('logs/domain/all_domain.txt',domain[i])
							if /.info/.match(domain[i]) != nil
								flog = 'logs/domain/info.txt'
							elsif /.biz/.match(domain[i]) != nil
								flog = 'logs/domain/biz.txt'
							elsif /.website/.match(domain[i]) != nil
								flog = 'logs/domain/website.txt'
							elsif /.asia/.match(domain[i]) != nil
								flog = 'logs/domain/asia.txt'
							elsif /.space/.match(domain[i]) != nil
								flog = 'logs/domain/space.txt'
							elsif /.my.id/.match(domain[i]) != nil
								flog = 'logs/domain/my_id.txt'
							elsif /.web.id/.match(domain[i]) != nil
								flog = 'logs/domain/web_id.txt'
							elsif /.co.id/.match(domain[i]) != nil
								flog = 'logs/domain/co_id.txt'
							elsif /.sch.id/.match(domain[i]) != nil
								flog = 'logs/domain/sch_id.txt'
							elsif /.or.id/.match(domain[i]) != nil
								flog = 'logs/domain/or_id.txt'
							elsif '.ac.id'.match(domain[i]) != nil
								flog = 'logs/domain/ac_id.txt'
							elsif /.net.id/.match(domain[i]) != nil
								flog = 'logs/domain/net_id.txt'
							elsif /.tv/.match(domain[i]) != nil
								flog = 'logs/domain/tv.txt'
							elsif /.eu/.match(domain[i]) != nil
								flog = 'logs/domain/eu.txt'
							elsif /.name/.match(domain[i]) != nil
								flog = 'logs/domain/name.txt'
							elsif /.com.sg/.match(domain[i]) != nil
								flog = 'logs/domain/com_sg.txt'
							elsif /.ws/.match(domain[i]) != nil
								flog = 'logs/domain/ws.txt'
							elsif /.me/.match(domain[i]) != nil
								flog = 'logs/domain/me.txt'
							elsif /.mobi/.match(domain[i]) != nil
								flog = 'logs/domain/mobi.txt'
							elsif /.co.in/.match(domain[i]) != nil
								flog = 'logs/domain/co_in.txt'
							elsif /.bz/.match(domain[i]) != nil
								flog = 'logs/domain/bz.txt'
							elsif /.cd/.match(domain[i]) != nil
								flog = 'logs/domain/cd.txt'
							elsif /.net.in/.match(domain[i]) != nil
								flog = 'logs/domain/net_in.txt'
							elsif /.org.in/.match(domain[i]) != nil
								flog = 'logs/domain/org_in.txt'
							elsif /.gen.in/.match(domain[i]) != nil
								flog = 'logs/domain/gen_in.txt'
							elsif /.firm.in/.match(domain[i]) != nil
								flog = 'logs/domain/firm_in.txt'
							elsif /.jp/.match(domain[i]) != nil
								flog = 'logs/domain/jp.txt'
							elsif /.kr/.match(domain[i]) != nil
								flog = 'logs/domain/kr.txt'
							elsif /.co.kr/.match(domain[i]) != nil
								flog = 'logs/domain/co_kr.txt'
							elsif /.net/.match(domain[i]) != nil
								flog = 'logs/domain/net.txt'
							elsif /.id\//.match(domain[i]) != nil
								flog = 'logs/domain/id.txt'
							elsif /.org/.match(domain[i]) != nil
								flog = 'logs/domain/org.txt'
							elsif /.com/.match(domain[i]) != nil
								flog = 'logs/domain/com.txt'
							elsif /.co/.match(domain[i]) != nil
								flog = 'logs/domain/co.txt'
							elsif /.us/.match(domain[i]) != nil
								flog = 'logs/domain/us.txt'
							elsif /.xyz/.match(domain[i]) != nil
								flog = 'logs/domain/xyz.txt'
							else
								flog = 'logs/domain/unknown.txt'
							end
							puts "- Domain : " + "#{domain[i]}".yellow + " [ add ]"
							LOG.new.create(flog,domain[i])
						end
					rescue Exception => e
						puts "- " + e.message.yellow
					end
				end
			end

		end

		def curl(webhost)
			uri  = URI(webhost)
			http = Net::HTTP.new(uri.host, uri.port)
			http.open_timeout = 2
			# http.read_timeout = 2
			if uri.scheme 		== "https"
				http.use_ssl 	= true
			end
			return http.get(uri.request_uri)
		end

		def data_arr()
			return ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9']
		end

	end # End Class

end # End Module