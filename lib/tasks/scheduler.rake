namespace :facelauncher do
  desc "Import photos from social media (queued on Resque)"
  task :import_photos => :environment do
    active_programs = Program.active_scope
    if active_programs.count > 0
      puts "#{active_programs.count} active program#{(active_programs.count == 1) ? '' : 's'} found. Photos will begin importing soon..."
      active_programs.each do |program|
        Resque.enqueue(PhotoImportWorker, program.id)
      end
    else
      puts "No active programs found."
    end
  end
end