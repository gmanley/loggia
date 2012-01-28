namespace :soshigal do
  desc 'Recache the number of images per album'
  task :recache_image_count => :environment do
    Album.skip_callback(:save, :before, :set_thumbnail_url)
    Album.all.each do |album|
      album.update_attribute(:image_count, album.images.count)
    end
  end

  desc 'Recache album and category thumbnails'
  task :recache_thumbnails => :environment do
    Album.skip_callback(:save, :before, :set_thumbnail_url)
    Album.all.each do |album|
      album.set_thumbnail_url
      album.save
    end

    Category.skip_callback(:save, :before, :set_thumbnail_url)
    Category.all.each do |category|
      category.set_thumbnail_url
      category.save
    end
  end
end