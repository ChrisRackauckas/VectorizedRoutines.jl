module R

  """
  rep(v,ns)

  Code is due to aireties from StackExchange
  """
  function rep(v, ns)
    out = vcat([ [v[idx] for n = 1:ns[idx]] for idx = 1:length(v) ]...)
  end
end
