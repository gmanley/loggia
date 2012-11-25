class ImagesController < ApplicationController
  respond_to :json

  def create
    @album = Album.find_by_slug!(params[:album_id])
    @image = @album.images.new(params[:image])
    authorize!(:create, @image)

    @image.save
    # set location to nil as the image resource has no show
    respond_with(@image, location: nil)
  end

  def destroy
    @album = Album.find_by_slug!(params[:album_id])
    @image = @album.images.find(params[:id])
    authorize!(:destroy, @image)

    @image.destroy
    respond_with(@image, location: nil) # ditto
  end
end
