def FabricateMany(count, name, overrides={}, &block)
  count.times.collect do
    Fabricate(name, overrides, &block)
  end
end