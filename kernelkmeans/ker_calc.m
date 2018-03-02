function [result] = ker_calc(x1, x2, sigma)

% this function calculates the distance defined by the gaussian kernel
% function between two data samples for a given sigma

result = exp(-((norm(x1 - x2)).^2)/(2*sigma));