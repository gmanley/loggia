require 'acceptance_helper'

feature 'User signing in and out' do
  given(:user) { Fabricate(:confirmed_user) }

  background { visit homepage }

  scenario 'signing in with invalid credentials' do
    within 'form#login' do
      fill_in 'user_email', with: 'invalid@email.com'
      fill_in 'user_password', with: 'wrong'

      click_button 'Sign In'
    end

    expect(page).to have_content 'Invalid email or password'
  end

  scenario 'signing in with valid credentials' do
    within 'form#login' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password

      click_button 'Sign In'
    end

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'signing out' do
    sign_in user
    click_link 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end
