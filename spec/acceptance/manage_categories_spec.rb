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
    within('#new_category') do
      fill_in 'Title', with: root_category.title
      fill_in 'Description', with: root_category.description
    end
    click_button 'Create'

    page.should have_content 'Category was successfully created.'
  end

  scenario 'child category' do
    create_root_category(root_category)

    visit homepage

    click_link root_category.title
    within('#new_category') do
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

  background(:each) do
    sign_in admin
    create_root_category(root_category)
  end

  scenario 'root category' do
    visit homepage

    click_link root_category.title

    click_link 'Delete'

    page.should have_content 'Category was successfully destroyed.'
    page.should have_no_content root_category.title
  end

  scenario 'child category' do
    create_child_category(root_category, child_category)

    visit homepage

    click_link root_category.title
    click_link child_category.title

    click_link 'Delete'

    page.should have_content 'Category was successfully destroyed.'

    click_link root_category.title
    page.should have_no_content child_category.title
  end
end

feature 'Admin edits categories' do
  let(:admin) { Fabricate(:admin) }
  let!(:root_category) { Fabricate.build(:category) }
  let!(:edited_root_category) { Fabricate.build(:category) }
  let!(:child_category) { Fabricate.build(:category) }
  let!(:edited_child_category) { Fabricate.build(:category) }

  background(:each) do
    sign_in admin
    create_root_category(root_category)
  end

  scenario 'root category' do

    visit homepage

    click_link root_category.title

    click_link 'Edit'

    within('.edit_category') do
       fill_in 'Title', with: edited_root_category.title
       fill_in 'Description', with: edited_root_category.description
     end
     click_button 'Save'

    page.should have_content 'Category was successfully updated.'
    page.should have_content edited_root_category.title
  end

  scenario 'child category' do
    create_root_category(root_category)
    create_child_category(root_category, child_category)

    visit homepage

    click_link root_category.title
    click_link child_category.title

    click_link 'Edit'

    within('.edit_category') do
       fill_in 'Title', with: edited_child_category.title
       fill_in 'Description', with: edited_child_category.description
     end
     click_button 'Save'

    page.should have_content 'Category was successfully updated.'
    page.should have_content edited_child_category.title
  end
end
