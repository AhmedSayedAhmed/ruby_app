require 'rubygems'
require 'twitter'
require 'koala'

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
         end

      end
      data = {Twitter: data}
      return data

   end

   def self.fb(links)
      # Configuring koala
      oAuth = "CAACEdEose0cBABpKZAKSvIicW7vXtDPSZAHm3VHZA3feQLDomSqgO1Leun66ZAz7iMuGfCHZAZBBSgrNlz8tapXJxkhpAzZBkgvZCrEFkRljWNiPdP70hng1O6FLE8Aqt5VjmeVrq8bX8kbogHufbO8Kp6ZAj35drfy5RZBBYW2znppfx4OAQ3mYLnypHCLh5CoKAVcZBhn2lZCsRX4pEQDLffux"
      @graph = Koala::Facebook::API.new(oAuth)

      data = Array.new

      # looping through the given links
      links.each do |aLink|

      # if not a proper page link, ignore
         if !aLink.include?("share") && !aLink.include?("search")
            # Get the username from the link string
            username = aLink.split("facebook.com/")[-1].split("?")[0]

            if username.start_with?("pages/")
               username = username.split("pages/")[0]
            end

            if username.include?("/")
               username = username.split("/")[1]
            end

         # retrieve the user profile
         profile = @graph.get_object(username)

         data << profile
         end
      end
      data = {Facebook: data}
      return data

   end

   def self.gplus(links)

   end

   def self.pint(links)

   end
end