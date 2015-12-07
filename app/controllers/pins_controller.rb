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
    @pin = Pin.create(pins_params)
  end
  
  private
  def pin_params
    params.require(:pins).permit(:title, :url, :slug, :text, :category_id)
  end
end