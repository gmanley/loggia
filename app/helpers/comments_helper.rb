module CommentsHelper

  def comments_list(comments, commentable)
    haml_tag 'ol#comments-list' do
      haml_concat(render(comments, commentable: commentable))

      if comments.empty?
        haml_tag 'li.comment' do
          haml_tag 'i.muted', 'No Comments'
        end
      end
    end
  end
end
