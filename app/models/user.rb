class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email, :password
  validates_uniqueness_of :email
  has_secure_password
  
  #authenticate user
  def self.authenticate(email, password)
    @user = find_by_email(email)

    unless @user.nil?
     
      if @user.authenticate(password)
        return @user
      end
    end
    
    return nil
  end
end
