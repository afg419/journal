  class NelderMead < DirectSearchMinimizer
    def initialize(f, start_point)
      # Reflection coefficient
      @rho   = 1.0
      # Expansion coefficient
      @khi   = 2.0
      # Contraction coefficient
      @gamma = 0.5
      # Shrinkage coefficient
      @sigma = 0.5
      super(f, start_point, proc{iterate_simplex})
    end

    def iterate_simplex
      increment_iterations_counter
      n = @simplex.length - 1
      # the simplex has n+1 point if dimension is n
      best       = @simplex[0]
      secondBest = @simplex[n - 1]
      worst      = @simplex[n]
      x_worst    = worst.point
      centroid = Array.new(n, 0)
      # compute the centroid of the best vertices
      # (dismissing the worst point at index n)
      0.upto(n - 1) do |i|
        x = @simplex[i].point
        0.upto(n - 1) do |j|
          centroid[j] += x[j]
        end
      end
      scaling = 1.0 / n
      0.upto(n - 1) do |j|
        centroid[j] *= scaling
      end
      xr = Array.new(n)
      # compute the reflection point
      0.upto(n - 1) do |j|
        xr[j] = centroid[j] + @rho * (centroid[j] - x_worst[j])
      end
      reflected = PointValuePair.new(xr, f(xr))
      if ((compare(best, reflected) <= 0) && (compare(reflected, secondBest) < 0))
        # accept the reflected point
        replace_worst_point(reflected)
      elsif (compare(reflected, best) < 0)
        xe = Array.new(n)
        # compute the expansion point
        0.upto(n - 1) do |j|
          xe[j] = centroid[j] + @khi * (xr[j] - centroid[j])
        end
        expanded = PointValuePair.new(xe, f(xe))
        if (compare(expanded, reflected) < 0)
          # accept the expansion point
          replace_worst_point(expanded)
        else
          # accept the reflected point
          replace_worst_point(reflected)
        end
      else
        if (compare(reflected, worst) < 0)
          xc = Array.new(n)
          # perform an outside contraction
          0.upto(n - 1) do |j|
            xc[j] = centroid[j] + @gamma * (xr[j] - centroid[j])
          end
          out_contracted = PointValuePair.new(xc, f(xc))
          if (compare(out_contracted, reflected) <= 0)
            # accept the contraction point
            replace_worst_point(out_contracted)
            return
          end
        else
          xc = Array.new(n)
          # perform an inside contraction
          0.upto(n - 1) do |j|
            xc[j] = centroid[j] - @gamma * (centroid[j] - x_worst[j])
          end
          in_contracted = PointValuePair.new(xc, f(xc))

          if (compare(in_contracted, worst) < 0)
            # accept the contraction point
            replace_worst_point(in_contracted)
            return
          end
        end
        # perform a shrink
        x_smallest = @simplex[0].point
        0.upto(@simplex.length - 1) do |i|
          x = @simplex[i].get_point_clone
          0.upto(n - 1) do |j|
            x[j] = x_smallest[j] + @sigma * (x[j] - x_smallest[j])
          end
          @simplex[i] = PointValuePair.new(x, Float::NAN)
        end
        evaluate_simplex
      end
    end
  end
