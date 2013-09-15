require 'spec_helper'

describe Image do

  describe '#sources_attributes=' do
    let(:image) { Image.new }
    let(:source) { double(:source) }

    before do
      image.stub(sources: double('sources relation'))
      image.sources.stub(:<<)
    end

    context 'when passed a hash with an id key' do
      before do
        Source.stub(find: source)
        image.sources_attributes = { 1 => { id: 1 } }
      end

      it 'attempts to find a source with that id' do
        expect(Source).to have_received(:find).with(1)
      end

      it 'adds source with that id to the sources association' do
        expect(image.sources).to have_received(:<<).with(source)
      end
    end

    context 'when passed a hash without an id but present name and kind fields' do
      let(:attrs) { { name: 'Foo', kind: 'website' } }

      before do
        Source.stub(find_or_create_by: source)
        image.sources_attributes = { 1 => attrs }
      end

      it 'finds or initializes a source with said fields' do
        expect(Source).to have_received(:find_or_create_by).with(attrs)
      end

      it 'adds new or found source to the sources association' do
        expect(image.sources).to have_received(:<<).with(source)
      end
    end
  end
end
