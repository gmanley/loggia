module AlbumsHelper

  def filter_sidebar_toggle
    classes = %(btn btn-inverse pull-right)
    haml_tag 'button#toggle-filter-sidebar', 'Filter By Source',
              data: { toggle: 'collapse', target: '#filter_album_images'},
              class: classes
  end

  def source_selected_proc
    ->(source) do
      if where_query = @images.where_values_hash['source_id']
        where_query.include?(source.id.to_s)
      else
        true
      end
    end
  end
end
