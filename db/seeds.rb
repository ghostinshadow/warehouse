# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

materials_dictionary = MaterialsDictionary.create!(title: "Словник матеріалів")

cobblestone = materials_dictionary.words.create!(body: "Кругляк")

bottoms = materials_dictionary.words.create!(body: "Днища")
bottoms.subtype_dictionary.words.create!(body: "500мм")
bottoms.subtype_dictionary.words.create!(body: "600мм")
bottoms.subtype_dictionary.words.create!(body: "700мм")
bottoms.subtype_dictionary.words.create!(body: "800мм")

sheet_metal = materials_dictionary.words.create!(body: "Листовий метал")
sheet_metal.subtype_dictionary.words.create!(body: "1мм")
sheet_metal.subtype_dictionary.words.create!(body: "2мм")
sheet_metal.subtype_dictionary.words.create!(body: "2.5мм")
sheet_metal.subtype_dictionary.words.create!(body: "3мм")

threaded_sockets = materials_dictionary.words.create!(body: "Муфти з різьбами")
threaded_sockets.subtype_dictionary.words.create!(body: "15мм")
threaded_sockets.subtype_dictionary.words.create!(body: "50мм")

units_dictionary = UnitsDictionary.create!(title: "Словник умовних одиниць")
%W{ шт.  мм   м/п   м²   м³   л/год }.each do |word|
  units_dictionary.words.create!(body: word)
end

User.create!(email: 'admin@example.com', role: 'admin', password: 'password', password_confirmation: 'password')