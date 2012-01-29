class AlbumsController < ApplicationController
  respond_to :html, :json, :js
  load_and_authorize_resource :category, find_by: :slug
  load_and_authorize_resource find_by: :slug, through: :category

  def show
    @images = @album.images.page(params[:page]).per(100)
    respond_with(@category, @album)
  end

  def new
    respond_with(@category, @album)
  end

  def edit
    @category = @album.category
    respond_with(@category, @album)
  end

  def create
    @album.save
    respond_with(@category, @album)
  end

  def update
    @album.update_attributes(params[:album])
    respond_with(@category, @album)
  end

  def destroy
    @album.destroy
    respond_with(@category, @album, location: root_path)
  end
end