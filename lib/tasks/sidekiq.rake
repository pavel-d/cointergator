namespace :sidekiq do
  desc "Start sidekiq web monitoring"
  task monitor: :environment do
    require 'sidekiq/web'
    app = Sidekiq::Web
    app.set :environment, :production
    app.set :bind, '0.0.0.0'
    app.set :port, 9494

    puts "Running Sidekiq monitor on http://localhost:9494/"
    app.run!
  end

  desc "Clear all sidekiq queues"
  task clear: :environment do
    require 'sidekiq/api'

    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
    Sidekiq::ScheduledSet.new.clear
  end
end
