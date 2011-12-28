require 'acceptance_helper'

feature 'Admin creates a category' do
  let(:admin) { Fabricate(:admin) }
  let(:category) { Fabricate(:category) }

  background do
    visit homepage
    sign_in admin
  end

  scenario 'that is a top level parent' do
    visit homepage

    click_link 'New Category'
    within('form#new_category') do
      fill_in 'Title', with: category.title
      fill_in 'Description', with: category.description
    end
    click_button 'Save'

    page.should have_content 'Category was successfully created.'
  end
end