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
    expect(user.inactive_emotion_prototypes.map{|y| y.name}).to eq ["sad"]
  end

  it "sets emotion prototypes as active or inactive" do
    user = User.create("email" => "x", "name" => "y", "permission_id" => "z")
    happy = user.emotion_prototypes.create(name: "happy", description: "yaye!")
    sad = user.emotion_prototypes.create(name: "sad", description: "boohoo")

    user.set_emotion_prototype("inactive", "sad")

    expect(user.active_emotion_prototypes.map{|y| y.name}).to eq ["happy"]
    expect(user.inactive_emotion_prototypes.map{|y| y.name}).to eq ["sad"]

    user.set_emotion_prototype("active", "sad")

    expect(user.active_emotion_prototypes.map{|y| y.name}.sort).to eq ["happy", "sad"].sort
    expect(user.inactive_emotion_prototypes.map{|y| y.name}).to eq []
  end

  it "gets scores for emotion_prototype" do
    seed_emotions_user
    mock_login
    create_journal_post([3,2,0], "post1", Time.now)
    create_journal_post([6,1,2], "post2", Time.now)
    reply = @user.scores_for(@user.emotion_prototypes[0], Time.now - 1.day, Time.now).map {|score|
      score.except(:created_at)
    }
    expect(reply).to eq [{:score=>3, :tag=>"post1"}, {:score=>6, :tag=>"post2"}]
  end

  it "gets scores for emotion_prototype scoped by time" do
    seed_emotions_user
    mock_login
    create_journal_post([3,2,0], "post1", Time.now)
    create_journal_post([6,1,2], "post2", Time.now)
    create_journal_post([5,1,2], "post2", Time.now - 7.day)
    reply = @user.scores_for(@user.emotion_prototypes[0], Time.now - 1.day, Time.now).map {|score|
      score.except(:created_at)
    }
    expect(reply).to eq [{:score=>3, :tag=>"post1"}, {:score=>6, :tag=>"post2"}]
  end

  it "gets chart emotion data scoped by time" do
    seed_emotions_user
    mock_login

    t1 = Time.now
    t2 = Time.now
    t3 = Time.now - 7.day

    create_journal_post([3,2,0], "post1", t1)
    create_journal_post([6,1,2], "post2", t2)
    create_journal_post([5,1,2], "post2", t3)
    reply = @user.chart_emotion_data(Time.now - 1.day, Time.now)

    expected_reply = {@user.id=>{
      "happy"=>
        {:color=>"#D6D965",
         :scores=>
            [{:created_at=> t1,
              :score=>3,
              :tag=>"post1"},
             {:created_at=>t2,
              :score=>6,
              :tag=>"post2"}]},
      "sad"=>
         {:color=>"#D6D965",
          :scores=>
            [{:created_at=> t1,
              :score=>2,
              :tag=>"post1"},
             {:created_at=> t2,
              :score=>1,
              :tag=>"post2"}]},
      "angry"=>
          {:color=>"#D6D965",
           :scores=>
            [{:created_at=> t1,
              :score=>0,
              :tag=>"post1"},
             {:created_at=> t2,
              :score=>2,
              :tag=>"post2"}]}
          }
    }
    expect(reply).to eq expected_reply
  end

  it "gets scores for emotion with endpoint data" do
    mock_login
    t0 = Time.now
    t1 = Time.now - 1.day
    t2 = Time.now - 3.day

    j0 = create_journal_post([0,1,2], "title0", t0)
    j1 = create_journal_post([0,1,2], "title1", t1)
    j2 = create_journal_post([0,1,2], "title2", t2)

    happy = @user.active_emotion_prototypes.first
    sleep(0.25)
    scores = @user.scores_for_emp_with_endpoints(happy, (Time.now-3.day), Time.now)
    expect(scores.map{|score| score[:tag]}.sort).to eq ["title0", "title0", "title1", "title2"].sort
  end
end
