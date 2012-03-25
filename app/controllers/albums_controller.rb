class AlbumsController < ApplicationController
  respond_to :html, :json, :js
  load_and_authorize_resource find_by: :slug

  def show
    @images = @album.images.page(params[:page]).per(100)
    respond_with(@album)
  end

  def new
    respond_with(@album)
  end

  def edit
    respond_with(@album)
  end

  def create
    @album.save
    respond_with(@album)
  end

  def update
    @album.update_attributes(params[:album])
    respond_with(@album)
  end

  def destroy
    @album.destroy
    respond_with(@album, location: root_path)
  end
end