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

				id = Moped::BSON::ObjectId.new

				unless (Moped::BSON::ObjectId(id.to_s)) == id then
					# getting the next unique id
					id = Moped::BSON::ObjectId.new
				end
				
				# Making sure that encoding is correct
				line = sanitize_utf8(line)

				# Saving Company in the database
				aCompany = Company.create :_id => id, :link => line

				# Scheduling a job for the Hardworker class
				# to Update the database with crawled values
				HardWorker.perform_async(id.to_s)
			end
		end
	end

end