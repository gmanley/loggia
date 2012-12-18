class Source < ActiveRecord::Base
  attr_accessible :name, :url, :image_id

  after_create  :add_to_autocomplete_cache
  after_destroy :remove_from_autocomplete_cache

  def self.search(term)
    Soulmate::Matcher.new(self.name.downcase).matches_for_term(term)
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
