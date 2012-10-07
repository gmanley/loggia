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
end
