# encoding: utf-8

module CarrierWave
  module Uploader
    module Url
      def url(options = {})
        if file.respond_to?(:url) and not file.url.blank?
          (file.method(:url).arity == 0 ? file.url : file.url(options)).force_encoding("UTF-8")
        elsif current_path
          (base_path || "") + File.expand_path(current_path).gsub(File.expand_path(root), '').force_encoding("UTF-8")
        end
      end
    end # Url
  end # Uploader
end # CarrierWave
