require 'carrierwave/processing/mini_magick'
CarrierWave.configure do |config|
# Example settings for s3/cloudfront
#   config.storage = :fog
#   config.fog_credentials = {
#     :provider               => 'AWS',
#     :aws_access_key_id      => 'xxx',
#     :aws_secret_access_key  => "yyy",
#   }
#   config.fog_directory  = 'bucket_name'
#   config.fog_host = 'http://cdn.example.com'
#   config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
  config.storage :file # Can be overridden in uploaders
end
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
MiniMagick.processor = :gm