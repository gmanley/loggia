class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :favoritable, polymorphic: true, inverse_of: :favorites
  belongs_to :user, index: true
end
