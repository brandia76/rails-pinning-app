require 'spec_helper'
RSpec.describe BoardsController do
  before(:each) do  
    @user = FactoryGirl.create(:user_with_boards_and_followers)
    @board = @user.boards.first
    login(@user)
  end
  after(:each) do
    logout(@user)
  end
  
  describe "GET new" do
    it 'responds with success' do
      get :new
      expect(response.success?).to be(true)
    end
    
    it 'renders the new view' do
      get :new
      expect(response).to render_template(:new)
    end
    
    it 'assigns an instance to a new board' do
      get :new
      expect(assigns(:board)).to be_a_new(Board)
    end
    
    it 'reditrects tot he login page if the user is not logged in ' do
      logout(@user)
      get :new
      expect(response).to redirect_to(:login)
    end
  end
  
  describe "POST create" do
    before(:each) do
      @board_hash = {
        name: "My Pins!",
        board_slug: "my_pins!"
      }
    end
    
    
    it 'responds with a redirect' do
      post :create, board: @board_hash
      expect(response.redirect?).to be(true)
    end
    
    it 'create a board' do
      post :create, board: @board_hash
      expect(Board.find_by_name("My Pins!").present?).to be(true)
    end
    
    it 'redirects to the show view' do
      post :create, board: @board_hash
      
      expect(response).to have_http_status(:redirect)
    end
    
    it 'redisplays new form on error' do
      @board_hash[:name] = nil
      post :create, board: @board_hash
      expect(response).to render_template("new")
    end
  end
  
  describe "GET #show" do
    
    it 'assigned the @pins variable with the boards pins' do
      get :show, username: @user.username, board_slug: @board.board_slug
      expect(assigns(:pins) == @board.pins).to eq(true)
    end
  end
  
  describe "GET #edit" do
    it 'responds successfully' do
      get :edit, id: @board.id
      expect(response.success?).to be(true)
    end
    
    it 'renders the edit view' do
      get :edit, id: @board.id
      expect(response).to render_template("edit")
    end
    
    it 'assigns an requested board as @board' do
      get :edit, id: @board.id
      expect(assigns[:board] == @board).to be(true)
    end
    
    it 'redirects to the login page if user is not logged in' do
      logout(@user)
      get :edit, id: @board.id
      expect(response).to redirect_to(:login)
    end
    
    it 'sets @followers to the users\'s followers' do
      get :edit, id: @board.id
      expect(assigns[:followers] == @user.user_followers)
    end
  end
  
  describe "PUT #update" do
    before(:each) do
      @board_hash = {
        name: @board.name,
        board_slug: @board.board_slug
      }
    end
    
    it 'responds with a redirect' do
      put :update, id: @board.id, board: @board_hash
      expect(response).to have_http_status(:redirect)
    end
    
    it 'redirects to the show view' do
      put :update, id: @board.id, board: @board_hash
      expect(response.body).to include(@board.board_slug)
    end
    
    it 'redisplays edit for on error' do
      @board_hash[:name] = ""
      put :update, id: @board.id, board: @board_hash
      expect(response).to render_template("edit")
    end
    
    it 'assigns the @errors instance ariable on error' do
      @board_hash[:name] = ""
      put :update, id: @board.id, board: @board_hash
      expect(assigns[:board].errors.any?).to be(true)
    end
    
    it 'redirects to the login page if user is not logged in' do
      logout(@user)
      put :update, id: @board.id, board: @board_hash
      expect(response).to redirect_to(:login)
    end
    
    it 'creates a BoardPinning' do
      user_to_let_pin = @user.followers.first
      @board_hash[:board_pinners_attributes] = []
      @board_hash[:board_pinners_attributes] << {user_id: user_to_let_pin.follower_id}
      put :update, id: @board.id, board: @board_hash
      board_pinner = BoardPinner.where("user_id = ? AND board_id = ?", user_to_let_pin.follower_id, @board.id)
      expect(board_pinner.present?).to be(true)
    end
  end
end

