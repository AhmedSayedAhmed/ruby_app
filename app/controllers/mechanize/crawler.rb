require 'rubygems'
require 'mechanize'
require 'uri'
require 'net/http'


class Crawler

  # Method that reads the file line by line
  def initialize (filename)

    # Setting up the user agent
  agent = Mechanize.new
      
  path = Rails.root+'uploads'+ filename
    # reading the text file
        File.open(path, "r") do |f|

      f.each_line do |line|

        # Checking the link before crawling, if server down, skip
        if check_link?(line)


          ###############
          # for testing, will be removed later
          # puts line
          # puts "============================"
  
          ###############

          # Sending the URI to be crawled for data
          page = agent.get(line)

          # Selecting all the links that has facebook in it
          page.links_with(href: /facebook/).each do |link|
            ##################
            puts link.href
            #################
          end
        end
      end
    end

  end


  def check_link?(url_string)

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
          check_link?(res['location']) # Go after any redirect and make sure you can access the redirected URL
        else
          true
        end

      rescue Errno::ENOENT
        false #false if can't find the server

      rescue Timeout::Error
        # timeout connecting to server
        puts "Timeout"
        false

      rescue SocketError
        # unknown server
        puts "failed: SocketError"
        false


      end

    else
      # not a proper URL
      false
    end

  end

end
