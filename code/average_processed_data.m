function average_processed_data(varargin)
% Code takes raw data and calculates averages for prep and tag for each
% combination of factor 1 and factor 2

% Set up defaults
params.input_file_string='';
params.input_sheet='dumped_prep';
params.extract_file_string='';
params.ionic_condition_field_names={'pCa','pH','ADP','Pi'};

% Update
params=parse_pv_pairs(params,varargin);

% Code

% Read in data
d = read_structure_from_excel( ...
        'filename',params.input_file_string, ...
        'sheet',params.input_sheet);
field_names = fieldnames(d);

% Check for numeric tags
if (isnumeric(d.tag))
    for i=1:numel(d.tag)
        d.temp{i}=num2str(d.tag(i));
    end
    d.tag = d.temp;
end
    
% Create file condition matrix
cm = [d.pCa d.pH d.ADP d.Pi];

% Read in extract conditions
c = read_structure_from_excel('filename',params.extract_file_string);
ec = [c.pCa c.pH c.ADP c.Pi];
[no_of_ec,temp]=size(ec);

% Find factors
unique_f1s = unique(d.factor_1);
unique_f2s = unique(d.factor_2);
   
% Set counters for averaged and dumped_tag structures
ai=0;
di=0;
% Averaged prep and averaged tag structures
ap = [];
at = [];
dt = [];

% Find files that match both factors and each muscle type
for f1 = 1:numel(unique_f1s)

    for f2 = 1:numel(unique_f2s)

        vi_f = find( ...
                strcmp(d.factor_1,unique_f1s{f1}) & ...
                strcmp(d.factor_2,unique_f2s{f2}));

        % Cycle through extraction conditions
        for e = 1:no_of_ec

            vi_c = find_matching_indices(cm,ec(e,:));

            % Find matching indices
            vi = intersect(vi_f,vi_c);
            
           if (numel(vi)>0)
                % We have data that matches a combination of factors and
                % an ionic condition
                
                % Increment the average counter
                ai=ai+1;

                ap.factor_1{ai} = unique_f1s{f1};
                ap.factor_2{ai} = unique_f2s{f2};

                at.factor_1{ai} = unique_f1s{f1};
                at.factor_2{ai} = unique_f2s{f2};

                % Find the unique tags
                ut = unique(d.tag(vi));

                % Add in the factor data for the dumped_tags
                for i=1:numel(ut)
                    dt.factor_1{di+i} = unique_f1s{f1};
                    dt.factor_2{di+i} = unique_f2s{f2};
                    dt.tag{di+i} = ut{i};
                end
               
                % Cycle through field_names
                for fn = 1:numel(field_names)

                    % Discard strings
                    if (iscellstr(d.(field_names{fn})))
                        continue
                    end

                    % Field is data
                    if (any(strcmp(params.ionic_condition_field_names, ...
                            field_names{fn})))
                        % Ionic
                        ap.(field_names{fn})(ai) = ...
                            d.(field_names{fn})(vi(1));
                        at.(field_names{fn})(ai) = ap.(field_names{fn})(ai);
                        
                        for i=1:numel(ut)
                            dt.(field_names{fn})(di+i) = ...
                                ap.(field_names{fn})(ai);
                        end
                    else
                        % Calculate and store average of the preps
                        x = d.(field_names{fn})(vi);
                        s = summary_stats(x);
                        
                        fs = sprintf('Mean_%s',field_names{fn});
                        ap.(fs)(ai) = s.mean;
                        fs = sprintf('SD_%s',field_names{fn});
                        ap.(fs)(ai) = s.sd;
                        fs = sprintf('SEM_%s',field_names{fn});
                        ap.(fs)(ai) = s.sem;
                         fs = sprintf('n_%s',field_names{fn});
                        ap.(fs)(ai) = s.n;
                        
                        % Calculate the tag data
                        % First construct a vector holding the mean of
                        % data for each tag
                        % Store the dumped_tag as we go
                        h=[];
                        for i=1:numel(ut)
                            vt = strcmp(d.tag(vi),ut{i});
                            h(i) = nanmean(x(vt));
                            dt.(field_names{fn})(di+i) = h(i);
                        end
                        s = summary_stats(h);
                        fs = sprintf('Mean_%s',field_names{fn});
                        at.(fs)(ai) = s.mean;
                        fs = sprintf('SD_%s',field_names{fn});
                        at.(fs)(ai) = s.sd;
                        fs = sprintf('SEM_%s',field_names{fn});
                        at.(fs)(ai) = s.sem;
                        fs = sprintf('n_%s',field_names{fn});
                        at.(fs)(ai) = s.n;
                    end
                end
                
            % Increment the di counter
            di = di + numel(ut);
            end
            
        end
    end
