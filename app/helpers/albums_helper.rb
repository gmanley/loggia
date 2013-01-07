module AlbumsHelper

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
