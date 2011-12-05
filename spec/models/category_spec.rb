require 'spec_helper'

describe Category do
  it { should reference_many(:albums) }
  it { should reference_many(:child_categories).of_type(Category).as_inverse_of(:parent_category).with_foreign_key(:parent_category_id) }
  it { should be_referenced_in(:parent_category).of_type(Category).as_inverse_of(:child_categories).with_index }

  context 'that is created' do
    before do
      Fabricate(:category)
    end


  end
end
