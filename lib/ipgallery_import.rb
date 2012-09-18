module IPGallery
  class LegacyAlbum
    include DataMapper::Resource

    storage_names[:default] = 'gallery_albums_main'

    has n,     :images,      'LegacyImage'
    has n,     :child_albums, name, child_key: [:parent_id]
    belongs_to :parent_album, name, child_key: [:parent_id]

    property :id,          Serial,  field: 'album_id'
    property :title,       String,  field: 'album_name'
    property :description, String,  field: 'album_description'
    property :parent_id,   Integer, field: 'album_parent_id'
    property :is_public,   Integer, field: 'album_is_public'

    def self.public
      all(is_public: 1)
    end

    def importable_attributes
      attrs = attributes.extract!(:title, :description)
      attrs.each { |key, value| attrs[key] = CGI.unescape_html(value) }
      attrs.merge(legacy_id: id)
    end
  end

  class LegacyImage
    include DataMapper::Resource

    VALID_EXTENSIONS = %w(.jpg .jpeg .gif .png)

    storage_names[:default] = 'gallery_images'

    belongs_to :album, 'LegacyAlbum'

    property :id,          Serial
    property :album_id,    Integer, field: 'img_album_id'
    property :directory,   String
    property :file_name,   String,  field: 'masked_file_name'

    def self.valid_image?(path)
      File.file?(path) && VALID_EXTENSIONS.include?(File.extname(path))
    end

    def file_path(upload_root)
      File.join(upload_root, directory, file_name)
    end
  end

  class Import

    def initialize(upload_root)
      config = YAML.load_file(Rails.root.join('config/legacy_import.yml'))
      DataMapper::Logger.new(STDOUT, :warn)
      DataMapper.setup(:default, config['ipgallery'])
      Image.send(:store_in_background, :image)
      ImageUploader.send(:include, CarrierWave::Backgrounder::Delay)
      @upload_root = upload_root
    end

    def start
      import_albums
      import_images
      puts 'Import Successful!'
    rescue StandardError => e
      Album.where(:legacy_id.exists => true).destroy_all
      raise e
    end

    def import_albums
      legacy_albums = LegacyAlbum.public.collect(&:importable_attributes)
      Album.collection.insert(legacy_albums)

      albums = Album.where(:legacy_id.exists => true)
      progress_bar = ProgressBar.new('Album Import', albums.count)
      albums.each do |album|
        proccess_album(album)
        progress_bar.inc
      end

      progress_bar.finish
    end

    def proccess_album(album)
      album.set_created_at

      legacy_album = LegacyAlbum.get(album.legacy_id)
      album.parent = Album.where(legacy_id: legacy_album.parent_id).first

      album.save
    end

    def import_images
      progress_bar = ProgressBar.new('Image Import', LegacyImage.count)
      LegacyImage.each do |legacy_image|
        import_image(legacy_image)
        progress_bar.inc
      end

      progress_bar.finish
    end

    def import_image(legacy_image)
      image_file_path = legacy_image.file_path(@upload_root)
      if LegacyImage.valid_image?(image_file_path)
        if album = Album.where(legacy_id: legacy_image.album_id).first
          image = album.images.new
          image.image = File.open(image_file_path)
          image.save
        end
      end
    rescue StandardError => e
      puts "Error: #{e.message} importing #{image_file_path}"
    end
  end
end
