CarrierWave.configure do |config|
# Example settings for s3/cloudfront
#   config.fog_credentials = {
#     :provider               => 'AWS',
#     :aws_access_key_id      => 'xxx',
#     :aws_secret_access_key  => "yyy",
#     :region                 => 'us-west-1'
#   }
#   config.fog_directory  = 'uploads'
#   config.fog_host = 'http://cdn.example.com'
  config.storage :file # Can also be overwritten in uploaders
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
Mongoid::Document::ClassMethods.send(:include, ::CarrierWave::Backgrounder::ORM::Base)
