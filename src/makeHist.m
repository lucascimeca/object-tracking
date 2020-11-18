function sm_histogram = makeHist(img)
  pic = img;
  [m,n] = size(pic);
  pic = reshape(pic,1,m*n);
  figure(1);
  histogram = dohist(pic, 1);
  filter = gausswin(50,6);
  filter = filter/(sum(filter));
  sm_histogram = conv(filter, histogram);
  figure(2)
  plot(sm_histogram)
end