class TrainingPost < ActiveRecord::Base
  def reddit_miner
    @rm ||= RedditMiner.new
  end

  def self.get_training_posts(subreddit, filter, api_calls, tag, continue_at = nil)
    puts "Initial TrainingPosts count: #{TrainingPost.count}"
    posts_next = RedditMiner.new.process_many(subreddit, filter, api_calls)
    puts "Unique posts gathered from Reddit: #{posts_next[:posts].count}"
    posts_next[:posts].each do |post|
      next if post.selftext.split.count < 20
      TrainingPost.find_or_create_by(entry: post.selftext, classification: tag)
    end
    puts "Final TrainingPosts count: #{TrainingPost.count} "
    posts_next[:continue_at]
  end
end
