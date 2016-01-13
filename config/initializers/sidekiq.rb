Sidekiq.configure_server do |config|
  config.server_middleware do |chain|

    # Remove ActiveRecord hooks
    #chain.remove Sidekiq::Middleware::Server::ActiveRecord

    # Also needed for Mongoid
    # See: http://mongoid.org/en/mongoid/docs/tips.html#sidekiq    
    #chain.add Kiqstand::Middleware
  end
end