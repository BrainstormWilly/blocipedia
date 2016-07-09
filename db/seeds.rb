require "random_data"

5.times do
  user = User.new(name: Faker::Name.name, email: Faker::Internet.email, password: '123456', password_confirmation: '123456')
  user.skip_confirmation!
  user.save
end
users = User.all

admin = User.new(name: "Willy", email: "brainstormwilly@gmail.com", password: "123456", role: "admin", password_confirmation: '123456')
admin.skip_confirmation!
admin.save

member = User.new(name: "YnoGuy", email: "bill@ynoguy.com", password: "123456", password_confirmation: '123456')
member.skip_confirmation!
member.save

rand(5..10).times do
  Wiki.create(title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph, user: users.sample)
end

rand(2..5).times do
  Wiki.create(title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph, private:true, user: admin)
end

puts "Seeds Finished."
puts "#{User.count} users."
puts "#{Wiki.count} wikis."
