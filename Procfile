web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
photo_import_queue: env TERM_CHILD=1 QUEUE=photo_import_queue bundle exec rake resque:work
