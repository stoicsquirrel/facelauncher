require 'heroku-api'

module ResqueHerokuScaledJob
  class HerokuScaler
    attr_reader :queue

    def initialize(queue)
      @queue = queue
      # If ENV['HEROKU_API_KEY'] and ENV['HEROKU_APP_NAME'] are set, then instantiate
      # a HerokuScaler. Otherwise, raise an exception.
      # HerokuScaler.heroku? can be used outside of the class to test before attempting
      # to instantiate this class.
      if HerokuScaler.heroku?
        @heroku = Heroku::API.new
      else
        raise ArgumentError, "ENV['HEROKU_API_KEY'] is not set.", caller
      end
    end

    def workers
      @heroku.get_ps(ENV['HEROKU_APP_NAME']).count { |a| a["process"] =~ /^#{@queue}/ }
    end

    def workers=(qty)
      @heroku.post_ps_scale(ENV['HEROKU_APP_NAME'], @queue, qty)
    end

    def self.heroku?
      ENV.key?('HEROKU_API_KEY') and ENV.key?('HEROKU_APP_NAME')
    end
  end

  # This method gets called by Resque first.
  def after_enqueue_scale_workers_up(*args)
    if HerokuScaler.heroku?
      scaler = HerokuScaler.new(@queue)
      scaler.workers = 1 if job_count > 0
    end
  end

  def after_perform_scale_workers_down(*args)
    scale_down
  end

  def on_failure_scale_workers_down(*args)
    scale_down
  end

  private
  def job_count
    Resque.info[:pending].to_i
  end

  def scale_down
    if HerokuScaler.heroku?
      scaler = HerokuScaler.new(@queue)
      scaler.workers = 0 if job_count == 0
    end
  end
end
