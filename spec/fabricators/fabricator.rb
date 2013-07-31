Fabricator(:album) do
  title { Faker::Lorem.words.collect(&:titlecase).join(' ') }
  description { Faker::Lorem.sentence }
end

Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  password_confirmation { |user| user[:password] }
end

Fabricator(:confirmed_user, from: :user) do
  confirmed_at { Time.now }
  confirmation_token nil
end

Fabricator(:admin, from: :confirmed_user) do
  admin true
end

Fabricator(:comment) do
  body { Faker::Lorem.sentence }
end

Fabricator(:album_comment, from: :comment) do
  commentable(fabricator: :album)
end

Fabricator(:image) do
  album
  md5 { SecureRandom.hex }
end

Fabricator(:source) do
  kind { %w(photographer website).sample }
  name { |attrs| sequence(:name) { |i| "#{attrs[:kind]}#{i}" } }
end
