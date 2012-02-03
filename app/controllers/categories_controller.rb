class CategoriesController < ApplicationController
  respond_to :html, :json, :js
  load_and_authorize_resource find_by: :slug

  def index
    @categories = @categories.roots.asc(:title)
    respond_with(@categories)
  end

  def new
    respond_with(@category)
  end

  def show
    @child_categories = @category.children.asc(:title)
    @category_albums = @category.albums.asc(:title)
    respond_with(@category)
  end

  def edit
    respond_with(@category)
  end

  def create
    @category.parent = Category.find_by_slug(params[:category_id])
    @category.save
    respond_with(@category)
  end

  def update
    @category.update_attributes(params[:category])
    respond_with(@category)
  end

  def destroy
    @category.destroy
    respond_with(@category)
  end
end