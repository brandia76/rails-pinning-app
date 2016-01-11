require 'spec_helper'
RSpec.describe PinsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @board = @user.boards.first
    login(@user)
  end
  
  after(:each) do
    unless @user.destroyed?
      @user.pinnings.destroy_all
      @user.boards.destroy_all
      Pin.where(user_id: @user.id).destroy_all
      @user.destroy
    end
  end
  
  describe "GET index" do
  
    it 'renders the index template' do
      get :index
      expect(response).to render_template("index")
    end
    
    it 'populates @pins with all pins' do
      get :index
      expect(assigns[:pins]).to eq(Pin.all)
    end
    
  end
  
  describe "GET new" do
    it 'responds with successfully' do
      get :new
      expect(response.success?).to be(true)
    end
    
    it 'renders the new view' do
      get :new      
      expect(response).to render_template(:new)
    end
    
    it 'assigns an instance variable to a new pin' do
      get :new
      expect(assigns(:pin)).to be_a_new(Pin)
    end
  end
  
  describe "POST create" do
    before(:each) do
      @pin_hash = { 
        title: "Rails Wizard", 
        url: "http://railswizard.org", 
        text: "A fun and helpful Rails Resource",
        category_id: 2
        }    
    end
    
    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      if !pin.nil?
        pin.destroy
      end
    end
    
    it 'responds with a redirect' do
      post :create, pin: @pin_hash
      expect(response.redirect?).to be(true)
    end
    
    it 'creates a pin' do
      post :create, pin: @pin_hash  
      expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
    end
    
    it 'redirects to the show view' do
      post :create, pin: @pin_hash
      expect(response).to have_http_status(:redirect)
    end
    
    it 'redisplays new form on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:url)
      post :create, pin: @pin_hash
      expect(response).to render_template("new")
    end
    
    it 'assigns the @errors instance variable on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash[:url] = nil
      post :create, pin: @pin_hash
      expect(response).to render_template("new")
    end    
    
  end

  describe "GET edit" do
    before(:each) do
      @pin_hash = { 
        title: "Rails Wizard", 
        url: "http://railswizard.org", 
        slug: "rails-wizard", 
        text: "A fun and helpful Rails Resource",
        category_id: 2
        } 
      @pin = Pin.create(@pin_hash)
    end
    
    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      if !pin.nil?
        pin.destroy
      end
    end
    
    it 'responds with successfully' do
      get :edit, id: @pin.id
      expect(response.success?).to be(true)
    end
    
     it 'renders the edit view' do
       get :edit, id: @pin.id     
       expect(response).to render_template(:edit)
     end
    
     it 'assigns an instance variable to a new pin' do
       get :edit, id: @pin.id
       expect(assigns(:pin) == @pin).to eq(true)
     end
  end
  
  describe "POST update" do
    before(:each) do
      @pin_hash = { 
        title: "Rails Wizard", 
        url: "http://railswizard.org", 
        slug: "rails-wizard", 
        text: "A fun and helpful Rails Resource",
        category_id: 2
        } 
      @pin = Pin.create(@pin_hash)
    end
    
    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      if !pin.nil?
        pin.destroy
      end
    end
    
    it 'responds with a redirect' do
      @pin_hash[:title] = "Train Wizard"
      put :update, id: @pin.id, pin: @pin_hash
      expect(response.redirect?).to be(true)
    end
    
    it 'creates a pin' do
      @pin_hash[:title] = "Train Wizard"
      put :update, id: @pin.id, pin: @pin_hash
      expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
    end
    
    it 'redirects to the show view' do
      @pin_hash[:title] = "Train Wizard"
      put :update, id: @pin.id, pin: @pin_hash
      expect(response).to redirect_to(pin_url(assigns(:pin)))
    end
    
    it 'redisplays edit form on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash[:title] = ""
      put :update, id: @pin.id, pin: @pin_hash
      puts @pin_hash
      expect(response).to render_template(:edit)
    end
    
    it 'assigns the @errors instance variable on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash[:title] = ""
      put :update, id: @pin.id, pin: @pin_hash
      expect(assigns[:errors].present?).to be(true)
    end    
    
    it 'updates a POST request with invalid parameters' do
    
    end
  
  end
  
  describe "POST repin" do
    before(:each) do  
      @pin = FactoryGirl.create(:pin)
      @pinning = FactoryGirl.create(:pinning)
      @board = Board.find(@pinning.board_id)
    end
    
    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      if !pin.nil?
        pin.destroy
      end
      logout(@user)
    end
    
    it 'responds with a redirect' do 
      post :repin, id: @pin.id, pin: @pin, pinning: @pinning, board_id: @board.id
      expect(response).to have_http_status(:redirect)
    end
    
    it 'creates a user.pin' do
      post :repin, id: @pin.id
      expect(@user.pins.present?).to be(true)
    
    end
    
    it 'redirects to the user show page' do
      post :repin, id: @pin.id
      expect(response).to redirect_to(user_path(@user.id))
    end
  end
end