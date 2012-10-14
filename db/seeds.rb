if Rails.env.development?
  # Password for both is 'password'
  Fabricate.build(:confirmed_user, email: 'user@example.com').save
  Fabricate.build(:admin, email: 'admin@example.com').save

  puts <<-INFO.strip_heredoc
    You can login with following seed accounts:
      E: user@example.com
      P: password
      -----
      E: admin@example.com
      P: password
  INFO
end
