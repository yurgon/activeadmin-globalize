module ActiveAdmin
  module Globalize
    module FormBuilderExtension
      extend ActiveSupport::Concern

      def translated_inputs(name = 'Translations', options = {}, &block)
        options.symbolize_keys!
        # Extract options
        sort_locales = options.fetch(:auto_sort, true)
        switch_locale = options.fetch(:switch_locale, false)
        # Main block for translated inputs
        template.content_tag(:div, class: 'activeadmin-translations') do
          # Render locale selectors and actual fieldsets with translations
          translation_selector(sort_locales, switch_locale) <<
              translation_fieldsets(sort_locales, switch_locale, &block)
        end
      end

      private

      def translation_selector(sort_locales, switch_locale)
        template.content_tag(:ul, class: 'available-locales') do
          (sort_locales ? I18n.available_locales.sort : I18n.available_locales).map do |locale|
            default = locale == I18n.default_locale ? 'default' : nil
            template.content_tag(:li) do
              I18n.with_locale(switch_locale ? locale : I18n.locale) do
                template.content_tag(:a, I18n.t("active_admin.globalize.language.#{locale}"),
                                     href: ".locale-#{locale}", :class => default)
              end
            end
          end.join.html_safe
        end
      end

      def translation_fieldsets(sort_locales, switch_locale, &block)
        (sort_locales ? I18n.available_locales.sort : I18n.available_locales).map do |locale|
          translation = object.translations.find { |t| t.locale.to_s == locale.to_s }
          translation ||= object.translations.build(locale: locale)
          fields = proc do |form|
            form.input(:locale, as: :hidden)
            form.input(:id, as: :hidden)
            I18n.with_locale(switch_locale ? locale : I18n.locale) do
              block.call(form)
            end
          end
          inputs_for_nested_attributes(
              for: [:translations, translation],
              class: "inputs locale locale-#{translation.locale}",
              &fields
          )
        end.join.html_safe
      end

    end
  end
end

