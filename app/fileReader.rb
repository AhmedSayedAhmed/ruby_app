class FileReader
  
# Function that loops through the file to push all links in the database
  def readFile(path)

    # reading the text file
    File.open(path, "r") do |f|
    #looping through the file
      f.each_line do |line|
      
        line.gsub('\n','')
        # Saving URL in the database
        aCompany = Company.create :link => line        
      end
    end
    
  end
    
end
