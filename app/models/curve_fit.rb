# require 'app/models/minimization/nelder_mead.rb'
class CurveFit

  def line_between(p1, p2)
    Proc.new do |x|
      y  = slope(p1,p2)*(x-p1[:x]) + p1[:y]
    end
  end

  def slope(p1, p2)
    (p1[:y]-p2[:y]).to_f/(p1[:x]-p2[:x])
  end

  def segment(p1,p2)
    {a: p1, ab: line_between(p1,p2), b: p2}
  end

  def piece_wise_line(segments)
    Proc.new do |x|
      value = segments[0][:ab][x] if x < segments[0][:a][:x]
      segments.each do |s|
        value = s[:ab][x] if s[:a][:x] <= x && x <= s[:b][:x]
      end
      value = segments[-1][:ab][x] if segments[-1][:b][:x] < x
      value
    end
  end

  def ordered_points_to_piece_wise_line(points)
    segments = points[0..-2].each_index.map do |i|
      segment(points[i], points[i+1])
    end
    piece_wise_line(segments)
  end

  # def best_fit(n, extracted_scores)
  #   initial_theta = (0..n).to_a.map{|i| rand(-1.0..1.0)}
  #   j = cost(extracted_scores)
  #   min = NelderMead.minimize(j,initial_theta)
  #   min.x_minimum.map{|i| i.round(2)}
  # end
  #
  # def cost(extracted_scores)
  #   Proc.new do |theta|
  #     extracted_scores.reduce(0) do |acc, score|
  #       acc + (hyp[theta][score[:x]] - score[:y])**2
  #     end/(2 * extracted_scores.count.to_f)
  #   end
  # end
  #
  #
  # def hyp
  #   Proc.new do |theta|
  #     Proc.new do |x|
  #       theta.each_index.reduce(0) do |acc, i|
  #         acc + (theta[i])*(x**i)
  #       end
  #     end
  #   end
  # end
  #
  # def best_curve(n, extracted_scores)
  #   hyp[best_fit(n, extracted_scores)]
  # end
  #
  # def translate_curve_left(lam, val) #val > 0
  #   Proc.new{|x| lam[x+val]}
  # end

  def distance_between_curves(t0, t1, f, g)
    Integration.integrate(t0, t1, {:tolerance=>0.01,:method=>:simpson}) do |x|
        (f[x]-g[x]).abs
    end
  end
end
