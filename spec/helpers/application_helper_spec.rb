require 'spec_helper'

describe ApplicationHelper do

  describe '#bootstrap_flash_class' do
    describe 'returning bootstrap eqivalant to rails flash types' do

      ApplicationHelper::BOOTSTRAP_FLASH_CLASS.each do |key, value|
        it %(should return "#{value}" when passed :#{key}) do
          expect(bootstrap_flash_class(key)).to eq(value)
        end
      end
    end

    it 'should return original type when no defined bootstrap eqivalant' do
      expect(bootstrap_flash_class(:custom_flash_type)).to eq('custom_flash_type')
    end
  end

  describe '#breadcrumbs' do
    context 'when on home page' do
      before do
        should_receive(:current_page?).with('/').and_return(true)
      end

      let(:output) { capture_haml { breadcrumbs } }

      it 'should return nothing' do
        expect(output).to be_empty
      end
    end
  end

  describe '#breadcrumb' do
    context 'when no url is passed or url is the current page' do
      before do
        should_receive(:current_page?).with('/').twice.and_return(true)
      end

      let(:output) { capture_haml { breadcrumb('Home', '/') } }

      it 'should return output with a class active' do
        expect(output).to have_selector('li.active')
      end

      it 'should return output with a link' do
        expect(output).to have_selector('a[href="/"]', text: 'Home')
      end

      it 'should not return output with a seperator' do
        expect(output).to_not have_selector('span.divider', text: '/')
      end
    end

    context "when a url is passed and the url isn't the current page" do
      before do
        should_receive(:current_page?).with('/').twice.and_return(false)
      end

      let(:output) { capture_haml { breadcrumb('Home', '/') } }

      it 'should return output with a link' do
        expect(output).to have_selector('a[href="/"]', text: 'Home')
      end

      it 'should return output with a seperator' do
        expect(output).to have_selector('span.divider', text: '/')
      end
    end
  end
end
