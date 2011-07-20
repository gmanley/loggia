class ImagesController < ApplicationController

  def show
    @album = Album.find_by_slug(params[:album_id])
    @image = @album.images.find(params[:id])
  end

  def create
    @album = Album.find_by_slug(params[:album_id])
    @image = @album.images.create!(params[:image])

    if @image.save
      redirect_to @album, notice: 'Image was successfully uploaded.'
    else
      render action: "new"
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

