ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'

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
  
  config.use_transactional_fixtures = false
  config.before(:each) do 
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
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

def logout(user)
  if session[:user_id] == user.id
    session.delete(:user_id)
  end
end

module ApplicationHelper
  def current_user
    @user ||= User.where("id=?",session[:user_id]).first
  end
  
  def logged_in?
    !current_user.nil? && !current_user.id.nil?
  end
end
