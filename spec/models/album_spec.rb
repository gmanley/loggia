require 'spec_helper'

describe Album do
  it { should have_many(:images) }
  it { should have_many(:comments) }
  it { should have_many(:favorites) }
  it { should have_many(:sources) }
  it { should have_many(:photographers) }
  it { should have_one(:archive)  }

  it { should validate_presence_of(:title) }

  describe 'title uniqueness validation' do

    let!(:existing_album) { Fabricate(:album, event_date: Date.parse('12.11.30')) }

    subject { existing_album }

    it { should validate_uniqueness_of(:title)
                .scoped_to(:parent_id, :event_date)
                .case_insensitive }

    it 'is valid with same title & parent_id if event_date differs' do
      expect(Fabricate.build(:album,
        event_date: Date.parse('12.11.19'),
        title: existing_album.title
      )).to be_valid
    end

    it 'is valid with the same title & event_date if parent_id differs' do
      expect(Fabricate.build(:album,
        event_date: Date.parse('12.11.30'),
        title: existing_album.title,
        parent_id: 999
      )).to be_valid
    end

    it 'is invalid with same title, parent_id & event_date' do
      expect(Fabricate.build(:album,
        event_date: Date.parse('12.11.30'),
        title: existing_album.title
      )).to be_invalid
    end
  end
end
