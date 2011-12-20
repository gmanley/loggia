module IPGallery

  class LegacyCategory
    include DataMapper::Resource

    storage_names[:default] = "gallery_categories"

    has n, :albums, 'LegacyAlbum', :child_key => [ :category_id ]
    has n, :images, 'LegacyImage'
    has n, :child_categories, self.name, :child_key => [ :parent ]
    belongs_to :parent_category, self.name, :child_key => [ :parent ]

    property :id, Serial
    property :title, String, :field => 'name'
    property :description, String
    property :parent, Integer

    def attr_to_be_imported
      self.attributes.select{|k,v| [:title, :description].include?(k)}.merge(:legacy_id => self.id)
    end
  end

  class LegacyAlbum
    include DataMapper::Resource

    storage_names[:default] = "gallery_albums"

    has n, :images, 'LegacyImage'
    belongs_to :category, 'LegacyCategory'

    property :id, Serial
    property :title, String, :field => 'name'
    property :description, String
    property :category_id, Integer

    def attr_to_be_imported
      self.attributes.select{|k,v| [:title, :description].include?(k)}.merge(:legacy_id => self.id)
    end
  end

  class LegacyImage
    include DataMapper::Resource

    storage_names[:default] = "gallery_images"

    belongs_to :category, 'LegacyCategory'
    belongs_to :album, 'LegacyAlbum'

    property :id, Serial
    property :category_id, Integer
    property :album_id, Integer
    property :directory, String
    property :file_name, String, :field => 'masked_file_name'

    def file_path(upload_root)
      path = File.join(upload_root, directory, file_name)
      File.file?(path) && %w(.jpg .jpeg .gif .png).include?(File.extname) ? path : nil
    end
  end

  class Import

    def initialize(upload_root)
      config = YAML.load_file(File.join(Rails.root, 'config/legacy_import.yml'))
      DataMapper::Logger.new(STDOUT, :warn)
      DataMapper.setup(:default, config['ipgallery'])
      @upload_root = upload_root
    end

    def start
      import_categories
      import_albums
      import_images
      puts 'Import Successful!'
    rescue Exception => e
      Category.destroy_all(:conditions => {:legacy_id.exists => true})
      Album.destroy_all(:conditions => {:legacy_id.exists => true})
      raise e
    end

    def import_categories
      Category.collection.insert(LegacyCategory.all.collect {|lc| lc.attr_to_be_imported})
      categories = Category.where(:legacy_id.exists => true)
      progress_bar = ProgressBar.new('Category Import', categories.count)
      categories.each do |category|
        legacy_category = LegacyCategory.get(category.legacy_id)
        unless legacy_category.parent.eql?(0)
          category.parent_category = Category.where(:legacy_id => legacy_category.id).first
          category.save
        end
        progress_bar.inc
      end
      progress_bar.finish
    end

    def import_albums
      Album.collection.insert(LegacyAlbum.all.collect {|la| la.attr_to_be_imported})
      albums = Album.where(:legacy_id.exists => true)
      progress_bar = ProgressBar.new('Album Import', albums.count)
      albums.each do |album|
        legacy_album = LegacyAlbum.get(album.legacy_id)
        unless legacy_album.category_id.eql?(0)
          album.category = Category.where(:legacy_id => legacy_album.category_id).first
          album.save
        end
        progress_bar.inc
      end
      progress_bar.finish
    end

    def import_images
      legacy_images = LegacyImage.all
      progress_bar = ProgressBar.new('Image Import', legacy_images.count)
      legacy_images.each do |legacy_image|
        image = Image.new
        if image_file_path = legacy_image.file_path(@upload_root)
          if image_album = Album.where(:legacy_id => legacy_image.album_id).first
            image.album = image_album
            image.image = File.open(image_file_path)
            image.save
          end
        end
        progress_bar.inc
      end
      progress_bar.finish
    end
  end
end