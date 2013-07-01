class FavoritesController < ApplicationController
  include PolymorphicController
  respond_to :js

  def create
    @favorite = Favorite.new(params[:favorite])
    @favorite.user = current_user
    authorize!(:create, @favorite)

    parent_resource.favorites << @favorite
    respond_with(@favorite, location: false)
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    authorize!(:destroy, @favorite)

    @favorite.destroy
    respond_with(@favorite, location: false)
  end
end