end

% Output
write_structure_to_excel( ...
    'filename',params.input_file_string, ...
    'sheet','dumped_tag', ...
    'structure',dt);

write_structure_to_excel( ...
    'filename',params.input_file_string, ...
    'sheet','averaged_prep', ...
    'structure',ap);

write_structure_to_excel( ...
    'filename',params.input_file_string, ...
    'sheet','averaged_tag', ...
    'structure',at);

return
                            
                            
                        
                    
                    
                    
                
%                 
%                 
%                 
% 
% 
% 
% 
%     
% 
%                 if (length(ionic_field_matches)>0)
%                     % Field is an ionic condition
%                     averaged_prep_data. ...
%                         (field_names{field_counter})(entry_counter) = ...
%                             extract_conditions(extract_counter, ...
%                                 ionic_field_matches);
%                     averaged_tag_data. ...
%                         (field_names{field_counter})(entry_counter) = ...
%                             extract_conditions(extract_counter, ...
%                                 ionic_field_matches);
% 
%                     % Add in ionic fields
%                     % Make the field first if appropriate
%                     if (~isfield(dumped_tag_data,(field_names{field_counter})))
%                         dumped_tag_data.(field_names{field_counter})=[];
%                     end
%                     dumped_tag_data.(field_names{field_counter}) = ...
%                         [dumped_tag_data.(field_names{field_counter}) ...
%                             extract_conditions(extract_counter, ...
%                                 ionic_field_matches)* ...
%                                     ones(1,length(unique_tags))];
% 
%                 else
%                     % Field is experimental data
% 
%                     % Extract all the data
%                     d = original_data.(field_names{field_counter})(vi);
% 
%                     % Discard fields that are strings
%                     if (~iscellstr(d))
% 
%                         mean_field_string = ...
%                             sprintf('Mean_%s',field_names{field_counter});
%                         sd_field_string = ...
%                             sprintf('SD_%s',field_names{field_counter});
%                         sem_field_string = ...
%                             sprintf('SEM_%s',field_names{field_counter});
%                         n_field_string = ...
%                             sprintf('n_%s',field_names{field_counter});
% 
%                         [averaged_prep_data. ...
%                                 (mean_field_string)(entry_counter), ...
%                             averaged_prep_data. ...
%                                 (sd_field_string)(entry_counter), ...
%                             averaged_prep_data. ...
%                                 (sem_field_string)(entry_counter), ...
%                             averaged_prep_data. ...
%                                 (n_field_string)(entry_counter)] = ...
%                                     mean_sd_sem_and_n(d);
% 
%                         % Average data for each tag and hold that both in
%                         % a dumped data structure and in a holder
%                         h=[];
%                         % Create the field if required
%                         if (~isfield(dumped_tag_data,field_names{field_counter}))
%                             dumped_tag_data.(field_names{field_counter})=[];
%                         end
%                         for tag_counter=1:length(unique_tags)
%                             vi2=find(strcmp([original_data.tag(vi)], ...
%                                 unique_tags{tag_counter}));
% 
%                             dumped_tag_data.(field_names{field_counter}) = ...
%                                 [dumped_tag_data.(field_names{field_counter}) ...
%                                     mean(d(vi2))];
% 
%                             h=[h mean(d(vi2))];
%                         end
% 
%                         % Now update that structure
%                         [averaged_tag_data. ...
%                                 (mean_field_string)(entry_counter), ...
%                             averaged_tag_data. ...
%                                 (sd_field_string)(entry_counter), ...
%                             averaged_tag_data. ...
%                                 (sem_field_string)(entry_counter), ...
%                             averaged_tag_data. ...
%                                 (n_field_string)(entry_counter)] = ...
%                                     mean_sd_sem_and_n(h);
%                     end
%                 end
%             end
%         end
%     end
% end
% 
% % Output data
% write_structure_to_excel('filename',params.input_file_string, ...
%     'sheet',params.averaged_prep_output_sheet, ...
%     'structure',averaged_prep_data);
% write_structure_to_excel('filename',params.input_file_string, ...
%     'sheet',params.dumped_tag_output_sheet, ...
%     'structure',dumped_tag_data);
% write_structure_to_excel('filename',params.input_file_string, ...
%     'sheet',params.averaged_tag_output_sheet, ...
%     'structure',averaged_tag_data);
