function output = hthresh(input, threshold);    %this function implements hard thresholding

coefficients_less_than_threshold = find(abs(input)<=threshold); 
input(coefficients_less_than_threshold) = 0;    % coefficients less than the threshold are set to zero
output = input;

end