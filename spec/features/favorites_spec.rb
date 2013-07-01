require 'acceptance_helper'

feature 'Favoriting albums', js: true, no_database_cleaner: true do
  given(:user)    { Fabricate(:confirmed_user) }
  given!(:album)  { Fabricate(:album) }

  background { sign_in user }

  scenario 'adding an album as a favorite while logged in' do
    visit homepage
    click_link album.title

    favorite_link = find('a.favorite-toggle')
    favorite_link.click

    expect(favorite_link).to have_css('img[src="/assets/favorited.png"]')
  end

  scenario 'removing an album as a favorite while logged in' do
    visit homepage
    click_link album.title

    favorite_link = find('a.favorite-toggle')
    favorite_link.click

    expect(favorite_link).to have_css('img[src="/assets/favorite.png"]')
  end
end
