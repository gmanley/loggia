module CommentsHelper

  def comments_list_for(resource)
    haml_tag 'ol.unstyled#comments-list' do
      haml_concat(render(partial: resource.comments, cache: true))

      if resource.comments.empty?
        haml_tag 'li' do
          haml_tag 'i.muted', 'No Comments'
        end
      end
    end
  end
end
