require 'httparty'

module Network
  class MyClient
    include HTTParty
    default_timeout 7

    def initialize(base_uri)
      self.class.base_uri(base_uri)
    end

    def get_with_retry(path, options = {}, max_retries = 7)
      retries = 0
      begin
        puts "Retrying #{retries} of #{max_retries}" if retries.positive?
        response = self.class.get(path, options)
        puts "Retry success #{retries} times" if retries.positive?
        response
      rescue Net::ReadTimeout, Net::OpenTimeout => e
        puts "Error: #{e}"
        if retries < max_retries
          retries += 1
          sleep(7)
          retry
        else
          puts 'Max retries reached'
          raise e
        end
      end
    end
  end
end
