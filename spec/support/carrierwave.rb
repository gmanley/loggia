class CarrierwaveTesting < ::Rails::Railtie

  config.after_initialize do
    CarrierWave.configure do |config|
      config.storage = :file
      config.enable_processing = false
    end

    CarrierWave::Uploader::Base.descendants.each do |klass|
      next if klass.anonymous?

      klass.class_eval do
        def cache_dir
          "#{Dir.tmpdir}/uploads/tmp"
        end

        def store_dir
          "#{Dir.tmpdir}/uploads"
        end
      end
    end
  end
end
