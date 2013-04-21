class SourcesController < ApplicationController

  def show
    @source = Source.find(params[:id])
    @images = @source.images.page(params[:page])
    authorize!(:show, Source)
  end
end
