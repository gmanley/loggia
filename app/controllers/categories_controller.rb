class CategoriesController < ApplicationController
  respond_to :html, :json, :js

  def index
    @categories = Category.roots.accessible_by(current_ability)
    authorize!(:index, Category)

    respond_with(@categories)
  end

  def show
    @category = Category.find_by_slug(params[:id])
    @children = @category.children.accessible_by(current_ability)
    authorize!(:show, @category)

    respond_with(@category)
  end

  def new
    @category = Category.new(params[:category])
    authorize!(:new, @category)

    respond_with(@category)
  end

  def edit
    @category = Category.find_by_slug(params[:id])
    authorize!(:edit, @category)

    respond_with(@category)
  end

  def create
    @category = Category.new(params[:category])
    authorize!(:create, @category)

    @category.save
    respond_with(@category)
  end

  def update
    @category = Category.find_by_slug(params[:id])
    authorize!(:update, @category)

    @category.update_attributes(params[:category])
    respond_with(@category)
  end

  def destroy
    @category = Category.find_by_slug(params[:id])
    authorize!(:destroy, @category)

    @category.destroy
    respond_with(@category, location: root_path)
  end
end
