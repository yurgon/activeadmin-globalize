# Module used inside unit tests to run component testing. Simplified version of the original one
# I only need to render arbre components inside unit tests.
#
# @see https://github.com/activeadmin/activeadmin/blob/master/spec/rails_helper.rb
module ActiveAdminArbreHelper

  def arbre(assigns = {}, helpers = mock_action_view, &block)
    Arbre::Context.new(assigns, helpers, &block)
  end

  def render_arbre_component(assigns = {}, helpers = mock_action_view, &block)
    arbre(assigns, helpers, &block).children.first
  end

  # Returns a fake action view instance to use with our renderers
  def mock_action_view(assigns = {})
    controller = ActionView::TestCase::TestController.new
    ActionView::Base.send :include, ActionView::Helpers
    ActionView::Base.send :include, ActiveAdmin::ViewHelpers
    ActionView::Base.send :include, Rails.application.routes.url_helpers
    ActionView::Base.new(ActionController::Base.view_paths, assigns, controller)
  end
  alias_method :action_view, :mock_action_view

end

# Include module method in examples
RSpec.configure do |config|
  config.include ActiveAdminArbreHelper
end
