class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Devise fields
  # Database authenticatable
  field :email,                  type: String
  field :encrypted_password,     type: String
  # Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time
  # Rememberable
  field :remember_created_at,    type: Time
  # Trackable
  field :sign_in_count,          type: Integer, default: 0
  field :current_sign_in_at,     type: Time
  field :last_sign_in_at,        type: Time
  field :current_sign_in_ip,     type: String
  field :last_sign_in_ip,        type: String
  # Confirmable
  field :confirmation_token,     type: String
  field :confirmed_at,           type: Time
  field :confirmation_sent_at,   type: Time
  field :unconfirmed_email,      type: String

  ## Custom Fields
  field :admin, type: Boolean

  has_many :favorites

  alias_method :admin, :admin?
end