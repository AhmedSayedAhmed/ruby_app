require 'mechanize'
require 'json'

class Crawler
   # Method that reads the file line by line
   def initialize (aCompany)

      # Accessing the company from the database
      @theCompany = aCompany

      # Setting up the user agent
      @agent = Mechanize.new

      # Setting up the request headers
      headers = {
         'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
         'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
         'Accept-Charset' =>'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
         'Accept-Encoding'=> 'none',
         'Accept-Language'=> 'en-US,en;q=0.8',
         'Connection'=> 'keep-alive'
      }

      @agent.request_headers = headers
      @agent.idle_timeout = 0.9

      if (@theCompany.name != "2bupdated")
         # Sending the URI to be crawled for data
         page = @agent.get(@theCompany.link)

         # Getting company name
         if (page.title != nil)
            name  = page.title

            # Get proper encoding
            name = sanitize_utf8(name)

         # Saving data
         @theCompany.name = name
         end

         # Getting description from meta-data
         if (page.at('meta[property="og:description"]') != nil)
            description = page.at('meta[property="og:description"]')[:content]
            # Get proper encoding
            description = sanitize_utf8(description)
         # Saving data
         @theCompany.description = description
         else if (page.at('meta[property="description"]') != nil)
               description = page.at('meta[property="description"]')[:content]
               # Get proper encoding
               description = sanitize_utf8(description)
            # Saving data
            @theCompany.description = description
            end
         end

         emails = Array.new

         page.body.to_s.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).uniq.each do |mail|
            emails << mail.downcase
         end
         emails = {emails: emails.uniq}
         # Create a json object to store the email addresses
         @theCompany.emails = JSON.parse(emails.to_json)

         # Selecting all the links that has social links in it
         fblinks = page.links_with(:href => %r{facebook.com})
         gplinks = page.links_with(:href => %r{plus.google})
         plinks = page.links_with(:href => %r{pinterest.com})
         twlinks = page.links_with(:href => %r{twitter.com})

         # saving facebook hrefs in one array
         facebook = Array.new
         fblinks.each do |fb|
            facebook << fb.href.downcase
         end

         # saving google plus hrefs in one array
         gplus = Array.new
         gplinks.each do |gp|
            gplus << gp.href.downcase
         end

         # saving pinterest hrefs in one array
         pinterest = Array.new
         plinks.each do |p|
            pinterest << p.href.downcase
         end

         # saving twitter hrefs in one array
         twitter = Array.new
         twlinks.each do |tw|
            twitter << tw.href.downcase
         end

         # Create a json object to store the social media links
         social_links = {fb: facebook.uniq, gp: gplus.uniq, pt: pinterest.uniq, tw: twitter.uniq}
         @theCompany.social = JSON.parse(social_links.to_json)

         socialize(social_links)
      # Save the object in the database
      @theCompany.save
      else
      # social link
      end
   end
end

# Function that makes sure of proper encoding

def sanitize_utf8(string)
   return nil if string.nil?
   return string if string.valid_encoding?
   string.chars.select { |c| c.valid_encoding? }.join
end

def socialize(links)
   @data = Array.new
   
   # If facebook links are not empty, crawl them
   if(!links[:fb].empty?)
      # Crawl facebook
      #@data << Socializer.fb(links[:fb])
   end

   # If facebook links are not empty, crawl them
   if(!links[:gp].empty?)
      # Crawl google plus
      #@data << Socializer.gplus(links[:gp])
   end

   # If pinterest links are not empty, crawl them
   if(!links[:pt].empty?)
      # Crawl pinterest
      #@data << Socializer.pint(links[:pt])
   end

   # If twitter links are not empty, crawl them
   if(!links[:tw].empty?)
      # Crawl twitter
      @data << Socializer.tw(links[:tw])
      #Socializer.tw(links[:tw])
   end

   if @data != nil
      @data = {data: @data}
      @theCompany.data = JSON.parse(@data.to_json)
   end

end
