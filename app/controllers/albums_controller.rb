class AlbumsController < ApplicationController

  def index
    @albums = Album.all
  end

  def new
    @album = current_user.albums.new
  end

  def create
    if @album = current_user.albums.create(params[:album])
      redirect_to albums_url, :notice => 'Album Created Successfully!'
    else
      redirect_to root_url, :notice => 'Error'
    end
  end

  def show
    @album = Album.find_by_slug(params[:id])
  end
end