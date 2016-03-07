class EmotionScoresJudge

  def best_fit_7d(extracted_scores)
    theta = (0..7).to_a.map{|i| rand(-1.0..1.0)}

  end

  def cost(extracted_scores)
    Proc.new do |theta|
      extracted_scores.reduce(0) do |acc, score|
        acc + (hyp[theta][score[:x]] - score[:y])**2
      end/(2 * extracted_scores.count.to_f)
    end
  end

  def extract_time_score(scores)
    scores.map{|score| {x: score[:created_at].to_i, y: score[:score]}}
  end

  def hyp
    Proc.new do |theta|
      Proc.new do |x|
        theta.each_index.reduce(0) do |acc, i|
          acc + (theta[i])*(x**i)
        end
      end
    end
  end
end
