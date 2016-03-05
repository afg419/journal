# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def seed_basic_emotion_prototypes
  emotion_prototypes = [
    EmotionPrototype.create(name: "happy", description: "High scores in this category represent an experience of great pleasure, elation, or excitement. Low scores represent the lack of these feelings, but don't necessarily imply the presence of any other emotion (e.g. sadness, anger).", color: "#D6D965"),
    EmotionPrototype.create(name: "sad", description: "High scores in this category represent an experience of great mourning or emotional pain characteristic of sadness. Low scores represent the lack of these feelings, but don't necessarily imply the presence of any other emotion (e.g. happiness).", color: "#186991"),
    EmotionPrototype.create(name: "angry", description: "High scores in this category represent an experience of great frustration, fury, or rage. Low scores represent the lack of these feelings, but don't necessarily imply the presence of any other emotion.", color: "#951313"),
    EmotionPrototype.create(name: "anxious", description: "High scores in this category represent an experience of great worry, dread, or fear. Low scores represent the lack of these feelings, but don't necessarily imply the presence of any other emotion (e.g. happiness, or calm).", color: "#AB6E23"),
    EmotionPrototype.create(name: "focused", description: "High scores in this category represent an experience of the ability to concentrate with sharp clarity when one desires. Low scores represent a feeling of scatterbrainedness, or difficulty fixing attention on a task.", color: "#6C4A82"),
    EmotionPrototype.create(name: "content", description: "High scores in this category represent an experience of great calm or peace with regards to one's own emotional experience. Contentness is characterized by satisfaction with how one feels, while low scores represent a desire or need to feel differently emotionally. Low scores represent the lack of these feelings, but don't necessarily imply the presence of any other emotion.", color: "#3D6D3C")
  ]
  User.create(email:"basic_emotion_prototypes", emotion_prototypes: emotion_prototypes)
  puts "seeded basic emotion prototypes"
end

seed_basic_emotion_prototypes
