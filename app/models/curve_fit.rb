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

  def distance_between_curves(t0, t1, f, g, n)
    dx = (t1 - t0)/n.to_f
    (1..n).to_a.reduce(0) do |acc, i|
      x = t0 + i * dx
      acc + (f[x] - g[x]).abs
    end * dx
  end
end
