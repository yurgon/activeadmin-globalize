require 'active_admin/globalize3/filter_empty_translations'

module ActiveAdmin
  module Globalize3
    class Engine < ::Rails::Engine
      initializer "Railsyard precompile hook", group: :assets do |app|
        app.config.assets.precompile += [
          "active_admin/active_admin_globalize3.css",
          "active_admin/active_admin_globalize3.js"
        ]
      end

      initializer "add assets" do
        ActiveAdmin.application.register_stylesheet "active_admin/active_admin_globalize3.css", :media => :screen
        ActiveAdmin.application.register_javascript "active_admin/active_admin_globalize3.js"
      end

      # Register a before_filter in ActionController that will filter out
      # empty translations submitted by activeadmin-globalize3.
      # See ActiveAdmin::Globalize3::FilterEmptyTranslations#filter_empty_translations
      initializer "activeadmin-globalize3.load_helpers" do |app|
        ActionController::Base.send :include, ActiveAdmin::Globalize3::FilterEmptyTranslations
        ActionController::Base.send :before_filter, :filter_empty_translations, only: [:create, :update]
      end

    end
  end
end
