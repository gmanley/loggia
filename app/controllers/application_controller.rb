class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :set_layout

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  private
  def set_layout
    if request.headers['X-PJAX']
      false
    else
      "application"
    end
  end
end
