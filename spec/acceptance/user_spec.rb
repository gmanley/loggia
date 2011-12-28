require 'acceptance_helper'

feature "User that is logged in" do
  let(:user) { Fabricate(:confirmed_user) }

  background do
    visit homepage
    sign_in user
  end

  scenario "logs out" do
    click_link "Logout"

    page.should have_content "Signed out successfully."
  end
end