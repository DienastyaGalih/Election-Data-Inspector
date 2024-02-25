# frozen_string_literal: true

Sidekiq.configure_server do |config|
  Rails.logger = Sidekiq.logger
  config.redis = { host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], db: 0 }
  config.on(:startup) do
    file = File.read(Rails.root.join('config', 'schedule.yml'))
    yaml = ERB.new(file).result
    Sidekiq.schedule = YAML.load yaml
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = { host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], db: 0 }
end
