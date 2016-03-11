require 'rubygems'
require 'twitter'
require 'koala'
require 'google_plus'

module Socializer
	# function for crawling twitter
	def self.tw(links)
		# Setting up the API connection
		client = Twitter::REST::Client.new do |config|
			config.consumer_key        = "QeT8c2UUIT29DDUHl5DowvlWe"
			config.consumer_secret     = "qRcqJ0BUfIJyIAy66pGZCk6BHSPJpv91vGloGWE1gtXfoGRdZW"
			config.access_token        = "4827725555-sRrU51FU1bbVOYNQFJsjxeXR5Lus4XPpN6tEpi5"
			config.access_token_secret = "KEW24h3ExnHuqwHviLjTBb5ZbOxdt3JkXH5Ajx2kQYose"
		end

		data = Array.new

		# looping through the given links
		links.each do |aLink|

		# if not a proper page link, ignore
			if !aLink.include?("share") && !aLink.include?("search")
				# Get the username from the link string
				username = aLink.split("twitter.com/")[-1]

				begin
				# retrieve the user profile
					theUser = client.user(username)
					name = theUser.name
					location = theUser.location
					description = theUser.description
					image = theUser.profile_image_url.host + theUser.profile_image_url.path

					# create a json-like variable
					userData = {name: name, location: location, description: description, image_path: image}

					# append the data
					data << userData

				rescue Twitter::Error::NotFound
				end

			end

		end
		data = {Twitter: data}
		return data

	end

	def self.fb(links)

		# Configuring koala for facebook
		@oauth = Koala::Facebook::OAuth.new('1938175669741491', '5763e2f6bc9c4bfd4b88194c14ad0cd1')

		# Getting a new access token
		@access_token = @oauth.get_app_access_token
		@graph = Koala::Facebook::API.new(@access_token)

		# variable that will hold our daya from Facebook
		data = Array.new

		# looping through the given links
		links.each do |aLink|

		# if not a proper page link, ignore
			if !aLink.include?("share") && !aLink.include?("search")
				# Get the username from the link string
				username = aLink.split("facebook.com/")[-1].split("?")[0]

				if username.start_with?("pages/")
					username = username.split("pages/")[1]
				elsif username.start_with?("people/")
					username = username.split("people/")[1]
				end

				if username.include? "?"
					username = username.split("?")[0]
				end

				if username.include? "/"
					dummy = username.split("/")

					if dummy.size == 2
						if self.is_number?(dummy[1])
							username = dummy[0] + "-" + dummy[1]
						end
					end
				end

				begin
				# retrieve the user profile
					profile = @graph.get_object(username, :fields => "name, emails, phone, website, location, hours")
					data << profile
				rescue Koala::Facebook::ClientError

				end

			end
		end
		data = {Facebook: data}
		return data

	end

	def self.gplus(links)
		# Configuring google_plus
		GooglePlus.api_key = 'AIzaSyDWRsLu6ydKiYnhj-8qEL4pvZrCGEDByf0'

		data = Array.new

		# looping through the given links
		links.each do |aLink|
			if(!aLink.include?("share"))
				# dummy array
				dummy = aLink.split("/")

				dummy.each do |x|
					if (x.length == 21)
						# This is the user ID
						@userID = x
					end
				end

				# Get the google plus user
				person = GooglePlus::Person.get(@userID)

				# Get the Attributes
				begin
					username = person.attributes["display_name"]
					urls = person.attributes["urls"]
					description = person.attributes["about_me"]
					image = person.attributes["image"]

				rescue NoMethodError
				rescue GooglePlus::RequestError

				end

				# Sanitizing for false html tags
				username = ActionView::Base.full_sanitizer.sanitize(username)
				description = ActionView::Base.full_sanitizer.sanitize(description)

				userData = {name: username, website: urls, description: description, image_path: image}

			data << userData
			end
		end

		data = {GPlus: data}
		return data

	end

	# Helper method to check that if a string is a number
	# Source: http://stackoverflow.com/questions/5661466/test-if-string-is-a-number-in-ruby-on-rails

	def self.is_number?(string)
		true if Float(string) rescue false
	end

end