require './lib/resque_heroku_scaled_job'

class PhotoImportWorker
  extend ResqueHerokuScaledJob
  @queue = :photo_import_queue

  def self.perform(program_id)
    program = Program.find(program_id)
    program.import_photos_by_tags
  end
end