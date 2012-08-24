def FabricateMany(count, name, overrides={}, &block)
  count.times.collect do
    Fabricate(name, overrides, &block)
  end
end

# A simple helper for mocking an array of
# models (usually for the index action).
def mock_models(count, string_or_model_class)
  count.times.collect do
    mock_model(string_or_model_class)
  end
end

def path_to_fixture(fixture)
  File.expand_path("../fixtures/#{fixture}", __FILE__)
end