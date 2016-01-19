class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update, :destroy, :show_by_username, :index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    redirect_to user_by_username_path(@user.username)
  end
  
  def show_by_username
    @user = User.find_by_username(params[:username])
    @boards = Board.where(user_id: @user.id) + Board.joins(:board_pinners).where(board_pinners: {user_id: @user.id})
 
    render :show
  end
  
  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end
  
  def login
  end
  
  # GET /users/login
  def authenticate
    @user = User.authenticate(params[:email], params[:password])
    if @user.nil?
      @errors = ["Invalid email or password"] #@user.errors.full_messages 
      render :login
    else
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    end
  end
  
  def logout
    session.delete(:user_id)
    current_user = nil
    redirect_to root_url
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :username)
  end
    
end
