class ApplicationResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  protected
  def api_behavior(error)
    raise error unless resourceful?

    if get?
      display resource
    elsif post?
      display resource, status: :created, location: api_location
    else
      # The default behavior is to return a head response with no body.
      display resource, status: 200
    end
  end

  def json_resource_errors
    { errors: resource.errors.full_messages.to_sentence }
  end
end
