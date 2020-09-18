function vi=find_matching_indices(candidate_conditions,test_condition)
    
% Code returns row numbers of candidate_conditions (a matrix with columns
% equal to [pCa pH ADP Pi] ) which match the test condition

% Code

% replace pH NaNs by 7.0 for easier equality testing
candidate_conditions(isnan(candidate_conditions(:,2)),2)=7.0;

% replace ADP and Pi NaNs by 0.0 for easier equality testing
candidate_conditions(isnan(candidate_conditions(:,3)),3)=0.0;
candidate_conditions(isnan(candidate_conditions(:,4)),4)=0.0;

% cycle through the candidate questions, checking whether it matches
% the test
vi=[];
[rows,cols]=size(candidate_conditions);

for i=1:rows
    if (isequal(candidate_conditions(i,:),test_condition))
        vi=[vi i];
    end
end
