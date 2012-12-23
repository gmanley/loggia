class PhotographersController < ApplicationController
  respond_to :html, :json, :js

  def create
    @photographer = Photographer.new(params[:photographer])
    authorize!(:create, @photographer)

    @photographer.save
    respond_with(@photographer, location: nil)
  end
end
