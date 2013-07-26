class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to(root_url)
  end

  private
  def paginate(resources)
    requested_page = params[:page].to_i
    resources = resources.page(requested_page)
    not_found if requested_page > resources.total_pages
    resources
  end

  def not_found(message = nil)
    raise ActionController::RoutingError.new(message || 'Not Found')
  end
end
