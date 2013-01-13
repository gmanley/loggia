module CommentsHelper

  def comments_list(comments)
    haml_tag 'ol.unstyled#comments-list' do
      haml_concat(render(partial: comments, cache: true))

      if comments.empty?
        haml_tag 'li' do
          haml_tag 'i.muted', 'No Comments'
        end
      end
    end
  end
end
