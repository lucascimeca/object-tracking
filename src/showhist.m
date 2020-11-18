function thehist = showhist(hist,show)

  % set up bin edges for histogram
  edges = zeros(256,1);
  for i = 1 : 256;
    edges(i) = i-1;
  end

  thehist = hist;
  if show > 0
      figure(show)
      clf
      pause(0.1)
      plot(edges,thehist)
      axis([0, 255, 0, 1.1*max(thehist)])
  end
