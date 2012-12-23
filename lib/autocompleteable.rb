module Autocompleteable
  extend ActiveSupport::Concern

  included do
    after_create  :add_to_autocomplete_cache
    after_destroy :remove_from_autocomplete_cache
  end

  private
  def autocomplete_cache
    @autocomplete_cache ||= Soulmate::Loader.new(self.class.name.downcase)
  end

  def add_to_autocomplete_cache
    autocomplete_cache.add('term' => name, 'id' => id)
  end

  def remove_from_autocomplete_cache
    autocomplete_cache.remove('id' => id)
  end
end
