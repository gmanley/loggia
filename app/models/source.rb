class Source < ActiveRecord::Base
  include Autocompleteable

  POSSIBLE_KINDS = %w[photographer website]

  attr_accessible :name, :url, :kind

  validates :kind, presence: true,
                   inclusion: {
                     in: POSSIBLE_KINDS,
                     message: "%{value} is not a valid kind of source"
                   }

  validates :name, presence: true,
                   uniqueness: {
                    scope: :kind,
                    case_sensitive: false
                   }

  has_and_belongs_to_many :images, uniq: true

  scope :websites, where(kind: 'website')

  scope :photographers, where(kind: 'photographer')
end
