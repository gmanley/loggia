namespace :soshigal do
  desc 'Recache the number of images per album'
  task :image_count_recache => :environment do
    Album.all.each do |album|
      album.update_attribute(:image_count, album.images.count)
    end
  end
end