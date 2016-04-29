require 'spec_helper'

# Setup and expectations taken from ActiveAdmin::FormBuilder unit tests
describe ActiveAdmin::Globalize::FormBuilderExtension do

  # Setup an ActionView::Base object which can be used for
  # generating the form for.
  let(:helpers) do
    view = action_view

    def view.articles_path
      '/articles'
    end

    def view.protect_against_forgery?
      false
    end

    def view.url_for(*args)
      if args.first == {action: 'index'}
        articles_path
      else
        super
      end
    end

    view
  end

  def build_form(options = {}, form_object = Article.new, &block)
    options = {url: helpers.articles_path}.merge(options)

    form = render_arbre_component({form_object: form_object, form_options: options, form_block: block}, helpers) do
      active_admin_form_for(assigns[:form_object], assigns[:form_options], &assigns[:form_block])
    end.to_s

    Capybara.string(form)
  end


  describe 'Simple form instantiation', :focus do

    let(:legend_text) { 'Article details' }
    let(:record) { Article.new }

    # Still using the wrong syntax to write some passing unit tests
    let :body do
      # this is needed because of instance_eval in arbre
      main_label = legend_text
      # Form output will be available as capybara string
      build_form({}, record) do |f|
        f.translated_inputs main_label do |t|
          t.input :title
          t.input :body
        end
      end
    end

    it 'generates a fieldset with a inputs class' do
      expect(body).to have_selector('fieldset.inputs')
    end

    it 'use the given legend' do
      expect(body).to have_css 'legend', text: legend_text
    end

    it 'renders main body of translation input' do
      expect(body).to have_css 'fieldset.inputs > ol > div.activeadmin-translations'
    end

    it 'renders all locale selectors' do
      selectors = body.find('ul.available-locales')
      # Current locale has class default
      expect(selectors).to have_css 'li a.default', count: 1
      I18n.available_locales.each do |locale|
        # There is a selector for each available locale, it is an anchor tag with locale in target
        expect(selectors).to have_link I18n.t("active_admin.globalize.language.#{locale}"), href: ".locale-#{locale}"
      end
    end

    it 'renders all body inputs in html' do
      expect(body).to have_css 'fieldset.inputs.locale', count: I18n.available_locales.count
    end

    describe 'Locales fieldsets' do

      let(:fieldset) { body.find('fieldset.locale-en') }

      it 'renders a fieldset for each locale' do
        expect(body).to have_css '.activeadmin-translations > fieldset', count: I18n.available_locales.count
      end

      it 'renders the given inputs for each translatable attribute' do
        # Use the default locale form for this test
        expect(fieldset).to have_css 'input[name*="[translations_attributes]"][name*="[title]"]'
        expect(fieldset).to have_css 'textarea[name*="[translations_attributes]"][name*="[body]"]'
      end

      it 'renders the last element from user block' do
        # This is always working
        expect(fieldset).to have_css 'textarea[name*="[translations_attributes]"][name*="[body]"]'
      end

      it 'renders the locale attribute as hidden' do
        expect(fieldset).to have_css 'input[type="hidden"][name*="[translations_attributes]"][name*="[locale]"][value="en"]'
      end

      context 'with saved record' do

        let(:record) { create(:localized_article) }

        it 'renders the id attribute as hidden' do
          expect(fieldset).to have_css %Q{input[type="hidden"][name*="[translations_attributes]"][name*="[id]"][value="#{record.id}"]}
        end

        it 'fills existing attributes' do
          expect(fieldset.find_field('Title').value).to eq record.title
          expect(fieldset.find_field('Body').value).to eq record.body
        end

      end

      context 'when using arb inside builder' do
        let :body do
          # Form output will be available as capybara string
          build_form({}, record) do |f|
            f.translated_inputs 'some legend' do |t|
              t.input :title
              para 'arb content'
              t.input :body
              h1 'my title'
            end
          end
        end

        it 'render arb tags' do
          puts body.native.to_xhtml( indent:3, indent_text: ' ')
          # ap body.native.to_s
          expect(fieldset).to have_css 'p', text: 'arb content'
          expect(fieldset).to have_css 'h1', text: 'my title'
        end

        it 'still render user inputs' do
          expect(fieldset).to have_css 'input[name*="[translations_attributes]"][name*="[title]"]'
        end

        it 'still render hidden inputs' do
          expect(fieldset).to have_css 'input[type="hidden"][name*="[translations_attributes]"][name*="[locale]"][value="en"]'
        end

      end

    end

  end

end