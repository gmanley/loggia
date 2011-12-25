class AlbumsController < ApplicationController
  respond_to :html, :js, :json

  def show
    @category = Category.find_by_slug(params[:category_id])
    @album = @category.albums.find_by_slug(params[:id])
    @images = @album.images.page(params[:page]).per(20)
    authorize! :show, @album
  end

  def new
    @category = Category.find_by_slug(params[:category_id])
    @album = current_user.albums.new
    authorize! :new, @album
  end

  def edit
    @category = Category.find_by_slug(params[:category_id])
    @album = @category.albums.find_by_slug(params[:id])
    authorize! :edit, @album
  end

  def create
    @category = Category.find_by_slug(params[:category_id])
    @album = @category.albums.create(params[:album])
    authorize! :create, @album

    if @album.persisted?
      redirect_to category_album_url(@category, @album), notice: "Album was successfully created."
    else
      render action: "new"
    end
  end

  def update
    @category = Category.find_by_slug(params[:category_id])
    @album = @category.albums.find_by_slug(params[:id])
    authorize! :update, @album

    respond_with(@album) do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to category_albums_url, notice: "Album was successfully updated." }
        format.json { render text: @album.title }
      else
        format.html { render action: "edit", notice: "There was an issue updating the album." }
        format.json { render json: { sucess: false, errors: @album.errors.full_messages } }
      end
    end
  end

  def destroy
    @album = current_user.albums.find_by_slug(params[:id])
    authorize! :destroy, @album

    @album.destroy
    redirect_to category_albums_url
  end
end