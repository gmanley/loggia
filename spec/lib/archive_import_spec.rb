require 'spec_helper'
require Rails.root.join('lib/import/archive_import')

describe Archive::Import, no_database_cleaner: true do

  before(:all) { Archive::Import.new(path_to_fixture('import.zip')) }

  describe 'imported albums' do
    let(:albums) { Album.where(:import_path.exists => true) }
    subject { albums }

    describe 'Category1' do
      subject { albums.where(title: 'Category1').first }

      it { should be_present }

      it 'should have one child' do
        subject.children.should have(1).item
      end

      it 'should have a subcategory titled: Subcategory1' do
        subject.children.where(title: 'Subcategory1').should be_present
      end
    end

    describe 'Category2' do
      subject { albums.where(title: 'Category2').first }

      it { should be_present }

      it 'should have one child' do
        subject.children.should have(1).item
      end

      it 'should have a album titled: Album2' do
        subject.children.where(title: 'Album2').should be_present
      end
    end

    describe 'Album1' do
      subject { albums.where(title: 'Album1').first }

      it { should be_present }

      it 'should have two images' do
        subject.images.should have(2).items
      end

      it 'should belong to the parent titled: Subcategory1' do
        subject.parent.title.should eql('Subcategory1')
      end
    end

    describe 'Album2' do
      subject { albums.where(title: 'Album2').first }

      it { should be_present }

      it 'should have one image' do
        subject.images.should have(1).item
      end

      it 'should belong to the parent titled: Category2' do
        subject.parent.title.should eql('Category2')
      end
    end
  end
end
