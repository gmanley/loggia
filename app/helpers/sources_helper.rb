module SourcesHelper

  def source_selected?(source)
    # Is the user filtering by specific sources?
    if params[:album] && source_ids = params[:album][:source_ids]
      source_ids.include?(source.id.to_s)
    else # Nope, so all sources are selected.
      true
    end
  end
end
