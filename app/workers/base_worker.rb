module BaseWorker
  extend ActiveSupport::Concern

  included do
    include Sidekiq::Worker
  end

  module ClassMethods
    def method_added(method_name)
      if method_name == :perform && !@with_connection_pool
        with_connection_pool method_name
      end
    end

    def with_connection_pool(method)
      old_method = instance_method(method)
      @with_connection_pool = true
      define_method method do |*args|
        ActiveRecord::Base.connection_pool.with_connection do
          old_method.bind(self).call(*args)
        end
      end
    end
  end
end

