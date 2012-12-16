module AlbumsHelper

  def recursive_button
    classes = %(btn btn-primary btn-small)
    classes << ' active' if params['recursive']
    haml_tag 'button#toggle-recursive', 'Recursive',
              data: {toggle: 'button'}, class: classes
  end
end
