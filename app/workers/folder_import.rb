module FolderImport
  DATE_FORMAT = '%y%m%d'
  ALBUM_FOLDER_PATTERN = /^(?<date>\d{6})(?<title>.+)$/
  ALLOWED_EXTS = ImageUploader::EXTENSION_WHITE_LIST.dup
  ALLOWED_EXTS.push(*ALLOWED_EXTS.map(&:upcase))

  def self.perform(glob)
    Dir[glob].each do |album_folder|
      parent_text = File.join(album_folder, 'parent.txt')

      if File.exists?(parent_text)
        parent_slug = File.read(parent_text).strip

        if parent_album = Album.find_by_slug(parent_slug)
          puts "Scanning path #{album_folder}"

          if parent_album.childless?
            puts "Importing into already existing album #{parent_album}"
            ImportAlbum.perform_async(album_folder, parent_album.id)
          else
            match = ALBUM_FOLDER_PATTERN.match(File.basename(album_folder))
            title = match[:title].strip
            date = Date.strptime(match[:date], DATE_FORMAT)
            album = parent_album.children.find_or_create_by(title: title, event_date: date)
            puts "Created album with title: #{title} & event_date: #{date} within #{parent_album}."
            ImportAlbum.perform_async(album_folder, album.id)
          end
        else
          puts "Album with slug: #{parent_slug} does not exist."
        end
      else
        puts "#{parent_text} does not exist."
      end
    end
  end

  class ImportAlbum
    include BaseWorker

    def perform(album_folder, album_id)
      Dir[build_glob_pattern(album_folder)].each do |file|
        ImportImage.perform_async(file, album_id)
      end

      Dir["#{album_folder}/*"].each do |source_folder|
        unless File.file?(source_folder)
          source_name = File.basename(source_folder).gsub(/\s\d+$/, '')

          puts "Scanning source #{source_name}."
          source = Source.find_or_create_by(name: source_name)

          Dir[build_glob_pattern(source_folder)].each do |file|
            ImportImage.perform_async(file, album_id, source.id)
          end
        end
      end
    end

    def build_glob_pattern(source_folder)
      "#{source_folder}/*.{#{FolderImport::ALLOWED_EXTS.join(',')}}"
    end
  end

  class ImportImage
    include BaseWorker

    def perform(image_path, album_id, source_id = nil)
      puts "Adding #{image_path}"
      image = Image.new(
        album_id: album_id,
        image: File.open(image_path)
      )

      if source_id
        source = Source.find(source_id)
        image.sources << source
      end

      image.save
    end
  end
end
