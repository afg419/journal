class ReflectiveSimilarity
  attr_reader :cf, :interval, :user, :emotion_prototype
  #interval is an integer, number of days
  def initialize(user, interval, emotion_prototype = nil, cf = nil)
    @cf = cf || CurveFit.new
    @interval = interval
    @emotion_prototype = emotion_prototype
    @user = user
  end

  def extract_time_score(scores)
    scores.map{|score| {x: score[:created_at].to_i, y: score[:score]}}
  end

  def translate_scale_extracted_scores(extracted_scores, start_time)
    extracted_scores.map do |score|
      {x: (score[:x] - start_time)/(interval.days.to_f), y: score[:y]}
    end
  end

  def scores_to_translated_curve(scores, start_time)
    extracted_scores = translate_scale_extracted_scores(extract_time_score(scores), start_time.to_i)
    cf.ordered_points_to_piece_wise_line(extracted_scores)
  end

  def unix_day
    1.day.to_i
  end

  def unix_between_by_day(unix1, unix2)
    (unix1 - unix2).abs/unix_day
  end

  def scores_by_interval
    scores = user.scores_for(emotion_prototype, user.first_entry_date, user.last_entry_date).sort_by{|x| x[:created_at]}
    first_day = user.first_entry_date.beginning_of_day.to_i
    last_day = user.last_entry_date.beginning_of_day.to_i
    scores_by_day = []
    scores.each do |score|
      current_day = score[:created_at].beginning_of_day.to_i
      index = unix_between_by_day(current_day,first_day)
      scores_by_day[index] ||= []
      scores_by_day[index] << score
    end

    x = scores_by_day.each_index.map do |i|
      next if scores_by_day.count - i < interval
      scores_by_day[i..i+interval-1].compact.flatten
    end.compact
  end

  def translated_curves_by_interval
    initial = user.first_entry_date
    sbi = scores_by_interval
    sbi.each_index.map do |i|
      puts "#{i} of 300"
      [scores_to_translated_curve(sbi[i], initial + i.days),sbi[i].first[:created_at]]
    end
  end
end
