require 'rails_helper'

RSpec.describe TrainingPost, type: :model do

  it "gets single api call posts from reddit" do
    VCR.use_cassette 'mining-once-from-all' do
      TrainingPost.get_training_posts("all","",1,"ok")

      expect(TrainingPost.count).to eq 6

      contents = TrainingPost.all.map {|x| x.entry}

      contents.each do |content|
        expect(content.split.count >= 20)
      end

      classifications = TrainingPost.all.map{|x| x.classification}.uniq
      expect(classifications).to eq ["ok"]
    end
  end

  it "gets multiple api calls from reddit" do
    VCR.use_cassette 'mining-multi-from-all' do
      TrainingPost.get_training_posts("all","",2,"ok")

      expect(TrainingPost.count).to eq 21

      contents = TrainingPost.all.map {|x| x.entry}

      contents.each do |content|
        expect(content.split.count >= 20)
      end
    end
  end

  it "gets single api call from reddit with troubled class" do
    VCR.use_cassette 'mining-once-from-all' do
      TrainingPost.get_training_posts("all","",1,"troubled")

      classifications = TrainingPost.all.map{|x| x.classification}.uniq
      expect(classifications).to eq ["troubled"]
    end
  end

  it "gets single api call from reddit with filter" do
    VCR.use_cassette 'mining-once-from-all-new' do
      TrainingPost.get_training_posts("all","new",1,"ok")

      expect(TrainingPost.count).to eq 50

      contents = TrainingPost.all.map {|x| x.entry}

      contents.each do |content|
        expect(content.split.count >= 20)
      end
    end
  end



end
