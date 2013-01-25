class Source < ActiveRecord::Base
  include Autocompleteable

  attr_accessible :name, :url

  validates :name, presence: true,
                   uniqueness: {
                    case_sensitive: false
                   }

  has_many :images
end
