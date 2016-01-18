class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    
    User.reset_column_information
    User.all.each do |user|
      user.update_attributes(:username => user.email.split('@')[0])
      puts "$$$$$$$$$$$$$$$$$$$$$ #{user.username}"
    end
  end
end
