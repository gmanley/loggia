class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url
  field :thumb

  embedded_in :album
end