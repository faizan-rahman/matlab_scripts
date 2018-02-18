function [kernel_matrix, sigma_avg] = ker_mat_calc(data, sigma_avg)

% this function calculates the gaussian kernel distance matrix of a given
% dataset for a given value of the gaussian kernel parameter called
% sigma_avg

X = data;

kernel_matrix = zeros(size(X,1),size(X,1));

for r = 1:size(X,1)
    for s = 1:size(X,1)
        kernel_matrix(r,s) = ker_calc(X(r,:),X(s,:),sigma_avg);
    end
end

end