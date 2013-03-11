require 'acceptance_helper'

feature 'Managing albums' do
  given(:admin)       { Fabricate(:admin) }
  given(:root_album)  { Fabricate.build(:album) }
  given(:child_album) { Fabricate.build(:album) }

  background { sign_in admin }

  scenario 'create a root album' do
    visit homepage

    click_link 'New Album'
    within('#new_album') do
      fill_in 'Title', with: root_album.title
      fill_in 'Description', with: root_album.description
    end
    click_button 'Create'

    expect(page).to have_content 'Album was successfully created.'
  end

  scenario 'create a child album' do
    root_album.save
    visit homepage

    click_link root_album.title
    within('#new_album') do
      fill_in 'Title', with: child_album.title
      fill_in 'Description', with: child_album.description
    end
    click_button 'Create'

    expect(page).to have_content 'Album was successfully created.'
  end

  given(:edited_album) { Fabricate.build(:album) }

  scenario 'edit an album' do
    root_album.save
    visit homepage

    click_link root_album.title

    click_link 'Edit'

    within('.edit_album') do
      fill_in 'Title', with: edited_album.title
      fill_in 'Description', with: edited_album.description
    end

    click_button 'Save'

    expect(page).to have_content 'Album was successfully updated.'
    expect(page).to have_content edited_album.title
  end

  scenario 'destroy an album' do
    root_album.save
    visit homepage

    click_link root_album.title

    click_link 'Delete'

    expect(page).to have_content 'Album was successfully destroyed.'
    expect(page).to have_no_content root_album.title
  end
end
