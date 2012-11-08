class Comment < ActiveRecord::Base
  attr_accessible :body

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
end
