object @album
extends 'containers/_container'
node(:images) do |album|
  partial('images/_image', object: album.images)
end