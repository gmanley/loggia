require 'spec_helper'

describe Category do
  context 'that exists' do
    let(:category) { Fabricate(:category) }

    it "should be a valid record" do
      category.should be_valid
    end

    it "should have a title" do
      category.title.should be_kind_of(String)
    end

    it "should have a valid url slug" do
      ERB::Util.url_encode(category.slugs.first).should eql(category.slugs.first)
    end
  end
end