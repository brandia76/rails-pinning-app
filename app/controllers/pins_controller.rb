class PinsController < ApplicationController
  
  def index
    @pins = Pin.all
  end
  
  def show
    @pin = Pin.find(params[:id])
  end
  
  def show_by_name
    @pin = Pin.find_by_slug(params[:slug])
    render :show
  end
  
  def new
    @pin = Pin.new
  end
  
  def create
    @pin = Pin.create(pin_params)
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
    if @pin.update_attributes(pin_params)
      redirect_to pin_path(@pin)
    else
      @errors = @pin.errors.full_messages
      render :edit
    end
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