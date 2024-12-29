# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

Faker::Config.locale = 'ja'

50.times do |userIndex|
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
    gender: userIndex.even? ? 1 : 2,
    bio: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false) + "\n" + Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false),
    amount_min: rand(1000..3000),
    amount_max: rand(3001..5000)
  )

  10.times do |bookIndex|
    book = user.books.create!(
      title: Faker::Book.title,
      memo: Faker::Lorem.paragraph_by_chars(number: 300, supplemental: false) + "\n" + Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false)
    )

    5.times do |noveltyIndex|
      book.novelties.create!(
        name: Faker::Name.name
      )
    end
  end
end
