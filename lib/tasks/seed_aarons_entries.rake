def create_journal_post(scores, tag, time, user)
  emotion_prototypes = user.emotion_prototypes
  emotions = emotion_prototypes.zip(scores).map do |emotion_prototype, score|
    emotion_prototype.emotions.create(score: score)
  end
  j = user.journal_entries.create(tag: tag, emotions: emotions, user: user, created_at: time)
end

def modified_sin(i)
  (4*Math.sin(0.10*i) + 5 + rand(-1.0..1.9)).floor
end

namespace :initialize do
  desc "Seeds database"
  task aaron_sin_posts: :environment do
    aaron = User.find_by(email: "afg419@gmail.com")
    aaron.journal_entries.delete_all
    tf = Time.now - 301.days
    times = (0..300).to_a.map do |i|
      tf + i.days
    end

    times.each_index do |i|
      create_journal_post([modified_sin(i),modified_sin(i+1),modified_sin(i-4),0,0,0], "title#{i}", times[i], aaron)
      puts "#{i}"
    end
  end
end
