require 'active_admin/view_helpers'

module ActiveAdmin
  module ViewHelpers
    module FlagHelper

      # Return an image tag with background of given locale
      def flag_icon(locale)
        image_tag('active_admin/transparent.gif', class: "flag flag-#{locale}")
      end

    end

    # Register as ActiveAdmin view helper
    include FlagHelper
  end
end
