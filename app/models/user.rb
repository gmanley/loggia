class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments, -> { order(:created_at) },
                      as: :commentable

  has_many :favorites, as: :favoritable

  has_many :uploads, class_name: 'Image',
                     inverse_of: :uploader,
                     foreign_key: 'uploader_id'
end
