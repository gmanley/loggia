module Autocompleteable
  extend ActiveSupport::Concern

  class UnconfiguredException < Exception; end

  included do
    after_create  :add_to_autocomplete_cache
    after_destroy :remove_from_autocomplete_cache
  end

  private
  # Override in class if needed
  def autocomplete_kind
    self[:kind] || self.class.name.downcase
  end

  # Should be overridden in class if no 'name' attribute
  def autocomplete_term
    if name = self[:name]
      name
    else
      message = 'Add an autocomplete_term method to your class!'
      raise UnconfiguredException, message
    end
  end

  def autocomplete_data
    { }
  end

  def autocomplete_cache
    @autocomplete_cache ||= Soulmate::Loader.new(autocomplete_kind)
  end

  def add_to_autocomplete_cache
    autocomplete_cache.add(
      'term' => autocomplete_term,
      'id' => id,
      'data' => autocomplete_data
    )
  end

  def remove_from_autocomplete_cache
    autocomplete_cache.remove('id' => id)
  end
end
