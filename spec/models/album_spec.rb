require 'spec_helper'

describe Album do
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
          %w(f e d c b a).collect { |s| double(display_name: s) }
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
