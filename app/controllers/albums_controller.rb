class AlbumsController < ApplicationController
  respond_to :html, :json, :js

  def index
    @albums = Album.roots.order(:title).accessible_by(current_ability)
    @recent_albums = Album.recently_updated.limit(5).accessible_by(current_ability)

    authorize!(:index, Album)

    respond_with(@albums)
  end

  def show
    @album = Album.find_by_slug!(params[:id])
    @children = @album.children.accessible_by(current_ability)
    @images = get_images.page(params[:page])
    @comments = @album.comments.includes(:user)
    authorize!(:show, @album)

    respond_with(@album)
  end

  def new
    @album = Album.new(params[:album])
    authorize!(:new, @album)

    respond_with(@album)
  end

  def edit
    @album = Album.find_by_slug!(params[:id])
    authorize!(:edit, @album)

    respond_with(@album)
  end

  def create
    @album = Album.new(params[:album])
    authorize!(:create, @album)

    @album.save
    respond_with(@album)
  end

  def update
    @album = Album.find_by_slug!(params[:id])
    authorize!(:update, @album)

    @album.update_attributes(params[:album])
    respond_with(@album)
  end

  def destroy
    @album = Album.find_by_slug!(params[:id])
    authorize!(:destroy, @album)

    @album.destroy
    respond_with(@album, location: root_path)
  end

  private
  def get_images
    query = params[:album]

    if query.present? && query[:source_ids].is_a?(Array)
      sources_ids = query[:source_ids].reject(&:blank?)
      @album.images.where(source_id: sources_ids)
    else
      @album.images
    end
  end
end
