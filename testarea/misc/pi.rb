def calc_pi
    q, r, t, k = 1, 0, 1, 1
    loop do
      n = (3*q+r) / t
      if (4*q+r) / t == n then
        yield n
        q, r, t, k = 10*q, 10*(r-n*t), t, k
      else
        q, r, t, k = q*k, q*(4*k+2)+r*(2*k+1), t*(2*k+1), k+1
      end
    end
end

calc_pi {|n| print n; $stdout.flush }


