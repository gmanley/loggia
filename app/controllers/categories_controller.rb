class CategoriesController < ApplicationController

  def new
    @category = Category.new
  end

  def show
    @category = Category.find_by_slug(params[:id])
  end

  def edit
    @category = Category.find_by_slug(params[:id])
  end

  def create
    @category = Category.new(params[:category])

    if parent_category = Category.find_by_slug(params[:category_id])
      @category.parent_category = parent_category
    end

    if @category.save
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
