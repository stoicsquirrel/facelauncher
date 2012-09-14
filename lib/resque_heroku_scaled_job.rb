require 'heroku-api'

module ResqueHerokuScaledJob
  class HerokuScaler
    attr_reader :queue

    def initialize(queue)
      @queue = queue
      if ENV.key? 'HEROKU_API_KEY'
        @heroku = Heroku::API.new
      else
        raise ArgumentError, "ENV['HEROKU_API_KEY'] is not set.", caller
      end
    end

    def workers
      @heroku.get_ps(ENV['HEROKU_APP']).count { |a| a["process"] =~ /^#{@queue}/ }
    end

    def workers=(qty)
      @heroku.post_ps_scale(ENV['HEROKU_APP'], @queue, qty)
    end
  end

  # This method gets called by Resque first.
  def after_enqueue_scale_workers_up(*args)
    # If ENV['HEROKU_API_KEY'] is set, then instantiate a HerokuScaler. If not, then
    # do not use the scaler.
    if ENV.key? 'HEROKU_API_KEY'
      @@scaler = HerokuScaler.new(@queue)
      @@scaler.workers = 1 if job_count > 0
    end
  end

  def after_perform_scale_workers_down(*args)
    @@scaler.workers = 0 if !@@scaler.nil? && job_count == 0
  end

  def job_count
    Resque.info[:pending].to_i
  end
end

# module HerokuResqueAutoScale
#   module Scaler
#     class << self
#       @@heroku = Heroku::API.new
#
#       def workers
#         @@heroku.get_ps(ENV['HEROKU_APP']).count { |a| a["process"] =~ /^resque/ }
#       end
#
#       def workers=(qty)
#         @@heroku.post_ps_scale(ENV['HEROKU_APP'], 'resque', qty)
#       end
#
#       def job_count
#         Resque.info[:pending].to_i
#       end
#     end
#   end
#
#   def after_perform_scale_down(*args)
#     # Nothing fancy, just shut everything down if we have no jobs
#     Scaler.workers = 0 if Scaler.job_count.zero?
#   end
#
#   def after_enqueue_scale_up(*args)
#     [
#       {
#         :workers => 1, # This many workers
#         :job_count => 1 # For this many jobs or more, until the next level
#       },
#       {
#         :workers => 2,
#         :job_count => 15
#       },
#       {
#         :workers => 3,
#         :job_count => 25
#       },
#       {
#         :workers => 4,
#         :job_count => 40
#       },
#       {
#         :workers => 5,
#         :job_count => 60
#       }
#     ].reverse_each do |scale_info|
#       # Run backwards so it gets set to the highest value first
#       # Otherwise if there were 70 jobs, it would get set to 1, then 2, then 3, etc
#
#       # If we have a job count greater than or equal to the job limit for this scale info
#       if Scaler.job_count >= scale_info[:job_count]
#         # Set the number of workers unless they are already set to a level we want. Don't scale down here!
#         if Scaler.workers <= scale_info[:workers]
#           Scaler.workers = scale_info[:workers]
#         end
#         break # We've set or ensured that the worker count is high enough
#       end
#     end
#   end
# end