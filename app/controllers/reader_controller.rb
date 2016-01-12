require "#{Rails.root}/app/workers/HardWorker.rb"

class ReaderController < ApplicationController
  def index    
    @theWorker = HardWorker.new
    @theWorker.perform
  end
end