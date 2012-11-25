require 'spec_helper'

describe ApplicationHelper do

  describe '#bootstrap_flash_class' do
    describe 'returning bootstrap eqivalant to rails flash types' do

      ApplicationHelper::BOOTSTRAP_FLASH_CLASS.each do |key, value|
        it %(should return "#{value}" when passed :#{key}) do
          bootstrap_flash_class(key).should eq(value)
        end
      end
    end

    it 'should return original type when no defined bootstrap eqivalant' do
      bootstrap_flash_class(:custom_flash_type).should eq('custom_flash_type')
    end
  end

  describe '#breadcrumbs' do
    context 'when on home page' do
      before do
        should_receive(:current_page?).with('/').and_return(true)
      end

      let(:output) { capture_haml { breadcrumbs } }

      it 'should return nothing' do
        output.should be_empty
      end
    end
  end

  describe '#breadcrumb' do
    context 'when no url is passed or url is the current page' do
      before do
        should_receive(:current_page?).with('/').and_return(true)
      end

      let(:output) { capture_haml { breadcrumb('Home', '/') } }

      it 'should return output with a child list item' do
        output.should have_selector('li.active', text: 'Home')
      end

      it 'should not return output with a seperator' do
        output.should_not have_selector('span.divider', text: '/')
      end
    end

    context "when a url is passed and the url isn't the current page" do
      before do
        should_receive(:current_page?).with('/').and_return(false)
      end

      let(:output) { capture_haml { breadcrumb('Home', '/') } }

      it 'should return output with a link' do
        output.should have_selector('a[href="/"]', text: 'Home')
      end

      it 'should return output with a seperator' do
        output.should have_selector('span.divider', text: '/')
      end
    end
  end
end
