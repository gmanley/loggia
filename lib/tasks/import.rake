if Bundler.definition.groups.include?(:importer) # Check if the importer section of gemfile is uncommented.
  Bundler.require(:importer)
  require File.expand_path('../../ipgallery_import',  __FILE__)

  namespace :import do
    desc "Start an import of a legacy ipgallery install. - Usage: 'rake \"import:ipgallery[upload_directory]\""
    task :ipgallery, [:upload_directory] => :environment do |t, args|
      if args.upload_directory.nil? || !File.directory?(File.expand_path(args.upload_directory, Dir.pwd))
        puts "Please specify a valid upload directory! - Usage: 'rake \"import:ipgallery[upload_directory]\""
      else
        import = IPGallery::Import.new(args.upload_directory)
        import.start
      end
    end
  end
end
