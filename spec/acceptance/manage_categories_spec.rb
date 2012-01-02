require 'acceptance_helper'

feature 'Admin creates categories' do
  let(:admin) { Fabricate(:admin) }
  let(:root_category) { Fabricate.build(:category) }
  let(:child_category) { Fabricate.build(:category) }

  background do
    sign_in admin
  end

  scenario 'root category' do

    visit homepage

    click_link 'New Category'
    within('form#new_category') do
      fill_in 'Title', with: root_category.title
      fill_in 'Description', with: root_category.description
    end
    click_button 'Save'

    page.should have_content 'Category was successfully created.'
  end

  scenario 'child category' do
    create_root_category(root_category)

    visit homepage

    click_link root_category.title
    within('form#new_category') do
      fill_in 'Title', with: child_category.title
      fill_in 'Description', with: child_category.description
    end
    click_button 'Create'
  end
end


feature 'Admin destroys categories' do
  let(:admin) { Fabricate(:admin) }
  let(:root_category) { Fabricate.build(:category) }
  let(:child_category) { Fabricate.build(:category) }

  background do
    sign_in admin
  end

  scenario 'root category' do
    create_root_category(root_category)

    visit homepage

    click_link root_category.title

    click_link 'Destroy'

    page.should have_content 'Category was succesfully destroyed.'
  end

  scenario 'child category' do
    create_child_category(root_category, child_category)

    visit homepage

    click_link root_category.title

    click_link 'Destroy'

    page.should have_content 'Category was succesfully destroyed.'
  end
end