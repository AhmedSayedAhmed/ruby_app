require 'mechanize'

class Crawler
	# Method that reads the file line by line
	def initialize (theCompany)

		# Setting up the user agent
		agent = Mechanize.new

		# Sending the URI to be crawled for data
		page = agent.get(theCompany.link)

		theCompany.name = page.title

		# Selecting all the links that has facebook in it
		fblinks = page.links_with(:href => %r{facebook})
		if fblinks.empty?
			theCompany.fblink = 'N/A'
			puts '------------------------------------'
			puts 'no facebook links'
			puts '------------------------------------'
		else
			fblinks.each do |link|
				puts '------------------------------------'
				puts link.href
				        theCompany.fblink = link.href
				puts '------------------------------------'

			end
		end
		theCompany.save
	end
end
