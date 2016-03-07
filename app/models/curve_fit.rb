# require 'app/models/minimization/nelder_mead.rb'
class CurveFit
  def best_fit(n, extracted_scores)
    initial_theta = (0..n).to_a.map{|i| rand(-1.0..1.0)}
    # initial_theta = (0..n).to_a.map{|i| 0}
    j = cost(extracted_scores)
    min = NelderMead.minimize(j,initial_theta)
    min.x_minimum.map{|i| i.round(2)}
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

  def best_curve(n, extracted_scores)
    hyp[best_fit(n, extracted_scores)]
  end

  def translate_curve_left(lam, val) #val > 0
    Proc.new{|x| lam[x+val]}
  end

  def distance_between_curves(t0, t1, f, g)
    Integration.integrate(t0, t1, {:tolerance=>1e-10,:method=>:simpson}) do |x|
          [f[x],g[x]].max - [f[x],g[x]].min
    end
  end
end
