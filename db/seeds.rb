require "random_data"

5.times do
  user = User.create(name: Faker::Name.name, email: Faker::Internet.email, password: RandomData.random_sentence)
  user.confirm
end
users = User.all

admin = User.create(name: "Willy", email: "brainstormwilly@gmail.com", password: "123456", role: "admin")
admin.confirm

member = User.create(name: "YnoGuy", email: "bill@ynoguy.com", password: "123456")
member.confirm

20.times do
  Wiki.create(title: Faker::Lorem.word, body: Faker::Lorem.paragraph, user: users.sample)
end

puts "Seeds Finished."
puts "#{User.count} users."
puts "#{Wiki.count} wikis."
