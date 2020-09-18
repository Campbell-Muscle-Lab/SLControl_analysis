function [sorted_strings,sort_order]=sort_by_slc_index(varargin)

% This function takes strings of the form
% {'c:\temp\ken_03.slc' , 'c:\temp\ken_010.slc'}
% and sorts them by the index number (the numbers after the last '_')

params.file_strings='';
params.sort_order='ascend';

% Update
params=parse_pv_pairs(params,varargin);

% Code
no_of_strings=length(params.file_strings);

% Cycle through them extracting the indices
for i=1:no_of_strings
    % Find underscores if any and only look at text after the last one
    params.file_strings{i};
    ii=regexp(params.file_strings{i},'_');
    if (length(ii)>0)
        temp_string=params.file_strings{i}(ii(end)+1:end);
    else
        temp_string=params.file_strings{i};
    end
    % Now extract numbers
    ii=regexp(temp_string,'[0-9]');
    % if there is more than one digit in the string, e.g. 'step2-34'
    % take only the consecutive ones e.g. '34'
    if (length(ii)>0)
        ii=[ii(diff(ii)==1) ii(end)];
    end
    temp_string=temp_string(ii);
    
    index(i)=str2double(temp_string);
end

[sorted_indices,sort_order]=sort(index,params.sort_order);

sorted_strings=params.file_strings{sort_order};






    


