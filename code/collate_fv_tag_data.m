function collate_fv_tag_data(varargin)
% Collates data

params.data_file_string = '';
params.prep_summary_sheet = 'summary_prep';
params.tag_summary_sheet = 'summary_tag';

% Update
params = parse_pv_pairs(params,varargin);

% Code

% Read data
d = read_structure_from_excel('filename',params.data_file_string, ...
        'sheet',params.prep_summary_sheet);
    
% Check for numeric tags
if (isnumeric(d.tag))
    for i=1:numel(d.tag)
        d.temp{i}=num2str(d.tag(i));
    end
    d.tag = d.temp;
end

field_names = fieldnames(d);
    
unique_f1 = unique(d.factor_1);
unique_f2 = unique(d.factor_2);

entry_counter=0;
for f1=1:numel(unique_f1)
    for f2=1:numel(unique_f2)
        vf = find(strcmp(d.factor_1,unique_f1{f1}) & ...
                strcmp(d.factor_2,unique_f2{f2}));
        
        unique_tags = unique(d.tag(vf));
        
        for t=1:numel(unique_tags)
            vt = find(strcmp(d.tag,unique_tags{t}));
            
            vi = intersect(vf,vt);
            
            if (numel(vi)>0)
                entry_counter=entry_counter+1;
         
                % Store data
                out.factor_1{entry_counter} = unique_f1{f1};
                out.factor_2{entry_counter} = unique_f2{f2};
                out.tag{entry_counter} = unique_tags{t};
                
                for i=1:numel(field_names)
                    % Skip cell arrays
                    if (iscell(d.(field_names{i})))
                        continue;
                    end
        
                    % Calculate stats
                    s = summary_stats(d.(field_names{i})(vi));
                    
                    fn = sprintf('Mean_%s',field_names{i});
                    out.(fn)(entry_counter) = s.mean;
                    fn = sprintf('SD_%s',field_names{i});
                    out.(fn)(entry_counter) = s.sd;
                    fn = sprintf('SEM_%s',field_names{i});
                    out.(fn)(entry_counter) = s.sem;
                    fn = sprintf('n_%s',field_names{i});
                    out.(fn)(entry_counter) = s.n;
                end
            end
        end
    end
end

% Write data
write_structure_to_excel('filename',params.data_file_string, ...
    'sheet',params.tag_summary_sheet, ...
    'structure',out);
