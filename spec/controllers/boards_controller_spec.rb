require 'spec_helper'
RSpec.describe BoardsController do
  before(:each) do  
    @user = FactoryGirl.create(:user)
    @board = @user.boards.first
    login(@user)
  end
  after(:each) do
    logout(@user)
    unless @user.destroyed?
      @user.pins.destroy_all
      @user.pinnings.destroy_all
      @user.boards.destroy_all
      @user.destroy
    end
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
      #expect(response.redirect?).to be(true)
      expect(response).to redirect_to(:login)
    end
  
  end
  
  describe "POST create" do
    before(:each) do
      @board_hash = {
        name: "My Pins!"
      }
    end
    
    after(:each) do
      board = Board.find_by_name("My Pins!")
      unless board.nil?
        board.destroy
      end
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
      expect(response.redirect?).to redirect_to(board_url(assigns(:board)))
    end
    
    it 'redisplays new form on error' do
      @board_hash[:name] = nil
      post :create, board: @board_hash
      expect(response).to render_template("new")
    end
  end
  
  describe "GET #show" do
    it 'assigns the requested board' do
      get :show, id: @board.id
      expect(assigns(:board) == @board).to eq(true)
    end
    
    it 'assigned the @pins variable with the boards pins' do
      get :show, id: @board.id
      expect(assigns(:pins) == @board.pins).to eq(true)
    end
  end
end

