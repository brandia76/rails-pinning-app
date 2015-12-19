require 'spec_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = FactoryGirl.build(:user)
  end
   
  after(:all) do
    if !@user.destroyed?
      @user.destroy
    end
  end
   
  it 'authenticates and returns a user when valid email and password passed in' do
    expect(@user).to be_valid
  end
  
  it { should validate_presence_of(:first_name) } 
  it { should validate_presence_of(:last_name) } 
  it { should validate_presence_of(:email) } 
  it { should validate_presence_of(:password) } 
 

end
