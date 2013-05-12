class ImagesController < ApplicationController
  respond_to :json

  def create
    @album = Album.find_by_slug!(params[:album_id])
    @image = @album.images.new(correct_params(params[:image]))
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
  def correct_params(attrs)
    attrs[:image] = attrs.delete(:image).first
    attrs
  end
end
