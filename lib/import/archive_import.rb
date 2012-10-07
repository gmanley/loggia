module Archive
  class InvalidFolderStructure < StandardError; end

  class Import
    IGNORED_ENTRIES = %w(__MACOSX)

    def initialize(zip_path)
      @extraction_location = Pathname(Dir.mktmpdir).join('import')
      extract(zip_path)
      validate_archive # TODO: Validate the format before we extract.
      import_folder
    end

    def extract(zip_path)
      Archive::Zip.extract(zip_path, @extraction_location.to_s)
    end

    def import_folder
      @albums = []
      create_albums
      create_associations
    end

    def create_albums
      @extraction_location.find do |entry|
        next if entry == @extraction_location
        Find.prune if IGNORED_ENTRIES.include?(entry.basename.to_s)

        if entry.directory? # Must be a category or album
          album = Album.create(
            title: entry.basename,
            import_path: clean_path(entry)
          )

          album.import_folder(entry)

          @albums << album
        end
      end
    end

    def create_associations
      @albums.each do |album|
        hierarchy_array = album.import_path.split('/')

        if hierarchy_array.count > 1
          hierarchy_array.delete_at(-1)
          parent_import_path = hierarchy_array.join('/')
          parent = @albums.find { |a| a.import_path == parent_import_path }
          album.parent = parent
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
