require 'acceptance_helper'

feature 'Admin manages albums' do
  let(:admin) { Fabricate(:admin) }
  let(:root_album) { Fabricate.build(:album) }
  let(:child_album) { Fabricate.build(:album) }

  background { sign_in admin }

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

  let!(:root_album) { Fabricate(:album) }

  scenario 'create a child album' do
    visit homepage

    click_link root_album.title
    within('#new_album') do
      fill_in 'Title', with: child_album.title
      fill_in 'Description', with: child_album.description
    end
    click_button 'Create'

    page.should have_content 'Album was successfully created.'
  end


  let!(:root_album) { Fabricate(:album) }
  let(:edited_root_album) { Fabricate.build(:album) }

  scenario 'edit an album' do
    visit homepage

    click_link root_album.title

    click_link 'Edit'

    within('.edit_album') do
       fill_in 'Title', with: edited_root_album.title
       fill_in 'Description', with: edited_root_album.description
     end
     click_button 'Save'

    page.should have_content 'Album was successfully updated.'
    page.should have_content edited_root_album.title
  end


  let!(:album) { Fabricate(:album) }

  scenario 'destroy an album' do
    visit homepage

    click_link root_album.title

    click_button 'Delete'

    page.should have_content 'Album was successfully destroyed.'
    page.should have_no_content root_album.title
  end
end