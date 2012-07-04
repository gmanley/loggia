object @category
extends 'containers/_container'
node(:categories) do |category|
  partial('containers/_container', object: @children.categories)
end
node(:albums) do |category|
  partial('containers/_container', object: @children.albums)
end