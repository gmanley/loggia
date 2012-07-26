class FavoritesController < ApplicationController
  respond_to :js
  before_filter :set_parent_resource

  def create
    @favorite = Favorite.new(params[:favorite])
    @favorite.user = current_user
    authorize!(:create, @favorite)

    @parent_resource.favorites << @favorite
    respond_with(@favorite, location: false)
  end

  def destroy
    @favorite = @parent_resource.favorites.find(params[:id])
    authorize!(:destroy, @favorite)

    @favorite.destroy
    respond_with(@favorite, location: false)
  end

  private
  def set_parent_resource
    params.keys.grep(/(.+)_id$/) do |parent_resource_id_key|
      parent_resource_id = params[parent_resource_id_key]
      parent_resource_class = $1.classify.constantize
      @parent_resource = parent_resource_class.find_by_slug!(parent_resource_id)
    end
  end
end