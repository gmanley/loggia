class ImagesController < ApplicationController
  respond_to :html, :json

  def show
    album = Album.find_by_slug(params[:album_id])
    image = album.images.find(params[:id])
    page_number = image.album_page_num
    authorize!(:show, image)

    redirect_to paginated_album_path(album, page_number,
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
    attrs = params[:image]
    attrs[:image] = attrs.delete(:image).first
    attrs
  end
end
