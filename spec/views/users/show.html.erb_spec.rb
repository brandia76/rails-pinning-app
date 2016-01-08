require 'spec_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @pins = @user.pins
  end

  it "renders attributes in <p>" do
    render
    @pins.each do |pin|
      expect(rendered).to match(pin.title)
    end
  end
end
