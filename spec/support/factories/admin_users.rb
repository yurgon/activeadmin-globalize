FactoryGirl.define do

  factory :user, class: AdminUser do

    sequence(:email) { |n| "admin#{n}@example.com" }
    password { 'password' }
    password_confirmation { |u| u.password }

  end

end
