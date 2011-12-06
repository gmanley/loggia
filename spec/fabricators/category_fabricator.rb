Fabricator(:category) do
  title { Faker::Lorem.words.collect {|w| w.titlecase}.join(' ') }
end