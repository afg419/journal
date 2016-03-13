require 'rails_helper'

RSpec.describe SelfReflection, type: :model do
  before :each do
    seed_emotions_user
  end

  def modified_sin(i)
    (4.5) * (Math.sin(i) + 1).floor
  end

  def ramp_up(i)
    i
  end

  it "extracts most similar start date for simple seeds" do
    mock_login

    t0 = Time.now - 10.day

    times = (0..10).to_a.map{|i| t0 + i.day}
    times.each_index.each do |i|
      create_journal_post([ramp_up(i),0,0], "title#{i}", times[i])
    end
    happy = @user.active_emotion_prototypes.first

    sr = SelfReflection.new(@user, 2, happy)
    comparisons = sr.distances_between_current_interval_and_past_intervals
    min = comparisons.min_by{|x| x[0]}

    expect(min[1].day).to eq times[-3].day
  end

  it "extracts most similar start date" do
    mock_login
    t0 = Time.now - 10.day

    times = (0..10).to_a.map{|i| t0 + i.day}
    times.each_index.each do |i|
      create_journal_post([modified_sin(i),0,0], "title#{i}", times[i])
    end
    happy = @user.active_emotion_prototypes.first

    sr = SelfReflection.new(@user, 2, happy)
    comparisons = sr.distances_between_current_interval_and_past_intervals
    min = comparisons.min_by{|x| x[0]}

    expect(min[1].day).to eq times[1].day
  end
end
