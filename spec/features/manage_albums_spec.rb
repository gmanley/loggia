require 'acceptance_helper'

feature 'Admin manages albums' do
  let(:admin) { Fabricate(:admin) }
  background { sign_in admin }


  let(:root_album) { Fabricate.build(:album) }
  let(:child_album) { Fabricate.build(:album) }

  scenario 'create a root album' do
    visit homepage

    click_link 'New Album'
    within('#new_album') do
      fill_in 'Title', with: root_album.title
      fill_in 'Description', with: root_album.description
    end
    click_button 'Create'

    page.should have_content 'Album was successfully created.'
  end

  scenario 'create a child album' do
    root_album = Fabricate(:album)
    visit homepage

    click_link root_album.title
    within('#new_album') do
      fill_in 'Title', with: child_album.title
      fill_in 'Description', with: child_album.description
    end
    click_button 'Create'

    page.should have_content 'Album was successfully created.'
  end


  let(:edited_album) { Fabricate.build(:album) }

  scenario 'edit an album' do
    album = Fabricate(:album)
    visit homepage

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

  scenario 'destroy an album' do
    album = Fabricate(:album)
    visit homepage

    click_link album.title

    click_link 'Delete'

    page.should have_content 'Album was successfully destroyed.'
    page.should have_no_content album.title
  end
end
