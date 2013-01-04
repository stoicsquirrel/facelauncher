require './lib/resque_heroku_scaled_job'

class CacheClearingWorker
  extend ResqueHerokuScaledJob
  @queue = :cache_clearing_queue

  def self.perform(program_app_id, retry_count = 2)
    program_app = ProgramApp.find(program_app_id)
    begin
      Faraday.new do |conn|
        conn.request :url_encoded
        conn.adapter :net_http
        conn.params = {
          program_id: program_app.program_id,
          key: program_app.program.program_access_key
        }

        response = conn.post(program_app.clear_cache_url)
      end
    rescue Faraday::Error::ConnectionFailed
      if retry_count > 0
        Resque.enqueue(CacheClearingWorker, self.id, retry_count - 1)
      end
    end
  end
end