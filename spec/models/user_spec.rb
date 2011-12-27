require 'spec_helper'

describe User do

  context 'that is an admin' do
    let(:admin) { Fabricate(:admin) }

    it 'should return true that they are an admin' do
      admin.admin?.should be_true
    end
  end

  context 'that is not an admin' do
    let(:user) { Fabricate(:confirmed_user) }

    it 'should return false that they are an admin' do
      user.admin?.should be_false
    end
  end
end
