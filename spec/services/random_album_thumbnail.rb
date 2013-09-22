require 'spec_helper'

describe RandomAlbumThumbnail do

  subject(:service) { RandomAlbumThumbnail.new(double(:album)) }

  describe '#perform' do
    context 'album has no images' do
      before do
        service.stub(images: [])
      end

      context 'album has no descendants with images' do
        before do
          service.stub(descendants_with_images: [])
        end

        it 'returns nil' do
          expect(service.perform).to be_nil
        end
      end

      context 'album has descendants with images' do
        let(:random_record) do
          double(:random_record,
            thumbnail_url: 'http://example.com/foo.png'
          )
        end

        before do
          service.stub(descendants_with_images: [:album1])
          service.stub(random_record: random_record)
        end

        it 'returns the thumbnail_url from a random descendant' do
          expect(service.perform).to eql('http://example.com/foo.png')
        end
      end
    end

    context 'album has images' do
      let(:random_record) do
        double(:random_record,
          image_url: 'http://example.com/foo.png'
        )
      end

      before do
        service.stub(images: [:image1])
        service.stub(random_record: random_record)
      end

      it 'returns the image_url from a random image' do
        expect(service.perform).to eql('http://example.com/foo.png')
      end
    end
  end
end
