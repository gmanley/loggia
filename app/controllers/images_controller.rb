class ImagesController < ApplicationController

  def show
    @category = Category.find_by_slug(params[:category_id])
    @album = @category.albums.find_by_slug(params[:album_id])
    @image = @album.images.find(params[:id])
  end

  def create
    @category = Category.find_by_slug(params[:category_id])
    @album = @category.albums.find_by_slug(params[:album_id])

    if @image = @album.images.create!(params[:image])
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @album = Album.find_by_slug(params[:album_id])
    @image = @album.images.find(params[:id])

    if @image.update_attributes(params[:image])
      redirect_to @image, notice: 'Image was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @album = Album.find_by_slug(params[:album_id])
    @image = @album.images.find(params[:id])
    @image.destroy
  end
end