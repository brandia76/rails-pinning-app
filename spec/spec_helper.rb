ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# no require of rails or active record, suppose this loads them
require "bundler/setup"
::Bundler.require(:default, :test)

ActiveRecord::Migration.maintain_test_schema!

require "shoulda-matchers"

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    Rails.application.load_seed # loading seeds
  end
  
  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/test_files/"])
  end
end

def login(user)
  logged_in_user = User.authenticate(user.email, user.password)
  if logged_in_user.present?
    session[:user_id] = logged_in_user.id
  end
end