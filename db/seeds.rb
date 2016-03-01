# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def seed_basic_emotion_prototypes
  emotion_prototypes = [
    EmotionPrototype.create(name: "Happy", description: " ", color: "#D6D965"),
    EmotionPrototype.create(name: "Sad", description: " ", color: "#D6D965"),
    EmotionPrototype.create(name: "Angry", description: " ", color: "#D6D965")
  ]
  User.create(email:"basic_emotion_prototypes", emotion_prototypes: emotion_prototypes)
  puts "seeded basic emotion prototypes"
end

seed_basic_emotion_prototypes
