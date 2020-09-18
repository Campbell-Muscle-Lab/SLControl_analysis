function create_averaged_result_files(varargin)

% This code takes a processed slr file (created by process_raw_slr_file)
% and collates results from it. Two output files are created. One in which
% data is averaged with each prep being a single n value. This is
% appropriate, for example, when experiments are testing the effects of
% different metabolite conditions and each fiber is considered to be 'the
% same'. The second output file is created by averaging all of the values
% for each ID_tag and then averaging these. This would be appropriate when,
% for example, you had 2 groups of animals (for example, smoking and
% non-smoking) and multiple preps from each animal

% Set up defaults
params.input_file_string='c:\ken\temp\gui_testing\processed\temp.slr';
params.input_sheet='processed_slr';
params.extract_file_string='extract\control_pCa.txt';
params.ionic_condition_field_names={'pCa','pH','ADP','Pi'};
params.averaged_prep_output_sheet='averaged_prep';
params.averaged_tag_output_sheet='averaged_tag';
params.dumped_tag_output_sheet='dumped_tag';

% Update
params=parse_pv_pairs(params,varargin);

% Code

% Read in the input data
original_data=read_structure_from_excel( ...
    'filename',params.input_file_string, ...
    'sheet',params.input_sheet);

% Create the file_condition_matrix
file_condition_matrix=[original_data.pCa original_data.pH ...
    original_data.ADP original_data.Pi];

% Find the filed_names
field_names=fieldnames(original_data);
no_of_field_names=length(field_names);

% Now create two structures - one to hold data from individual preps,
% the other to hold data averaged by tags.
averaged_prep_data=[];
averaged_tag_data=[];
dumped_tag_data=[];

% Read in the extract_conditions and cycle through them
extract_conditions=dlmread(params.extract_file_string,'\t',1,0);
[no_of_extract_conditions,temp]=size(extract_conditions);

% Index variable
for extract_counter=1:no_of_extract_conditions

    % Find vi, the indices that match the extract condition    
    vi=find_matching_indices(file_condition_matrix, ...
        extract_conditions(extract_counter,:));
   
    % Find the ID_tags
    unique_ID_tags=unique(original_data.ID_tag(vi));
    
    % Add in the tag field
    if (length(vi)>0)
        if (~isfield(dumped_tag_data,'ID_tag'))
            dumped_tag_data.ID_tag = [];
        end
        dumped_tag_data.ID_tag = [dumped_tag_data.ID_tag ...
            unique_ID_tags'];
    end    
    
    % Cycle through each of the fields in turn
    for field_counter=1:no_of_field_names

        % Test for ionic conditions
        ionic_field_matches=find(strcmp(field_names{field_counter}, ...
                    params.ionic_condition_field_names));
                
        if (length(ionic_field_matches)>0)
            % Field is an ionic condition
            averaged_prep_data. ...
                (field_names{field_counter})(extract_counter) = ...
                    extract_conditions(extract_counter, ...
                        ionic_field_matches);
            averaged_tag_data. ...
                (field_names{field_counter})(extract_counter) = ...
                    extract_conditions(extract_counter, ...
                        ionic_field_matches);
                    
            % Add in ionic fields
            % Make the field first if appropriate
            if (~isfield(dumped_tag_data,(field_names{field_counter})))
                dumped_tag_data.(field_names{field_counter})=[];
            end
            dumped_tag_data.(field_names{field_counter}) = ...
                [dumped_tag_data.(field_names{field_counter}) ...
                    extract_conditions(extract_counter, ...
                        ionic_field_matches)* ...
                            ones(1,length(unique_ID_tags))];
            
        else
            % Field is experimental data
            
            % Extract all the data
            d = original_data.(field_names{field_counter})(vi);

            % Discard fields that are strings
            if (~iscellstr(d))
                
                mean_field_string = ...
                    sprintf('Mean_%s',field_names{field_counter});
                sd_field_string = ...
                    sprintf('SD_%s',field_names{field_counter});
                sem_field_string = ...
                    sprintf('SEM_%s',field_names{field_counter});
                n_field_string = ...
                    sprintf('n_%s',field_names{field_counter});

                [averaged_prep_data. ...
                        (mean_field_string)(extract_counter), ...
                    averaged_prep_data. ...
                        (sd_field_string)(extract_counter), ...
                    averaged_prep_data. ...
                        (sem_field_string)(extract_counter), ...
                    averaged_prep_data. ...
                        (n_field_string)(extract_counter)] = ...
                            mean_sd_sem_and_n(d);
                        
                % Average data for each ID_tag and hold that both in
                % a dumped data structure and in a holder
                h=[];
                % Create the field if required
                if (~isfield(dumped_tag_data,field_names{field_counter}))
                    dumped_tag_data.(field_names{field_counter})=[];
                end
                for tag_counter=1:length(unique_ID_tags)
                    vi2=find(strcmp([original_data.ID_tag(vi)], ...
                        unique_ID_tags{tag_counter}));
                    
                    dumped_tag_data.(field_names{field_counter}) = ...
                        [dumped_tag_data.(field_names{field_counter}) ...
                            mean(d(vi2))];

                    h=[h mean(d(vi2))];
                end

                % Now update that structure
                [averaged_tag_data. ...
                        (mean_field_string)(extract_counter), ...
                    averaged_tag_data. ...
                        (sd_field_string)(extract_counter), ...
                    averaged_tag_data. ...
                        (sem_field_string)(extract_counter), ...
                    averaged_tag_data. ...
                        (n_field_string)(extract_counter)] = ...
                            mean_sd_sem_and_n(h);
            end
        end
    end
end
        
params.averaged_prep_output_sheet='averaged_prep';
params.averaged_tag_output_sheet='averaged_tag';
params.dumped_tag_output_sheet='dumped_tag';


% Output data
write_structure_to_excel('filename',params.input_file_string, ...
    'sheet',params.averaged_prep_output_sheet, ...
    'structure',averaged_prep_data);
write_structure_to_excel('filename',params.input_file_string, ...
    'sheet',params.averaged_tag_output_sheet, ...
    'structure',averaged_tag_data);
write_structure_to_excel('filename',params.input_file_string, ...
    'sheet',params.dumped_tag_output_sheet, ...
    'structure',dumped_tag_data);
