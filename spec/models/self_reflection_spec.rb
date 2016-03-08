require 'rails_helper'

RSpec.describe SelfReflection, type: :model do
  before :each do
    seed_emotions_user
  end

  def modified_sin(i)
    (4.5) * (Math.sin(i) + 1).floor
  end

  it "extracts most similar start date" do
    mock_login
    times = (0..10).to_a.map{|i| Time.now - i.day}
    times.each_index.each do |i|
      create_journal_post([modified_sin(i),0,0], "title#{i}", times[i])
    end
    happy = @user.active_emotion_prototypes.first

    sr = SelfReflection.new(@user)
    comparisons = sr.distances_between_journal_and_journal_span(happy, 2.day)
    expect(comparisons.first[1].day).to eq 28
  end

  # it "extracts most similar start date" do
    # mock_login
    # times = (0..100).to_a.map{|i| Time.now - i.day}
    # times.each_index.each do |i|
    #   create_journal_post([modified_sin(i),0,0], "title#{i}", times[i])
    # end
    # happy = @user.active_emotion_prototypes.first
    #
    # sr = SelfReflection.new(@user)
    # comparisons = sr.distances_between_journal_and_journal_span(happy, 7.day)
    # expect(comparisons.first[1]).to eq times[9]
  # end
end
