require 'mechanize'

class Crawler
	# Method that reads the file line by line
	def initialize (id)

		theCompany = Company.find(Moped::BSON::ObjectId(id))
		# Setting up the user agent
		agent = Mechanize.new

		# Sending the URI to be crawled for data
		page = agent.get(theCompany.link)

		# Getting company name
		name  = page.title
		name = sanitize_utf8(name)
		theCompany.name = name

		# Selecting all the links that has facebook in it
		fblinks = page.links_with(:href => %r{facebook})

		# No facebook links were found
		if fblinks.empty?
			theCompany.fblink = 'N/A'
		else
			fblinks.each do |link|
			# Need to check if previous links are the same or not
			# if not, then create a new company with the new fblink
				theCompany.fblink = link.href
			end
		end

		theCompany.save
	end

	def sanitize_utf8(string)
		return nil if string.nil?
		return string if string.valid_encoding?
		string.chars.select { |c| c.valid_encoding? }.join
	end

end
