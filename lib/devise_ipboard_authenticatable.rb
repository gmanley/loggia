require 'devise/strategies/authenticatable'
require 'digest/md5'
require 'uri'
require 'open-uri'

module DeviseIpboardAuthenticatable end

module Devise
  module Models
    module IpboardAuthenticatable
      extend ActiveSupport::Concern

      module ClassMethods
        Devise::Models.config(self, :ipboard_authentication_url)
      end
    end
  end
end

module Devise
  module Strategies
    class Ipboard < Authenticatable
      HTML_ENTITY_MAP = {'!' => '&#33;', '$' => '&#036;', '\\' => '&#092;', "'" => '&#39;'}

      attr_accessor :response

      def authenticate!
        if self.response = query_ipboard
          if resource = find_resource
            update_resource(resource)
          else
            create_resource
          end

          success!(resource)
        else
          fail!('Unable to authenticate with Ipboard')
        end
      end

      def valid?
        valid_for_params_auth?
      end

      private
      def attributes_from_response
        {
          ipb_user_id: response['member_id'],
          username: response['name'],
          email: response['email'],
          display_name: response['members_display_name']
        }
      end

      def find_resource
        mapping.to.find_for_authentication(
          attributes_from_response.slice(:ipb_user_id)
        )
      end

      def update_resource(resource)
        resource.update_attributes(attributes_from_response)
      end

      def create_resource
        mapping.to.create(attributes_from_response)
      end

      def query_hash
        {
          username: params_auth_hash[:username],
          password: prepare_password(params_auth_hash[:password])
        }
      end

      def query_ipboard
        request_uri = URI.parse(mapping.to.ipboard_authentication_url)
        request_uri.query = query_hash.to_params
        JSON.parse(request_uri.read)
      rescue JSON::ParserError
        false
      end

      def prepare_password(password)
        password.gsub!(Regexp.union(HTML_ENTITY_MAP.keys), HTML_ENTITY_MAP)
        Digest::MD5.hexdigest(password)
      end
    end
  end
end

Warden::Strategies.add(:ipboard_authenticatable, Devise::Strategies::Ipboard)
