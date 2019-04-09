FactoryBot.define do
  factory :user do
    name {"Linh"}
    email {"abc@gmail.com"}
    password {"asdasd"}
    confirmed_at {Time.now}
  end
end
