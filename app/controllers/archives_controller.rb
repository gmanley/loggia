class CommentsController < ApplicationController
  include PolymorphicController
  respond_to :json

  def create
    authorize!(:create, Archive)

    @parent_resource.async_create_archive(current_user)
    render json: {
      message: 'You will receive a download link via email shortly.',
      success: true
    }
  end
end
