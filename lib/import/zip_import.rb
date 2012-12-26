module Zip
  class InvalidFolderStructure < StandardError; end

  class Import
    IGNORED_ENTRIES = %w(__MACOSX)
    attr_reader :albums

    def initialize(zip_path)
      @extraction_location = Pathname(Dir.mktmpdir).join('import')
      extract(zip_path)
      validate_archive # TODO: Validate the format before we extract.
      import_folder
    end

    def extract(zip_path)
      Zip::Archive.open(zip_path) do |ar|
        ar.each do |entry|
          next if entry.directory?
          entry_path = @extraction_location.join(entry.name).to_s
          dirname = ::File.dirname(entry_path)
          FileUtils.mkdir_p(dirname) unless ::File.exist?(dirname)
          open(entry_path, 'wb') { |f| f << entry.read }
        end
      end
    end

    def import_folder
      @albums = {}
      create_albums
      create_associations
    end

    def create_albums
      @extraction_location.find do |entry|
        next if entry.to_s == @extraction_location.to_s
        Find.prune if IGNORED_ENTRIES.include?(entry.basename.to_s)

        if entry.directory? # Must be a category or album
          album = Album.create(title: entry.basename.to_s)
          album.import_folder(entry)

          @albums[clean_path(entry)] = album
        end
      end
    end

    def create_associations
      @albums.each do |import_path, album|
        hierarchy_array = import_path.split('/')

        if hierarchy_array.count > 1
          hierarchy_array.delete_at(-1)
          parent_import_path = hierarchy_array.join('/')
          album.parent = @albums[parent_import_path]
          album.save
        end
      end
    end

    def validate_archive
      unless @extraction_location.exist?
        raise InvalidFolderStructure, 'Please ensure your archive contains a top level folder called "import".'
      end
    end

    def clean_path(path)
      path.to_s.gsub("#{@extraction_location}/", '')
    end
  end
end
