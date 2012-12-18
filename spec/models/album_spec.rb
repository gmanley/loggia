require 'spec_helper'

describe Album do
  describe 'title & date uniqueness validation' do

    describe 'album with same title & parent' do

      let!(:album) { Fabricate(:album, event_date: Date.parse('12.11.30')) }

      it 'should be valid when event_date differs' do
        Fabricate.build(:album,
          event_date: Date.parse('12.11.19'),
          title: album.title
        ).should be_valid
      end

      it 'should be invalid when event_date is the same' do
        Fabricate.build(:album,
          event_date: Date.parse('12.11.30'),
          title: album.title
        ).should be_invalid
      end
    end
  end
end
