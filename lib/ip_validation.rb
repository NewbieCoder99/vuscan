class IPVALID
	def check_ip(param)
		if /\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b/.match(param)
			return true
		else
			return false
		end
	end
end