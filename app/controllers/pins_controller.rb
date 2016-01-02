class PinsController < ApplicationController
  before_action :require_login, except: [:show, :show_by_name]
  def get_users
    users = User.joins(:pinnings).where(pinnings: {pin_id: @pin_id})
    if users.empty? 
      users = "No pinners yet"
    end
    users
  end
  
  def index
    @pins = Pin.all
  end
  
  def show
    @pin = Pin.find(params[:id])
  end
  
  def show_by_name
    @pin = Pin.find_by_slug(params[:slug])
    @users = get_users 
    @creater = User.find(@pin.user_id).first_name
    render :show
  end
  
  def new
    @pin = Pin.new
  end
  
  def create
    @pin = Pin.create(pin_params)
    @pin.user_id = current_user.id
    if @pin.save
      redirect_to pin_path(@pin)
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
    @pin.pinnings.create(user: current_user)
    redirect_to user_path(current_user)
  end
  
  def destroy
    Pin.find(params[:id]).destroy
    redirect_to action: "index"
  end
  
  private
  def pin_params
    params.require(:pin).permit(:title, :url, :slug, :text, :category_id, :image)
  end
  
end