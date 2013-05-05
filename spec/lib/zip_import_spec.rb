require 'spec_helper'
require 'zip_archive'
require 'import/zip_import'

describe Zip::Import, no_database_cleaner: true do

  before(:all) { Zip::Import.new(path_to_fixture('import.zip')) }
  after(:all)  { DatabaseCleaner.clean_with(:truncation) }

  describe 'imported albums' do
    let(:albums) { Album.all }
    subject { albums }

    describe 'Category1' do
      subject { albums.where(title: 'Category1').first }

      it { should be_present }

      it 'should have one child' do
        expect(subject.children).to have(1).item
      end

      it 'should have a subcategory titled: Subcategory1' do
        expect(subject.children.where(title: 'Subcategory1')).to be_present
      end
    end

    describe 'Category2' do
      subject { albums.where(title: 'Category2').first }

      it { should be_present }

      it 'should have one child' do
        expect(subject.children).to have(1).item
      end

      it 'should have a album titled: Album2' do
        expect(subject.children.where(title: 'Album2')).to be_present
      end
    end

    describe 'Album1' do
      subject { albums.where(title: 'Album1').first }

      it { should be_present }

      it 'should have two images' do
        expect(subject.images).to have(2).items
      end

      it 'should belong to the parent titled: Subcategory1' do
        expect(subject.parent.title).to eql('Subcategory1')
      end
    end

    describe 'Album2' do
      subject { albums.where(title: 'Album2').first }

      it { should be_present }

      it 'should have one image' do
        expect(subject.images).to have(1).item
      end

      it 'should belong to the parent titled: Category2' do
        expect(subject.parent.title).to eql('Category2')
      end
    end
  end
end
