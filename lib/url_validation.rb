class URLVALID
	def check_url(param)
		if /^(http|https):\/\/|(www.)|()[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/.match(param)
			return true
		else
			return false
		end
	end
end