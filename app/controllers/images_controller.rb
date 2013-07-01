class ImagesController < ApplicationController
  respond_to :json

  def create
    @album = Album.find_by_slug!(params[:album_id])
    @image = @album.images.new(image_params)
    @image.uploader = current_user
    authorize!(:create, @image)

    @image.save
    # set location to nil as the image resource has no show
    respond_with(@image, location: nil)
  end

  def destroy
    @image = Image.find(params[:id])
    authorize!(:destroy, @image)

    @image.destroy
    respond_with(@image, location: nil) # ditto
  end

  private
  def image_params
    params[:image] = params.delete(:image).first
    params.require(:image).permit(:image, :sources_attributes, :uploader)
  end
end
