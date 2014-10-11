class ImagesController < ApplicationController
  before_action :set_image, except: :index

  def show
  end

  def index
    @images = Docker::Image.all
  end

  def destroy
    if @image.remove(force: true)
      flash[:notice] = 'Image removed'
    end
    redirect_to images_path
  end

  private
  def set_image
    @image = Docker::Image.get params[:id]
  end
end
