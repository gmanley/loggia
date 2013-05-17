module FavoritesHelper

  def favorite_button_for(parent_resource)
    options = { remote: true, class: 'favorite-toggle' }

    if resource = parent_resource.favorite_by(current_user)
      options[:method] = :delete
      image = 'favorited.png'
    else
      options[:method] = :post
      image = 'favorite.png'
      resource = [parent_resource, Favorite]
    end

    link_to(image_tag(image), resource, options)
  end
end
