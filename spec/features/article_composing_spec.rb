require 'spec_helper'

feature 'Article composing' do

  given!(:current_user) { create(:user) }

  before do
    login_user(current_user)
  end

  scenario 'Create an article', :js do

    within(main_menubar) { click_link 'Articles' }
    within(action_bar) { click_link 'New Article' }

    within page_body do
      # This will fill visible fields i.e. for the default locale
      fill_in 'Title', with: 'A new article title'
      fill_in 'Body', with: 'Something interesting to say'
      submit_button.click
    end

    page.should have_content 'Article was successfully created.'
    # Retrieve article from database
    article = Article.first
    page.should have_content article.title
    page.should have_content article.body
  end

end