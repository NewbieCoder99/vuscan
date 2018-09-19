class LOG

	def create(filepath,text)
		if check_file(filepath) == true
			tm = word_exists_in_file(filepath,text)
			if tm == false
				open(filepath, 'a') { |f|
					f << "#{text}\n"
				}
			end
		else
			open(filepath, 'a') { |f|
				f << "#{text}\n"
			}
		end
	end

	def delete(filepath)
		if check_file(filepath) == true
			File.delete(filepath)
		end
	end

	def check_file(filepath)
		checkfile = File.exist?(filepath)
		if checkfile == true
			return true
		else
			return false
		end
	end

	def create_folder(folder_name)
		FileUtils.mkdir_p "#{folder_name}"
	end

	def delete_folder(folder_name)
		FileUtils.rm_rf("#{folder_name}")
	end

	def word_exists_in_file(filepath,text)
	   f = open(filepath).read
	   fscan = f.scan(text).flatten { |x| return true }
	   if fscan.length >= 1
	   	return true
	   else
	   	return false
	   end
	end # End Methode word_exists_in_file

end