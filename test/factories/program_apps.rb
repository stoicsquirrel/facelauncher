require 'factory_girl'

FactoryGirl.define do
  factory :program_app do
    program
    name "Test App"
  end
end