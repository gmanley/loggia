def FabricateMany(name, count, overrides={}, &block)
  count.times.collect do
    Fabricate(name, overrides, &block)
  end
end

# A simple helper for mocking an array of models (ie. the index action).
def mock_models(model_class, count)
  Kaminari.paginate_array(count.times.map { mock_model(model_class) })
end

def path_to_fixture(fixture)
  File.expand_path("../fixtures/#{fixture}", __FILE__)
end
