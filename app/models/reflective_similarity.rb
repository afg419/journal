class ReflectiveSimilarity
  attr_reader :cf

  def initialize(cf = nil)
    @cf = cf || CurveFit.new
  end

  def entries_to_translated_curve(emotion_prototype, start_time, interval, user)
    scores = user.scores_for_emp_with_endpoints(emotion_prototype, start_time, start_time + interval)
    extracted_scores = translate_scale_extracted_scores(cf.extract_time_score(scores), start_time.to_i, interval.to_i)
    n = [[extracted_scores.count - 1 , 7].min, 0].max
    cf.best_curve(n, extracted_scores)
  end

#############################3.......................

  def extract_time_score(scores)
    scores.map{|score| {x: score[:created_at].to_i, y: score[:score]}}
  end

  def translate_scale_extracted_scores(extracted_scores, start_time, interval)
    extracted_scores.map do |score|
      {x: (score[:x] - start_time)/(interval.days.to_f), y: score[:y]}
    end
  end

  def scores_to_translated_curve(scores, start_time, interval)
    extracted_scores = translate_scale_extracted_scores(extract_time_score(scores), start_time.to_i, interval.to_i)
    # n = [[extracted_scores.count - 1 , 7].min, 0].max
    # cf.best_curve(n, extracted_scores)
    # binding.pry
    cf.ordered_points_to_piece_wise_line(extracted_scores)
  end

  def scores_by_interval(emotion_prototype, interval, user)
    scores = user.scores_for(emotion_prototype, user.first_entry_date, user.last_entry_date)
    scores_by_day = scores.slice_when{|i,j| i[:created_at].day != j[:created_at]}.to_a
    scores_by_interval = scores_by_day.each_index.map do |i|
      scores_by_day[i..i + interval].flatten
    end[0..-interval]
  end

  #interval is an integer, number of days

  def translated_curves_by_interval(emotion_prototype, interval, user)
    initial = user.first_entry_date
    sbi = scores_by_interval(emotion_prototype, interval, user)
    sbi.each_index.map do |i|
      puts "#{i} of 300"
      [scores_to_translated_curve(sbi[i], initial + i.days, interval),sbi[i].first[:created_at]]
    end
  end


end
