class PinsController < ApplicationController
  before_action :require_login, except: [:show, :show_by_name]
  
  def get_users
    users = User.joins(:pinnings).where(pinnings: {pin_id: @pin.id})#.pluck(:first_name, :last_name).map { |names| names.join(" ")}
    if users.empty? 
         print "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ #{users.count}"
      users = ["No pinners yet"]
    #else
      #users = users.join(", ")
    end
  end
  
  def index
    @pins = Pin.all
  end
  
  def show
    @pin = Pin.find(params[:id])
    redirect_to pin_by_name_path(@pin.slug)
  end
  
  def show_by_name
    @pin = Pin.find_by_slug(params[:slug])
    @users = users = User.joins(:pinnings).where(pinnings: {pin_id: @pin.id}) 
    @creater = User.find(@pin.user_id)
    render :show
  end
  
  def new
    @pin = Pin.new
  end
  
  def create
    @pin = Pin.create(pin_params)
    @pin.slug = @pin.title.downcase.gsub(" ", '-')
    @pin.user_id = current_user.id
    if @pin.save
      redirect_to pin_by_name_path(@pin.slug)
    else
      @errors = @pin.errors.full_messages
      render :new
    end
  end
  
  def edit
    @pin = Pin.find(params[:id])
    render :edit
  end
  
  def update
    @pin = Pin.find(params[:id])
    @pin.user_id = current_user.id
    if @pin.update_attributes(pin_params)
      redirect_to pin_path(@pin)
    else
      @errors = @pin.errors.full_messages
      render :edit
    end
  end
  
  def repin
    @pin = Pin.find(params[:id])
    board = params[:pin][:pinning][:board_id]
    unless Board.find_by_user_id_and_pin_id_and_board_id(current_user.id,@pin.id,board)
      @pin.pinnings.create(user_id: current_user.id, board_id: board)
    end
    redirect_to user_path(current_user)
  end
  
  def destroy
    Pin.find(params[:id]).destroy
    redirect_to action: "index"
  end
  
  private
  def pin_params
    params.require(:pin).permit(:title, :url, :text, :slug, :category_id, :image)
  end
  
end