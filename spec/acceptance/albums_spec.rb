require 'acceptance_helper'

feature 'User comments on albums' do
  let(:user) { Fabricate(:confirmed_user) }
  let!(:album) { Fabricate(:album) }
  let(:comment) { Fabricate.build(:comment) }

  background { sign_in user }

  scenario 'as logged in user' do
    visit homepage

    click_link album.title

    within('#new_comment') do
      fill_in 'comment_body', with: comment.body
    end
    click_button 'Post'

    page.should have_content 'Comment was successfully created.'
    page.should have_content comment.body
  end
end