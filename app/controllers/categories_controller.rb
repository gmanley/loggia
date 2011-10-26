class CategoriesController < ApplicationController

  def index
    @categories = Category.roots
  end

  def show
    @category = Category.find_by_slug(params[:id])
    @album = @category.albums.new
  end

  def edit
    @category = Category.find_by_slug(params[:id])
  end

  def create
    if params[:category][:parent_id].blank?
         @page.parent_id = nil
    else
      @page.parent_id = Category.find_by_slug(params[:page][:parent_id]).id
    end

    if @category = Category.create(params[:category])
      redirect_to @category, notice: "Category was successfully created."
    else
      render action: "new"
    end
  end

  def update
    @category = Category.find_by_slug(params[:id])

    if @category.update_attributes(params[:category])
      redirect_to @category, notice: "Category was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @category = Category.find_by_slug(params[:id])
    if @category.destroy
      redirect_to categories_url, notice: "Category was succesfully destroyed."
    else
      redirect_to @category
    end
  end
end
