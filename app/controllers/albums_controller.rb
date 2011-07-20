class AlbumsController < ApplicationController

  def index
    @albums = Album.all
  end

  def show
    @album = Album.find_by_slug(params[:id])
    @image = @album.images.new
  end

  def new
    @album = current_user.albums.new
  end

  def edit
    @album = current_user.albums.find_by_slug(params[:id])
  end

  def create
    @album = current_user.albums.new(params[:album])

    if @album.save
      redirect_to @album, notice: "Album was successfully created."
    else
      render action: "new"
    end
  end

  def update
    @album = current_user.albums.find_by_slug(params[:id])

    if @album.update_attributes(params[:album])
      redirect_to @album, notice: "Album was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @album = current_user.albums.find_by_slug(params[:id])
    @album.destroy

    redirect_to albums_url
  end
end
