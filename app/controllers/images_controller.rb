class ImagesController < ApplicationController
  respond_to :json, :js
  load_and_authorize_resource :album, find_by: :slug
  load_and_authorize_resource through: :album

  def create
    @image.save
    respond_with(@image)
  end

  def destroy
    @image.destroy
    respond_with(@image)
  end
end