require 'active_admin/views/components/attributes_table.rb'

module ActiveAdmin
  module Views

    # Provide additional method #translated_row to attribute table
    class AttributesTable < ActiveAdmin::Component

      # Show a row with their translations and selectors for choosing locale to show.
      #
      # If a block is given it will be used to format the translation,
      # otherwise field taken from translation object is used as translation.
      #
      # Additional options are forwarded to the original row call.
      #
      # @overload translated_row(field, opts)
      #   @param [String] field row label, also used as field name if none given in options
      #   @param [Hash] opts the options to create a message with.
      #     @option opts [String] :field field to retrieve from model if different from first argument of args
      #     @option opts [String] :locale (I18n.locale) initial locale to show in the ui
      #     @option opts [Boolean] :inline (true) if true locale selectors (and values) are shown inline,
      #                                              otherwise as block content and tabs
      #
      # @yield if given will be used to build single translations
      # @yieldparam [*::Translation] Globalize translation model
      # @yieldreturn [String] content to show as translation
      #
      # @example Show inlined translation values for title field
      #   show do |p|
      #     attributes_table do
      #       translated_row(:title)
      #     end
      #  end
      #
      # @example Show block translation for body field with selection of initial locale
      #   show do |p|
      #     attributes_table do
      #       translated_row(:body, inline: false, locale: :es)
      #     end
      #  end
      #
      def translated_row(*args, &block)
        options = args.extract_options!
        options.reverse_merge!(inline: true, locale: I18n.locale)
        field = options[:field] || args.first
        raise ArgumentError, "Field '#{field}' is not translatable" unless translatable?(field)
        # Remove my options from passed options
        row_options = options.symbolize_keys.except(:field, :locale, :inline)
        # Append remaining options to original args
        args.push(row_options) unless row_options.empty?
        # Render the table row with translations
        row(*args) do
          ''.html_safe.tap do |value|
            # Add selectors for inline locale
            value << inline_locale_selectors if options[:inline]
            # Build translations spans
            value << field_translations(field, options[:locale], &block)
          end
        end
      end

      private

      # @return [Boolean] true iff the field is translatable
      def translatable?(field)
        @record.class.translates? &&
            @record.class.translated_attribute_names.include?(field.to_sym)
      end

      # Build a span for each field translation
      def field_translations(field, initial_locale)
        @record.translations.map do |translation|
          # Classes for translation span only first element is visible
          css_classes = ["#{translation.locale}-field", 'field-translation']
          # Initially only element for selected locale is visible
          css_classes.push 'hidden' unless translation.locale == initial_locale.to_sym
          # build span with translation
          content_tag(:span, class: css_classes) do
            # If block given call it with translation model, else return raw value of field
            block_given? ? yield(translation) : translation.send(field)
          end
        end.join(' ').html_safe
      end

      # Return flag elements to show the given locale using javascript
      def inline_locale_selectors
        content_tag(:span, class: 'inline-locale-selector') do
          @record.translations.map do |translation|
            # Build a link to show the given translation
            link_to(flag_icon(translation.locale), '#', class: 'ui-translation-trigger', data: {locale: translation.locale})
          end.join(' ').html_safe
        end
      end

    end
  end
end
