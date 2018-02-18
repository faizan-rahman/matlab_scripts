function [output] = kernel_k_means(data,k,K_mat)

% data is the dataset
% k is the number of clusters
% K_mat is the kernel matrix of the dataset

X = data;
rep = 1;
final_label = zeros(size(X,1),rep);
total_dist = zeros(rep,1);


for g = 1:rep
    
    dist = zeros(size(X,1),k);
    converged = 0;
    
    numOnes = 1;
    rows = size(X,1);
    columns = k;
    final_assignments = zeros(rows, columns);
    for row = 1 : rows
        oneLocations = randperm(columns, numOnes);
        final_assignments(row, oneLocations) = 1;
    end
    
    Ck = sum(final_assignments,1);
    centroid = zeros(k,size(X,2));
    
    while ~converged
        
        
        for j = 1:k
            dist(:,j) = diag(K_mat) -(2/(Ck(j)))*sum(repmat(final_assignments(:,j)',size(X,1),1).*K_mat,2) + ...
                Ck(j)^(-2)*sum(sum((final_assignments(:,j)*final_assignments(:,j)').*K_mat));
        end
        oldfinal_assignments = final_assignments;
        final_assignments = (dist == repmat(min(dist,[],2),1,k));
        final_assignments = double(final_assignments);
        Ck = sum(final_assignments,1);
        
        for i = 1:k
            clust_idx = find(final_assignments(:,i) == 1);
            centroid(i,:) = mean(X(clust_idx,:));
        end
        
        if sum(sum(oldfinal_assignments~=final_assignments))==0
            converged = 1;
        end
        
    end
    
    
    f_label = zeros(size(X,1),1);
    
    for i = 1:size(final_assignments,1)
        f_label(i) = find(final_assignments(i,:) == 1);
    end
    
    % checking for empty clusters
    
    emp_clust = zeros(k,1);
    dist_add = zeros(k,1);
    
    for i = 1:k
        emp_clust(i) = ismember(i,f_label);
        if emp_clust(i) == 0
            emp_idx = randperm(size(X,1));
            f_label(emp_idx(1)) = i;
        end
            temp1 = find(final_assignments(:,i) == 1);
            for u = 1:size(temp1,1)
                dist_add(i) = dist_add(i) + dist(temp1(u),i);
            end
        total_dist(g,1) = sum(dist_add);
    end
    
    final_label(:,g) = f_label;
   
end

% selecting the best result from multiple iterations called rep

[temp2,temp2ind] = min(total_dist);
output = final_label(:,temp2ind);

end

