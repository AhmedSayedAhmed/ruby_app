require 'mechanize'

class Crawler
   # Method that reads the file line by line
   def initialize (id)

      # Accessing the company from the database
      theCompany = Company.find(Moped::BSON::ObjectId(id))

      # if company actually exists, and id is valid
      if (theCompany != nil)

         # Setting up the user agent
         agent = Mechanize.new

         if (theCompany.link != 'social')
            # Sending the URI to be crawled for data
            page = agent.get(theCompany.link)

            # Getting company name
            name  = page.title

            # Get proper encoding
            name = sanitize_utf8(name)

            # Getting description from meta-data
            description = page.at('meta[property="og:description"]')[:content]

            # Get proper encoding
            description = sanitize_utf8(description)

            # Saving data
            theCompany.name = name
            theCompany.description = description

            # Selecting all the links that has social links in it
            fblinks = page.links_with(:href => %r{facebook})
            gplinks = page.links_with(:href => %r{plus.google})
            plinks = page.links_with(:href => %r{pinterest})
            twlinks = page.links_with(:href => %r{twitter})

            # Create a json object to store the social media links
            social_links = {facebook: fblinks, gplus: gplinks, pinterest: plinks, twitter: twlinks}
            #theCompany.social = social_links.to_json
            #puts"========================================================"
            #puts social_links.to_json
            #puts"========================================================"
         # Save the object in the database
         theCompany.save
         else
         # social link
         end
      end
   end

   # Function that makes suer of proper encoding
   def sanitize_utf8(string)
      return nil if string.nil?
      return string if string.valid_encoding?
      string.chars.select { |c| c.valid_encoding? }.join
   end

end
