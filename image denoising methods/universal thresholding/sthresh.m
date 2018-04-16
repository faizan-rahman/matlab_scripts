function output = sthresh(input, threshold);    %this function implements soft thresholding

coefficients_less_than_threshold = find(abs(input)<=threshold); 
coefficients_greater_than_threshold = find(abs(input)>threshold);
input(coefficients_less_than_threshold) = 0;    % coefficients less than the threshold are set to zero
input(coefficients_greater_than_threshold) = sign(input(coefficients_greater_than_threshold)).*(abs(input(coefficients_greater_than_threshold))-threshold); %coefficients larger than the threshold are modified by a preset formula
output = input;

end