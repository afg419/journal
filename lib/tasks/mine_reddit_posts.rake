require 'csv'

namespace :initialize do
  desc "Seeds database"
  task mine_reddit: :environment do
    TrainingPost.get_training_posts("suicidewatch","new",10,"Troubled")
    TrainingPost.get_training_posts("diaryofaredditor","",10,"Ok")
    TrainingPost.get_training_posts("examplesofgood","",10,"Ok")
    TrainingPost.get_training_posts("meditation","",5,"Ok")
    TrainingPost.get_training_posts("selfhelp","",3,"Ok")
    TrainingPost.get_training_posts("howtonotgiveafuck","",3,"Ok")
    TrainingPost.get_training_posts("purpose","",5,"Ok")
    TrainingPost.get_training_posts("accomplishedtoday","",5,"Ok")
    puts "mine complete!"

    b = BayesSuicideClassifier.new
    b.train_on_training_posts
    puts "I had a good day today.: #{b.classifier.classify("I had a good day today.")}"
    puts "I want to fucking kill myself.: #{b.classifier.classify("I want to fucking kill myself.")}"
    puts "I want some milk at the store right now!.: #{b.classifier.classify("I want some milk at the store right now!")}"
  end
end
