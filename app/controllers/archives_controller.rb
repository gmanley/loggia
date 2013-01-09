class ArchivesController < ApplicationController
  include PolymorphicController
  respond_to :js

  def create
    authorize!(:create, Archive)

    @parent_resource.async_create_archive(current_user.id)
  end
end
