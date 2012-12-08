class Thumbnailer
  include Sidekiq::Worker

  def perform(image_id)
    image = Image.find(image_id)
    image.set_thumbnails
  end
end
