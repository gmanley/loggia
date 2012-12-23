class SourcesController < ApplicationController
  respond_to :html, :json, :js

  def create
    @source = Source.new(params[:source])
    authorize!(:create, @source)

    @source.save
    respond_with(@source, location: nil)
  end
end
