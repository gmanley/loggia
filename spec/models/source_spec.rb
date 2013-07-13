require 'spec_helper'

describe Source do

  describe '.merge!' do
    let(:sources) do
      FabricateMany(:source, 3) { images(count: 5) }
    end

    before do
      Source.merge!(sources.map(&:id))
    end

    it "associates all supplied sources' images with the first source" do
      expect(sources.first.images.reload).to have(15).items
    end

    it "destroys all sources but the first" do
      sources[1..-1].each do |source|
        expect { source.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#name=' do
    it 'strips leading and trailing spaces before setting name' do
      source = Source.new
      source.name = ' foo '
      expect(source.name).to eq('foo')
    end
  end
end
