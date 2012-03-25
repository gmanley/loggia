class CategoriesController < ApplicationController
  respond_to :html, :json, :js
  load_and_authorize_resource find_by: :slug

  def index
    @containers = @categories.roots.asc(:title)
    respond_with(@containers)
  end

  def new
    respond_with(@category)
  end

  def show
    @children = @category.children.asc(:title)
    respond_with(@category)
  end

  def edit
    respond_with(@category)
  end

  def create
    @category.save
    respond_with(@category)
  end

  def update
    @category.update_attributes(params[:category])
    respond_with(@category)
  end

  def destroy
    @category.destroy
    respond_with(@category, location: root_path)
  end
end
