require 'acceptance_helper'

feature 'Admin creates albums' do
  let(:admin) { Fabricate(:admin) }
  let(:album) { Fabricate.build(:album) }
  let(:category) { Fabricate.build(:category) }

  background do
    sign_in admin
    create_root_category(category)
  end

  scenario 'one nested album' do
    visit homepage

    click_link category.title
    within('#new_album') do
      fill_in 'Title', with: album.title
      fill_in 'Description', with: album.description
    end
    click_button 'Create'
  end
end

feature 'Admin destroys album' do
  let(:admin) { Fabricate(:admin) }
  let(:album) { Fabricate.build(:album) }
  let(:category) { Fabricate.build(:category) }

  background(:each) do
    sign_in admin
    create_root_category(category)
  end

  scenario 'one nested album' do
    create_album(category, album)

    visit homepage

    click_link category.title
    click_link album.title

    click_link 'Destroy'

    page.should have_content 'Album was successfully destroyed.'

    click_link category.title
    page.should have_no_content album.title
  end
end

feature 'Admin edits albums' do
  let(:admin) { Fabricate(:admin) }
  let!(:category) { Fabricate.build(:category) }
  let!(:album) { Fabricate.build(:category) }
  let!(:edited_album) { Fabricate.build(:category) }

  background(:each) do
    sign_in admin
    create_root_category(category)
  end

  scenario 'one nested album' do
    create_album(category, album)

    visit homepage

    click_link category.title
    click_link album.title

    click_link 'Edit'

    within('.edit_album') do
       fill_in 'Title', with: edited_album.title
       fill_in 'Description', with: edited_album.description
     end
     click_button 'Save'

    page.should have_content 'Album was successfully updated.'
    page.should have_content edited_album.title
  end
end
