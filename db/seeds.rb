User.create!(
  name: "Admin",
  email: "lyld1203@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: true,
  phone: "0123456789",
  activated: true,
  activated_at: Time.zone.now
)

User.create!(
  name: "Linh",
  email: "abc@gmail.com",
  password: "asdasd",
  password_confirmation: "asdasd",
  role: true,
  phone: "02156446846",
  activated: true,
  activated_at: Time.zone.now
)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  phone = Faker::PhoneNumber.cell_phone
  password = "password"
  User.create!(
    name: name,
    email: email,
    role: false,
    phone: phone,
    password: password,
    activated: true,
    activated_at: Time.zone.now
  )
end

# Category Seed
Category.create!(
  name: "Fast Food",
  parent_id: nil
)

Category.create!(
  name: "Bread",
  parent_id: nil
)

Category.create!(
  name: "Noodles",
  parent_id: nil
)

Category.create!(
  name: "Meat",
  parent_id: nil
)

# Product Seed
12.times do
  Product.create!(
    name: Faker::Lorem.sentence(5),
    price: Faker::Number.between(10, 900),
    information: Faker::Lorem.paragraph(5),
    classify: true,
    quantity: Faker::Number.between(1, 90),
    category_id: 1
  )
end

10.times do
  Product.create!(
    name: Faker::Lorem.sentence(5),
    price: Faker::Number.between(10, 900),
    information: Faker::Lorem.paragraph(5),
    classify: false,
    quantity: Faker::Number.between(1, 90),
    category_id: 2
  )
end
