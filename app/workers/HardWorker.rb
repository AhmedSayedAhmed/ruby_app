require 'uri'
require 'net/http'
require "#{Rails.root}/app/controllers/mechanize/crawler"
require 'net/ping'

class HardWorker
	include Sidekiq::Worker

	# No retries
	sidekiq_options :retry => false
	# main method that contains the program logic
	def perform(line)

		# Telling the ping class that a refused
		# connection is a successful ping
		Net::Ping::TCP.econnrefused = true

		# net ping object
		p1 = Net::Ping::TCP.new("google.com", 22, 5)

		# Checkin that internet connection is up
		if p1.ping? == true

			# Checking if url is already a social media url
			if line.include?("facebook") || line.include?("pinterest") || line.include?("twitter") || line.include?("google")

				# Marking the company for the crawler
				name = '2bupdated'

				# Saving Company in the database
				@company = Company.new(:name => name, :link => line)
				@company.save

				# Passing the company to the crawled to populate the missing data
				newJob = Crawler.new(@company)
			else
			# if link is missing the http:// request

				if line.downcase.start_with?("www")
					newlink = "http://" + line
				elsif line.downcase.start_with?("http")
				newlink = line
				else
					newlink = "http://www." + line
				end

				# Checking the url and the server first
				if check_link?(newlink) == true
					# Passing the company to the crawler to populate the missing data
					@company = Company.new(:name => line, :link => newlink)
					@company.save
					newJob = Crawler.new(@company)
				else
				# Server not responding
					name = 'Server Down'
					@company = Company.new(:name => name, :link => newlink)
				@company.save

				end
			end

		else
		# Rescheduling for 15 minutes because internet is down
			HardWorker.perform_in(15.minutes, line)
		end

	end

	def check_link?(url_string)
		# this function makes sure that the url is valid, and that the server
		# is up
		if url_string =~ URI::regexp
			# a proper URL
			begin
				url = URI.parse(url_string)

				unless url.path.end_with? "/"
					url.path = url.path + '/'
				end

				req = Net::HTTP.new(url.host, url.port)
				res = req.request_head(url.path || '/')
				req.use_ssl = (url.scheme == 'https')

				if res.kind_of?(Net::HTTPRedirection)
					check_link?(res['location'])# Go after any redirect and make sure you
				# can access the redirected URL
				else
				true
				end

			rescue Errno::ENOENT
				false #false if can't find the server

			rescue Errno::ECONNRESET
				false
			rescue URI::InvalidURIError
				false
			rescue Timeout::Error
			# timeout connecting to server
				false

			rescue SocketError
			# unknown server
				false

			rescue getaddrinfo
				false

			rescue Exception => e
			false
			end

		else
		# not a proper URL
		false
		end

	end

end