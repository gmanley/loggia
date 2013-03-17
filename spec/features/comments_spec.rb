require 'acceptance_helper'

feature 'Commenting on albums' do
  given(:user)    { Fabricate(:confirmed_user) }
  given!(:album)  { Fabricate(:album) }
  given(:comment) { Fabricate.build(:comment) }

  background { sign_in user }

  scenario 'commenting while logged in' do
    visit homepage
    click_link album.title

    within('#new_comment') do
      fill_in 'comment_body', with: comment.body
    end
    click_button 'Post'

    expect(page).to have_content 'Comment was successfully created.'
    expect(page).to have_content comment.body
  end
end
