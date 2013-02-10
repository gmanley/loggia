require 'spec_helper'

describe Album do
  it { should have_many(:images) }
  it { should have_many(:comments) }
  it { should have_many(:favorites) }
  it { should have_many(:sources) }
  it { should have_many(:photographers) }
  it { should have_one(:archive)  }

  it { should validate_presence_of(:title) }

  describe 'title uniqueness' do

    let!(:album) { Fabricate(:album, event_date: Date.parse('12.11.30')) }

    subject { album }

    it { should validate_uniqueness_of(:title)
                .scoped_to(:parent_id, :event_date)
                .case_insensitive }

    it 'allows an album with same title & parent_id if event_date differs' do
      Fabricate.build(:album,
        event_date: Date.parse('12.11.19'),
        title: album.title
      ).should be_valid
    end

    it 'allows an album with the same title & event_date if parent_id differs' do
      Fabricate.build(:album,
        event_date: Date.parse('12.11.30'),
        title: album.title,
        parent_id: 999
      ).should be_valid
    end

    it "doesn't allow an album with same title, parent_id & event_date" do
      Fabricate.build(:album,
        event_date: Date.parse('12.11.30'),
        title: album.title
      ).should be_invalid
    end
  end
end
