class PhotoImportWorker
  @queue = :photo_importer_queue
  def self.perform(program_id)
    program = Program.find(program_id)
    program.get_photos_by_tags
  end
end