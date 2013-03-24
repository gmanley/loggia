module AlbumsHelper

  def source_selected_proc
    ->(source) do
      if where_query = @images.where_values.find do |wv|
          wv.is_a?(Hash) && wv[:sources]
         end

        where_query[:sources][:id].include?(source.id.to_s)
      else
        true
      end
    end
  end
end
