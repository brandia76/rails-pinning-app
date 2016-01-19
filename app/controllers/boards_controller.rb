class BoardsController < ApplicationController
  before_action :require_login, except: [:show]
  before_action :set_board, only: [:show, :edit, :update, :destroy]

  # GET /boards
  # GET /boards.json
  def index
    @boards = Board.where(user_id: current_user.id) + Board.joins(:board_pinners).where(board_pinners: {user_id: current_user.id})
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
    @pins = Pin.joins(:pinnings).where(pinnings: {board_id: @board.id}) 
    @followers = current_user.user_followers
    @collaborators = User.joins(:board_pinners).where(board_pinners: {board_id: @board.id})
  end
  
  # GET /boards/new
  def new
    @board = Board.new
  end

  # GET /boards/1/edit
  def edit
    #@followers = current_user.user_followers
    @followers = current_user.followed
  end

  # POST /boards
  # POST /boards.json
  def create
    @board = Board.new(board_params)
    @board.user_id = current_user.id

    if @board.name
      @board.board_slug = @board.name.downcase.gsub(" ", '-')
    end

    respond_to do |format|
      if @board.save
        format.html { redirect_to back_to_board, notice: 'Board was successfully created.' }
        format.json { render :show, status: :created, location: back_to_board }
      else
        format.html { render :new }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boards/1
  # PATCH/PUT /boards/1.json
  def update
    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to back_to_board, notice: 'Board was successfully updated.' }
        format.json { render :show, status: :ok, location: back_to_board }
      else
        format.html { render :edit }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    @board.destroy
    respond_to do |format|
      format.html { redirect_to user_path(current_user.id), notice: 'Board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def back_to_board
    board_by_user_and_name_path(username: @user.username, board_slug: @board.board_slug)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      if params[:id].present?
        @board = Board.find(params[:id])
      else
        @user = User.find_by_username(params[:username])
        @board = Board.find_by_user_id_and_board_slug(@user.id, params[:board_slug])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def board_params
      params.require(:board).permit(:name, :user_id, board_pinners_attributes: [:user_id, :board_id])
    end
end
