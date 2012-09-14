require './lib/resque_heroku_scaled_job'

class PhotoImportWorker
  extend ResqueHerokuScaledJob
  @queue = :photo_import_queue

  def self.perform(program_id)
    program = Program.find(program_id)
    program.get_photos_by_tags

    if Rails.env.production?
      @heroku.post_ps_scale(ENV['HEROKU_APP_NAME'], 'photo_import_queue', 0)
    end
  end
end