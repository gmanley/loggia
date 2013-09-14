class ImageChecksumer
  include BaseWorker

  def perform(image_id)
    record = Image.find(image_id)
    record.set_md5
    record.save
  end
end
