require 'uri'
require 'net/http'
require "#{Rails.root}/app/controllers/mechanize/crawler"

class HardWorker
	include Sidekiq::Worker
	# main method that contains the program logic
	def perform(company_id)

		aCompany = Company.find(Moped::BSON::ObjectId(company_id))

		if (aCompany != nil)
			# Checking the url and the server first
			if check_link?(aCompany.link)

				# Passing the company to the crawled to populate the missing data
				newJob = Crawler.new(company_id)
			else
				aCompany.name = 'Server Down'
				aCompany.fblink = 'N/A'
				aCompany.save
			end
		end
	end

	def check_link?(url_string)
		# this function makes sure that the url is valid, and that the server
		# is up
		if url_string =~ URI::regexp
			# a proper URL

			url = URI.parse(url_string)

			unless url.path.end_with? "/"
				url.path = url.path + '/'
			end

			begin

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

			rescue Timeout::Error
			# timeout connecting to server
				false

			rescue SocketError
			# unknown server
				false

			rescue getaddrinfo
			#
			false

			end

		else
		# not a proper URL
		false
		end

	end
end

