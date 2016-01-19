require "#{Rails.root}/app/workers/HardWorker.rb"

class FileReader
	# Function that loops through the file to push all links in the
	# database
	def readFile(path)

		# reading the text file
		File.open(path, "r") do |f|

		#looping through the file
			f.each_line do |line|
			# Removing the end of line character
			line.gsub('\n','')

				# Scheduling a job for the Hardworker class
				# to Update the database with crawled values
				HardWorker.perform_async(line)
			end
		end
	end

end