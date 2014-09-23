# ActiveAdmin::Globalize

Makes it easy to translate your resource fields.

## Installation

This version targets Rails 4 and greater and ActiveAdmin >= 1.0.0.pre.

```ruby
gem 'activeadmin-globalize', '~> 1.0.0.pre', github: 'fabn/activeadmin-globalize', branch: 'develop'
```

As soon as ActiveAdmin 1.x is released to rubygems, I'll release the gem with no need for github dependency. See
[this issue](https://github.com/activeadmin/activeadmin/issues/3448) for more details.

Previous version with support for Rails 3 is maintained in branch [support/0.6.x](https://github.com/fabn/activeadmin-globalize/tree/support/0.6.x)

## Your model

```ruby
active_admin_translates :title, :description do
  validates_presence_of :title
end
```
## Editor configuration

```ruby

# For usage with strong parameters you'll need to permit them
permit_params translations_attributes: [:id, :locale, :title, :content, :_destroy]

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


## Hints

To use the dashed locale keys as 'pt-BR' or 'pt-PT' you need to convert a string
to symbol (in application.rb)

```ruby
  config.i18n.available_locales = [:en, :it, :de, :es, :"pt-BR"]
```

## Credits

This work is based on original idea by [@stefanoverna](https://github.com/stefanoverna/activeadmin-globalize),
 I needed it for AA 0.6.x so I forked the original project and expanded it with more features.
