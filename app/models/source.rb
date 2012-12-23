class Source < ActiveRecord::Base
  include Autocompleteable

  attr_accessible :name, :url

  has_many :images
end
