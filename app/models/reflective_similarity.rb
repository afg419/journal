class ReflectiveSimilarity
  attr_reader :cf

  def initialize
    @cf = CurveFit.new
  end

  def entries_to_translated_curve(emotion_prototype, start_time, interval, user)
    scores = user.scores_for_emp_with_endpoints(emotion_prototype, start_time, start_time + interval)
    extracted_scores = translate_scale_extracted_scores(cf.extract_time_score(scores), start_time.to_i, interval.to_i)
    n = [[extracted_scores.count - 1 , 7].min, 0].max
    cf.best_curve(n, extracted_scores)
  end

  def translate_scale_extracted_scores(extracted_scores, start_time, interval)
    extracted_scores.map do |score|
      {x: (score[:x] - start_time)/(interval.to_f), y: score[:y]}
    end
  end
end
