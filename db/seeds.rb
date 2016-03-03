# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def seed_basic_emotion_prototypes
  emotion_prototypes = [
    EmotionPrototype.create(name: "happy", description: " ", color: "#D6D965"),
    EmotionPrototype.create(name: "sad", description: " ", color: "#186991"),
    EmotionPrototype.create(name: "angry", description: " ", color: "#951313")
  ]
  User.create(email:"basic_emotion_prototypes", emotion_prototypes: emotion_prototypes)
  puts "seeded basic emotion prototypes"
end

seed_basic_emotion_prototypes
