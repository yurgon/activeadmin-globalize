# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title 'Article title'
    body 'Article Body'

    factory :localized_article do

      after :create do |a|
        I18n.with_locale(:it) { a.update_attributes! title: 'Italian title', body: 'Italian Body' }
      end

    end

  end
end
