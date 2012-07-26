class CommentsController < ApplicationController
  respond_to :html, :json, :js
  before_filter :set_parent_resource

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    authorize!(:create, @comment)

    @parent_resource.comments << @comment
    respond_with(@comment, location: @parent_resource)
  end

  def update
    @comment = @parent_resource.comments.find(params[:id])
    authorize!(:update, @comment)

    @comment.update_attributes(params[:comment])
    respond_with(@comment, location: @parent_resource)
  end

  def destroy
    @comment = @parent_resource.comments.find(params[:id])
    authorize!(:destroy, @comment)

    @comment.destroy
    respond_with(@comment, location: @parent_resource)
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