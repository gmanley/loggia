class SourcesController < ApplicationController

  def autocomplete_source_name
    render json: Source.search(params['term'])
  end
end
