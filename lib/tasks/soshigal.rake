namespace :soshigal do
  desc 'Recache the number of images per album'
  task :recache_image_count => :environment do
    Album.all.each do |album|
      album.update_attribute(:image_count, album.images.count)
    end
  end

  desc 'Recache the number of images per album'
  task :recache_thumbnails => :environment do
    Album.skip_callback(:save, :before, :ensure_foo_is_not_bar)
    Album.all.each do |album|
      album.set_thumbnail_url
      album.save
    end
  end
end