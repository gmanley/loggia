class ImagesController < ApplicationController
  respond_to :html, :json

  def show
    album = Album.find_by_slug(params[:album_id])
    image = album.images.find(params[:id])
    authorize!(:show, image)

    redirect_to paginated_album_path(album, image.album_page_num,
      anchor: "/images/#{params[:id]}"
    )
  end

  def create
    @album = Album.find_by_slug!(params[:album_id])
    @image = @album.images.new(image_params)
    @image.uploader = current_user
    authorize!(:create, @image)

    @image.save
    respond_with(@image)
  end

  def destroy
    @image = Image.find(params[:id])
    authorize!(:destroy, @image)

    @image.destroy
    respond_with(@image)
  end

  private
  def image_params
    params.require(:image).permit(:image, :sources_attributes)
  end
end
