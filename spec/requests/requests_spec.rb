require "spec_helper"

RSpec.describe "Our Application Routes" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @pin = @user.pins.first
  end
  
  after(:each) do
    unless @user.destroyed?
      @user.pinnings.destroy_all
      @user.destroy
    end
  end
	describe "GET /pins/name-:slug" do
		it 'renders the pins/show template' do 
			id = @pin.id
			get "/pins/name-#{@pin.slug}"
			expect(response).to render_template("show")
		end
		it 'populates the @pin variable with the appropriate pin' do
      id = @pin.id
			get "/pins/name-#{@pin.slug}"
			expect(assigns[:pin]).to eq(@pin)
		end
	end
  
end