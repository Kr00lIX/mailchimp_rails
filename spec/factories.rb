FactoryGirl.define do
  factory :user do
    first_name { Faker::NameRU.first_name }
    last_name { Faker::NameRU.last_name }

    email { "#{first_name}.#{last_name}@example.com".downcase }
  end

  ## This will use the User class (Admin would have been guessed)
  #factory :admin, class: User do
  #  first_name "Admin"
  #  last_name  "User"
  #  admin      true
  #end

end