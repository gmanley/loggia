class Photographer < ActiveRecord::Base
  include Autocompleteable

  attr_accessible :name

  has_many :images
end
