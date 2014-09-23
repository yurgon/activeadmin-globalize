# ActiveAdmin::Globalize
Makes it easy to translate your resource fields.

## Installation

```ruby
gem 'activeadmin-globalize', '~> 0.6.3'
```

This version targets Rails 3.2.x only and ActiveAdmin ~> 0.6.3.

## Your model

```ruby
active_admin_translates :title, :description do
  validates_presence_of :title
end
```
## Editor configuration

```ruby
index do
  # textual translation status
  translation_status
  # or with flag icons
  translation_status_flags
  # ...
  default_actions
end

form do |f|
  # ...
  f.translated_inputs "Translated fields", switch_locale: false do |t|
    t.input :title
    t.input :content
  end
  # ...
end
```
If `switch_locale` is set, each tab will be rendered switching locale.

## Friendly ID

If you want to use Friendly ID together with Globalize, please take a look
at the `activeadmin-seo` gem.

## Hints

To use the dashed locale keys as 'pt-BR' or 'pt-PT' you need to convert a string
to symbol (in application.rb)

  config.i18n.available_locales = [:en, :it, :de, :es, :"pt-BR"]

## Credits

This work is based on original idea by [@stefanoverna](https://github.com/stefanoverna/activeadmin-globalize),
 I needed it for AA 0.6.x so I forked the original project.
