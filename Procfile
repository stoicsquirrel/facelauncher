web: bundle exec rails server thin -p $PORT
photo_import_queue: env TERM_CHILD=1 QUEUE=photo_import_queue bundle exec rake resque:work
