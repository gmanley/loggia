class ImageRecreator
  include Sidekiq::Worker

  def perform(image_id, version = nil)
    ActiveRecord::Base.connection_pool.with_connection do
      record = Image.find(image_id)
      record.image.recreate_versions!(*Array(version).compact!)
    end
  end
end
