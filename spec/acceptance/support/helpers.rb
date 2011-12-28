module HelperMethods

  # Put helper methods you need to be available in all tests here.
  def sign_in(user)
    visit homepage

    within "form#login" do
      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password

      click_button "Sign in"
    end
  end
end

RSpec.configuration.include(HelperMethods, type: :request)
RSpec.configuration.include(HelperMethods, type: :acceptance)