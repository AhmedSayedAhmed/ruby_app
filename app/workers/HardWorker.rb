require "#{Rails.root}/app/controllers/mechanize/crawler"

class HardWorker
  include Sidekiq::Worker
  
  def perform
    # main method that contains the program logic
    
    newJob = Crawler.new('websites.txt')
  end
end