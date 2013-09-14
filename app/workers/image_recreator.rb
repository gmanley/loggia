class ImageRecreator
  include BaseWorker

  def perform(image_id, version = nil)
    record = Image.find(image_id)
    record.image.recreate_versions!(*Array(version).compact!)
  end
end
