function output = hthresh(input, threshold);

coefficients_less_than_threshold = find(abs(input)<=threshold);
input(coefficients_less_than_threshold) = 0;
output = input;

end