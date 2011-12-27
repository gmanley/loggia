module HelperMethods

  # Put helper methods you need to be available in all tests here.
  def sign_in(user)
    # Make sure there isn't a user currently logged in
    reset_sessions!

    visit home_page

    within "form#login" do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_button "Sign in"
    end
  end
end

RSpec.configuration.include HelperMethods, type: :acceptance