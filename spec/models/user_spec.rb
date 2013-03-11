require 'spec_helper'

describe User do

  context 'that is an admin' do
    let(:admin) { Fabricate(:admin) }

    it 'should return true that they are an admin' do
      expect(admin.admin?).to be_true
    end
  end

  context 'that is not an admin' do
    let(:user) { Fabricate(:confirmed_user) }

    it 'should return false that they are an admin' do
      expect(user.admin?).to be_false
    end
  end
end
