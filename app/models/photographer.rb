class Photographer < ActiveRecord::Base
  include Autocompleteable

  attr_accessible :name

  validates :name, presence: true,
                   uniqueness: {
                    case_sensitive: false
                   }

  has_many :images
end
