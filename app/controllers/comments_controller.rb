class CommentsController < ApplicationController
  include PolymorphicController
  respond_to :html, :json, :js

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    authorize!(:create, @comment)

    @parent_resource.comments << @comment
    respond_with(@comment, location: @parent_resource)
  end

  def update
    @comment = @parent_resource.comments.find(params[:id])
    authorize!(:update, @comment)

    @comment.update_attributes(comment_params)
    respond_with(@comment, location: @parent_resource)
  end

  def destroy
    @comment = @parent_resource.comments.find(params[:id])
    authorize!(:destroy, @comment)

    @comment.destroy
    respond_with(@comment, location: @parent_resource)
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
