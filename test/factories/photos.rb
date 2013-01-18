require 'factory_girl'

FactoryGirl.define do
  factory :photo do
    program
    #photo_album
    file { fixture_file_upload(Rails.root.join('test', 'images', 'hgear.png'), 'image/png') }
  end
end