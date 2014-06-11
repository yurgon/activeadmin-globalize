require 'spec_helper'

feature 'Article localization features', :js do

  given!(:current_user) { create(:user) }

  before do
    login_user(current_user)
  end

  scenario 'Create an article' do

    within(main_menubar) { click_link 'Articles' }
    within(action_bar) { click_link 'New Article' }

    within page_body do
      # This will fill visible fields i.e. for the default locale
      fill_in 'Title', with: 'A new article title'
      fill_in 'Body', with: 'Something interesting to say'
      submit_button.click
    end

    page.should have_content 'Article was successfully created.'

    # Retrieve created article from database
    article = Article.first
    page.should have_content article.title
    page.should have_content article.body
  end

  context 'Viewing article translations' do

    given!(:article) { create(:localized_article) }

    before do
      # Load article page
      ensure_on(admin_article_path(article))
    end

    # See spec/dummy/app/admin/articles.rb
    scenario 'Viewing a translated article' do

      # First row shows default locale with label title
      within first_table_row do
        page.should have_css 'th', text: 'TITLE'
        page.should have_css 'span.field-translation', text: article.title
      end
      # Second row shows italian title by default
      within second_table_row do
        page.should have_css 'th', text: 'ITALIAN TITLE'
        page.should have_css 'span.field-translation', text: article.translation_for(:it).title
      end

    end

    scenario 'Switch inline translations' do

      # First row shows default locale with label title
      within first_table_row do
        page.should have_css 'th', text: 'TITLE'
        page.should have_css 'span.field-translation', text: article.title
        flag_link(:it).click # change shown translation
        page.should have_css 'span.field-translation', text: article.translation_for(:it).title
      end

    end

  end

end