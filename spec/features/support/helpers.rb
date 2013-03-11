module HelperMethods

  def sign_in(user)
    visit homepage

    within 'form#login' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password

      click_button 'Sign In'
    end
  end
end
