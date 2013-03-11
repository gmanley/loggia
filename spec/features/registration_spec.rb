require 'acceptance_helper'

feature 'Registering an account' do
  given(:user) { Fabricate.build(:user) }

  background { visit homepage }

  scenario 'with valid information' do
    click_link 'Sign Up'

    within('form#new_user') do
      fill_in 'user_email',                 with: user.email
      fill_in 'user_password',              with: user.password
      fill_in 'user_password_confirmation', with: user.password

      click_button 'Sign Up'
    end

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please open the link to activate your account.'
  end
end
