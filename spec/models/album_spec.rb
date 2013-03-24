require 'spec_helper'

describe Album do
  # NOTE: I have mixed feelings about the necessity of the tests found in the
  # first 3 describe blocks. If nothing else, however, they serve as good
  # documentation.

  describe 'database columns' do
    it { should have_db_column(:description).of_type(:text) }

    it { should have_db_column(:event_date).of_type(:date) }

    it { should have_db_column(:hidden).
                  of_type(:boolean).
                  with_options(default: false) }

    it { should have_db_column(:images_count).
                  of_type(:integer).
                  with_options(default: 0) }

    it { should have_db_column(:slug).
                  of_type(:string).
                  with_options(null: false) }

    it { should have_db_column(:thumbnail_url).
                  of_type(:string).
                  with_options(default: '/assets/placeholder.png') }

    it { should have_db_column(:title).
                  of_type(:string).
                  with_options(null: false) }
  end

  describe 'indexes' do
    it { should have_db_index(:hidden) }
    it { should have_db_index(:images_count) }
    it { should have_db_index(:parent_id) }
    it { should have_db_index(:slug).unique(true) }
  end

  describe 'associations' do
    it { should have_many(:images).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:sources).through(:images) }
    it { should have_one(:archive).dependent(:destroy)  }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }

    describe 'title uniqueness validation' do
      let(:date) { Date.parse('2012-11-30') }
      let(:existing_album) { Fabricate(:album, event_date: date) }

      subject { existing_album }

      it { should validate_uniqueness_of(:title).
                    scoped_to(:parent_id, :event_date).
                    case_insensitive }

      context 'allows two albums to have certain matching attributes' do
        it 'is valid with matching title & parent_id but differing event_date' do
          expect(Fabricate.build(:album,
            event_date: Date.parse('2012-11-19'),
            title: existing_album.title
          )).to be_valid
        end

        it 'is valid with matching title & event_date but differing parent_id' do
          expect(Fabricate.build(:album,
            event_date: date,
            title: existing_album.title,
            parent_id: 999
          )).to be_valid
        end

        it 'is invalid with matching title, parent_id & event_date' do
          expect(Fabricate.build(:album,
            event_date: date,
            title: existing_album.title
          )).to be_invalid
        end
      end
    end
  end

  describe '#formated_event_date' do
    it 'returns the event_date as a string formated "year.month.day"' do
      album = Fabricate.build(:album, event_date: '2012-11-30')
      expect(album.formated_event_date).to eq('2012.11.30')
    end
  end

  describe '#display_name' do
    it 'returns the formated_event_date and title concatenated' do
      album = Fabricate.build(:album,
        event_date: Date.parse('2012-11-30'),
        title: 'Foo'
      )
      expect(album.display_name).to eq("#{album.formated_event_date} Foo")
    end
  end

  describe 'setting of url slug' do
    let(:album) { Fabricate.build(:album, title: 'g') }

    it 'sets a slug after creation' do
      expect { album.save }.to change { album.slug }
    end

    describe '#slug_components' do
      let(:parent) { mock_model('Album', display_name: 'f') }

      it "returns an array of the album's ancestors and itself's display_name" do
        album.stub(parent: parent)
        parent.stub(:self_and_ancestors) do
          %w(f e d c b a).collect { |s| stub(display_name: s) }
        end

        expect(album.slug_components).to eql(%w(a b c d e f g))
      end

      it 'removes any "." from the display names' do
        album.title = 'Wow.'
        expect(album.slug_components).to_not include('.')
      end

      it 'replaces any "/" in the display name with " and "' do
        album.title = 'Mammals/Insects'
        expect(album.slug_components).to eq(['Mammals and Insects'])
      end
    end
  end
end
