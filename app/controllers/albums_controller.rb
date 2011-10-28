class AlbumsController < ApplicationController

  def index
    @albums = Album.all
  end

  def show
    @category = Category.find_by_slug(params[:category_id])
    @album = @category.albums.find_by_slug(params[:id])
    @images = @album.images.page(params[:page])
  end

  def new
    @album = current_user.albums.new
  end

  def edit
    @album = current_user.albums.find_by_slug(params[:id])
  end

  def create
    @category = Category.find_by_slug(params[:category_id])
    @album = @category.albums.create(params[:album])

    if @album.persisted?
      redirect_to category_album_url(@category, @album), notice: "Album was successfully created."
    else
      render action: "new"
    end
  end

  def update
    @album = @category.albums.find_by_slug(params[:id])

    if @album.update_attributes(params[:album])
      redirect_to category_albums_url, notice: "Album was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @album = current_user.albums.find_by_slug(params[:id])
    @album.destroy

    redirect_to category_albums_url
  end
end