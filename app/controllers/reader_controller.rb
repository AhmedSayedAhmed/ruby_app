class ReaderController < ApplicationController
  def index
    # main method that contains the program logic
    require_relative 'mechanize/crawler'
    newJob = Crawler.new('websites.txt')
  end
end
