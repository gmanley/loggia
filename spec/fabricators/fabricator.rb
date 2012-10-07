Fabricator(:album) do
  title { Faker::Lorem.words.collect { |w| w.titlecase}.join(' ') }
  description { Faker::Lorem.sentence }
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

Fabricator(:comment) do
  body { Faker::Lorem.sentence }
end
