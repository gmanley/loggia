# encoding: UTF-8
require 'acceptance_helper'

feature 'Managing comments' do
  given(:user)    { Fabricate(:confirmed_user) }
  given(:admin)   { Fabricate(:admin) }
  given!(:comment) { Fabricate(:album_comment, user: user) }

  background { sign_in(admin) }

  scenario 'user deleting their comment', js: true, no_database_cleaner: true do
    visit homepage
    click_link comment.commentable.title

    comment_el = find("#comment_#{comment.id}")
    comment_el.click_link('×')

    expect(page).to_not have_content comment.body
  end
end
