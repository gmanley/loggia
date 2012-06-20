object @category
extends 'containers/_container'
node(:children) do |category|
  partial('containers/_container', object: category.children)
end