module HelperMethods

  # Put helper methods you need to be available in all tests here.
  def sign_in(user)
    visit homepage

    within "form#login" do
      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password

      click_button "Sign in"
    end
  end

  def create_album(category, album)
    create_root_category(category)

    visit homepage

    click_link category.title
    within('form#new_album') do
      fill_in 'Title', with: album.title
      fill_in 'Description', with: album.description
      click_button 'Create'
    end
  end

  def create_root_category(root_category)
    visit homepage

    click_link 'New Category'
    within('form#new_category') do
      fill_in 'Title', with: root_category.title
      fill_in 'Description', with: root_category.description
      click_button 'Create'
    end
  end


  def create_child_category(root_category, child_category)
    create_root_category(root_category)

    visit homepage

    click_link root_category.title
    within('form#new_category') do
      fill_in 'Title', with: child_category.title
      fill_in 'Description', with: child_category.description
      click_button 'Create'
    end
  end
end

RSpec.configuration.include(HelperMethods, type: :request)
RSpec.configuration.include(HelperMethods, type: :acceptance)