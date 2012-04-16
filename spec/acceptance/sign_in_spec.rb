require 'acceptance_helper'

feature "User signs in" do
  let(:user) { Fabricate(:confirmed_user) }
  let(:form) { find("form#login") }

  background do
    visit homepage
  end

  scenario "with invalid credentials" do
    form.fill_in "user_email", with: "invalid@email.com"
    form.fill_in "user_password", with: "wrong"

    click_button "Sign In"

    page.should have_content "Invalid email or password"
  end

  scenario "with valid credentials" do
    form.fill_in "user_email", with: user.email
    form.fill_in "user_password", with: user.password

    click_button "Sign In"

    page.should have_content 'Signed in successfully.'
  end
end