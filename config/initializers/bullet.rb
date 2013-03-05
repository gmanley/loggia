if Rails.env.development?

  Soshigal::Application.configure do
    config.after_initialize do
      Bullet.enable = true
      Bullet.bullet_logger = true
      Bullet.rails_logger = true
    end
  end
end
