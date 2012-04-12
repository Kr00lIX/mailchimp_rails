FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { "#{first_name}.#{last_name}@example.com".downcase }

    factory :subscribed_user do
      after_build { |user| user.subscription_state = "active" }
    end

    factory :unsubscribed_user do
      after_build { |user| user.subscription_state = "disabled" }
    end

    factory :subscribed_error_user do
      after_build { |user| user.subscription_state = "error" }
    end
  end
end