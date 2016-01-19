require 'uri'
require 'net/http'
require "#{Rails.root}/app/controllers/mechanize/crawler"
require 'net/ping'

class HardWorker
   include Sidekiq::Worker
   # main method that contains the program logic
   def perform(company_id)

      # Fetching company from databse
      aCompany = Company.find(Moped::BSON::ObjectId(company_id))

      # if company actually exists, and id is valid
      if (aCompany != nil)

         # Telling the ping class that a refused
         # connection is a successful ping
         Net::Ping::TCP.econnrefused = true

         # net ping object
         p1 = Net::Ping::TCP.new("google.com", 22, 5)

         # Checkin that internet connection is up
         if p1.ping? == true

            # Checking if url is already a social media url
            if aCompany.link.include?("facebook") || aCompany.link.include?("pinterest") || aCompany.link.include?("twitter") || aCompany.link.include?("google")
               # Marking the company for the crawler
               aCompany.name = '2bupdated'
               aCompany.save

               # Passing the company to the crawled to populate the missing data
               newJob = Crawler.new(company_id)
            else

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

         else
         # Rescheduling for 15 minutes because internet is down
            HardWorker.perform_in(15.minutes, company_id)
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

=begin
Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
=end

         rescue Errno::ENOENT, Timeout::Error, SocketError, getaddrinfo
         false #false if can't find the server

         end

      else
      # not a proper URL
      false
      end

   end

end