Fabricator(:container) do
  title { Faker::Lorem.words.collect {|w| w.titlecase}.join(' ') }
  description { Faker::Lorem.sentence }
end

Fabricator(:album, from: :container, class_name: :album) do
  _type 'Album'
end

Fabricator(:category, from: :container, class_name: :category) do
  _type 'Category'
end

Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  password_confirmation { |user| user[:password] }
end

Fabricator(:confirmed_user, from: :user) do
  confirmed_user true
  confirmed_at { Time.now }
  confirmation_token nil
end

Fabricator(:admin, from: :confirmed_user) do
  admin true
end