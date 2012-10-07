class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String

  embedded_in :commentable, polymorphic: true, inverse_of: :comments
  belongs_to :user

  validates_presence_of :body
end
