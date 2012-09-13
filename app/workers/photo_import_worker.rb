class PhotoImportWorker
  @queue = :photo_importer_queue

  def self.perform(program_id)
    if Rails.env.production?
      require 'heroku-api'
      @heroku = Heroku::API.new if @heroku.nil?
      @heroku.post_ps_scale(ENV['HEROKU_APP_NAME'], 'photo_importer_queue', 1)
    end

    program = Program.find(program_id)
    program.get_photos_by_tags

    if Rails.env.production?
      @heroku.post_ps_scale(ENV['HEROKU_APP_NAME'], 'photo_importer_queue', 0)
    end
  end
end