require 'faker'
Faker::Config.locale = 'pl'

puts "Cleaning database..."
Lap.delete_all
Race.delete_all
Track.delete_all
User.delete_all

puts "Creating users..."
users = []

users << User.create!(
  email: "antek@gmail.com",
  password: "Antek.123",
  first_name: "Admin",
  last_name: "User",
  birthdate: "1990-01-01",
  role_mask: "A"
)

users << User.create!(
  email: "bartek@gmail.com",
  password: "Bartek.123",
  first_name: "Admin",
  last_name: "User",
  birthdate: "1990-01-01",
  role_mask: "A"
)

users << User.create!(
  email: "maciek@gmail.com",
  password: "Maciek.123",
  first_name: "Admin",
  last_name: "User",
  birthdate: "1990-01-01",
  role_mask: "A"
)


users << User.create!(
  email: "aw@gmail.com",
  password: "Antek.123",
  first_name: "Tester",
  last_name: "User",
  birthdate: "1995-06-15"
)

# Losowi użytkownicy
48.times do
  users << User.create!(
    email: Faker::Internet.unique.email,
    password: "Antek.123",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    birthdate: Faker::Date.birthday(min_age: 19, max_age: 60)
  )
end

puts "Creating tracks..."
track_data = 20.times.map do
  {
    name: "#{Faker::Address.city} Track",
    location: Faker::Address.city,
    length_meters: rand(300..1200),
    is_indoor: [true, false].sample
  }
end
tracks = Track.create!(track_data)

puts "Creating races and laps..."
tracks.each do |track|
  12.times do

    start_time = Faker::Time.backward(days: 10, period: :afternoon)
    end_time = start_time + rand(10..90).minutes
    race = Race.create!(
      track: track,
      name: "Race #{Faker::Vehicle.make_and_model}",
      start_time: start_time,
      end_time: end_time
    )

    race_users = users.sample(rand(6..10))

    race_users.each_with_index do |user, i|
      num_laps = rand(2..5)
      num_laps.times do |lap_number|
        Lap.create!(
          user: user,
          race: race,
          lap_number: lap_number + 1,
          lap_time_seconds: rand(35.0..90.0).round(3),
          position: i + 1
        )
      end
    end
  end
end

puts "✅ Seed finished! Total:"
puts "- Users: #{User.count}"
puts "- Tracks: #{Track.count}"
puts "- Races: #{Race.count}"
puts "- Laps: #{Lap.count}"
