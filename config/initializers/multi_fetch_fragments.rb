# Cache partials rendering a collection by default when caching is enabled.
# The caching functionality is provided by multi_fetch_fragments.
ActionView::PartialRenderer.class_eval do
  private
  def cache_collection?
    ActionController::Base.perform_caching
  end
end
