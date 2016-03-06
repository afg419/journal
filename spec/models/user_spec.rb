require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    seed_emotions_user
  end

  it "finds by auth" do
    user1 = User.create("email" => "x", "name" => "y", "permission_id" => "z")
    user2 = User.find_or_create_by_auth("email" => "x")

    expect(user2.email).to eq user1.email
    expect(user2.name).to eq user1.name
    expect(user2.permission_id).to eq user1.permission_id
  end

  it "creates by auth" do
    user_email = "x"
    user_name = "y"
    user_permission_id = "z"

    user = User.find_or_create_by_auth("email" => user_email, "name" => user_name, "permission_id" => user_permission_id)

    expect(user.email).to eq user_email
    expect(user.name).to eq user_name
    expect(user.permission_id).to eq user_permission_id
  end

  it "updates by auth" do
    user_email = "x"
    user_name = "y2"
    user_permission_id = "z2"

    user1 = User.create("email" => user_email, "name" => "y", "permission_id" => "z")
    user2 = User.find_or_create_by_auth("email" => user_email, "name" => user_name, "permission_id" => user_permission_id)
    user3 = User.find_by("name" => "y")

    expect(user2.email).to eq user_email
    expect(user2.name).to eq user_name
    expect(user2.permission_id).to eq user_permission_id
    expect(user3).to eq nil
  end

  it "returns only active emotion prototypes" do
    user = User.create("email" => "x", "name" => "y", "permission_id" => "z")
    happy = user.emotion_prototypes.create(name: "happy", description: "yaye!")
    sad = user.emotion_prototypes.create(name: "sad", description: "boohoo")
    user_is_sad = UserEmotionPrototype.find_by(emotion_prototype_id: sad.id)

    user_is_sad.update_attributes(status: "inactive")

    expect(user.active_emotion_prototypes.map{|y| y.name}).to eq ["happy"]
  end
end
