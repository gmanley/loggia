require 'spec_helper'

describe Album do
  context 'that exists' do
    let(:album) { Fabricate(:album) }

    it "should be a valid record" do
      album.should be_valid
    end

    it "should have a title" do
      album.title.should be_kind_of(String)
    end

    it "should have a valid url slug" do
      ERB::Util.url_encode(album.slug).should eql(album.slug)
    end
  end

  describe '#ancestry_path with unpersisted album' do
    let(:album) { Fabricate.build(:album) }

    before do
      parent = double('Album')
      parent.stub(:ancestry_path) { %w(Album1 Album2) }
      album.should_receive(:parent).and_return(parent)
    end

    it 'should return an array of ancestors titles its title' do
      album.ancestry_path.should eql(['Album1', 'Album2', album.title])
    end
  end
end
