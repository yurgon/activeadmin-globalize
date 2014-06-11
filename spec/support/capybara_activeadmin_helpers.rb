# @see http://www.elabs.se/blog/51-simple-tricks-to-clean-up-your-capybara-tests
# Helper for layout main elements and utility methods, included in all feature specs
module Capybara
  module ActiveAdminHelpers

    # ensure an user is already on a given path
    # @param [String] path a path to visit
    def ensure_on(path)
      visit(path) unless current_path == path
    end

    # Ensure user is on dashboard
    def visit_dashboard
      ensure_on(root_path)
    end

    def logout_button
      main_menubar.find('#utility_nav a')
    end

    # Return model row in the index view for a given instance
    def model_row(model)
      find("tr##{model.class.model_name.underscore}_#{model.id}")
    end

    def main_menubar
      find('#header')
    end

    # Return AA action bar, i.e. where reside action buttons
    def action_bar
      find('#titlebar_right')
    end

    # Return active admin page body
    def page_body
      find '#active_admin_content'
    end

    # Return a localized subform for editing with globalize
    def localized_form(locale = I18n.default_locale)
      find "fieldset.inputs.locale.locale-#{locale}"
    end

    # Return the container for flash messages
    def flash_messages
      find('.flashes')
    end

    def sidebar
      find '#sidebar'
    end

    def submit_button
      find 'input[type="submit"]'
    end

    # Method used to login a specific user
    def login_user(user, password = 'password')
      @current_admin_user = user
      ensure_on new_admin_user_session_path
      fill_login_form(user.email, password)
      page.should have_content 'Signed in successfully.'
      main_menubar.should have_link(user.email, href: admin_admin_user_path(user))
    end

    # Used to find and submit login form
    def fill_login_form(email, password = 'password')
      within '#login' do
        fill_in 'Email', with: email
        fill_in 'Password', with: password
        click_button 'Login'
      end
    end

    # Helper method to get current logged in user, checking its email in the ui
    def current_admin_user
      @current_admin_user ||= AdminUser.find(find('#current_user a')[:href].split('/').last)
    end
  end

end

