class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :comments,  as: :commentable, order: :created_at
  has_many :favorites, as: :favoritable

  has_many :uploads, class_name: 'Image',
                     inverse_of: :uploader,
                     foreign_key: 'uploader_id'
end
