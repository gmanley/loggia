module PolymorphicController
  extend ActiveSupport::Concern

  included do
    before_filter :set_parent_resource, only: :create

    attr_reader :parent_resource
  end

  private
  def set_parent_resource
    params.keys.grep(/(.+)_id$/) do |parent_resource_id_key|
      parent_resource_id = params[parent_resource_id_key]
      parent_resource_class = $1.classify.constantize
      @parent_resource = parent_resource_class.find_by_slug!(parent_resource_id)
    end
  end
end
