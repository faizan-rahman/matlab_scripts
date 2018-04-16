function output = sthresh(input, threshold);

coefficients_less_than_threshold = find(abs(input)<=threshold);
coefficients_greater_than_threshold = find(abs(input)>threshold);
input(coefficients_less_than_threshold) = 0;
input(coefficients_greater_than_threshold) = sign(input(coefficients_greater_than_threshold)).*(abs(input(coefficients_greater_than_threshold))-threshold);
output = input;

end