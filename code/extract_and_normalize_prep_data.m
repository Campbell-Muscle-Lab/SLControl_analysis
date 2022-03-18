function extract_and_normalize_prep_data(varargin)

% This code takes a raw slr file (direct from analyse_slc_files),
% adds in fields for things like relative tension (where one needs
% to consider all the records from a given preparation) and outputs
% the structure into a specified sheet in an Excel file

% It is designed to be a simpler replacement for the old
% process_data_structure

% Set up parameters
params.data_file_string='';
params.extract_file_string='';
params.pCa90_normalizing_mode='nearest';
params.pCa45_normalizing_mode='nearest';
params.pCa90_normalizing_condition=[9.0 7.0 0.0 0.0];
params.pCa45_normalizing_condition=[4.5 7.0 0.0 0.0];
params.output_file_string='';
params.output_sheet='';

% Update
params=parse_pv_pairs(params,varargin);

% Variables

% Code

% Read in the data structure
original_data=read_structure_from_excel('filename',params.data_file_string, ...
    'debug_mode',1);

% Find the number of preparations in the data structure
preps=unique(original_data.directory);

% Open up the extract file and load in the conditions you need
d=read_structure_from_excel( ...
    'filename',params.extract_file_string);
extract_conditions = [d.pCa d.pH d.ADP d.Pi];
[no_of_extract_conditions,temp]=size(extract_conditions);

% Prepare a new processed_data structure
processed_data=[];
processed_entries=0;

% Prepare a variable to hold run_down data
run_down_data=[];

% Cycle through the preps one at a time
for prep_counter=1:length(preps)
    
% if (prep_counter>1)
%     break
% end
% 
    % Create a new structure with data from a single prep
    prep_data=original_data;
    prep_indices=find(strcmp([ ...
        original_data.directory],preps{prep_counter}));
    field_names=fieldnames(original_data);
    for field_counter=1:length(field_names)
        prep_data.(field_names{field_counter}) = ...
            prep_data.(field_names{field_counter})(prep_indices);
    end
        
    % Sort prep_data by file index number
    [temp,sort_order]=sort_by_slc_index('file_strings',prep_data.file);
    for field_counter=1:length(field_names)
         prep_data.(field_names{field_counter}) = ...
            prep_data.(field_names{field_counter})(sort_order);
    end
    
   % Generate the prep_conditions_matrix
    prep_conditions=[prep_data.pCa prep_data.pH ...
        prep_data.ADP prep_data.Pi];

    % Find the pCa90 and pCa45 indices for normalization
    pCa90_indices=find_matching_indices(prep_conditions, ...
        params.pCa90_normalizing_condition);
    pCa45_indices=find_matching_indices(prep_conditions, ...
        params.pCa45_normalizing_condition);
    
    % Do some error checking here
    
    % Cycle through the prep files adding in relative values
    % and the absolute force
    for file_counter=1:length(prep_indices)
        
        % Do the absolute force first
        
        % Absolute force
        prep_data.area(file_counter)=prep_data.area(1);
        prep_data.abs_force(file_counter) = ...
            prep_data.P_ss(file_counter) * prep_data.area(file_counter);
        
        % Deduce pCa 9.0 and pCa 4.5 conditions
        if (strcmp(params.pCa90_normalizing_mode,'interpolation'))
            % P_ss
            out = fit_linear_model( ...
                pCa45_indices,prep_data.P_ss(pCa90_indices));
            P_ss_90 = out.intercept + file_counter*out.slope;
            
            if (isfield(prep_data, 'SREC_YM1_SL'))
                % SREC_YM1_SL
                if (~isnan(prep_data.SREC_YM1_SL(pCa90_indices(1))))
                    out = fit_linear_model( ...
                        pCa90_indices,prep_data.SREC_YM1_SL(pCa90_indices));
                    SREC_YM1_SL_90 = out.intercept + file_counter*out.slope;
                else
                    SREC_YM1_SL_90 = NaN;
                end

                % SREC_YM1_FL
                out = fit_linear_model( ...
                    pCa90_indices,prep_data.SREC_YM1_FL(pCa90_indices));
                SREC_YM1_FL_90 = out.intercept + file_counter*out.slope;
            end
        else
            pCa90_trial=set_normalizing_trial_number(file_counter, ...
                pCa90_indices,params.pCa90_normalizing_mode);
            P_ss_90 = prep_data.P_ss(pCa90_trial);
            
            if (isfield(prep_data, 'SREC_YM1_SL'))
                SREC_YM1_SL_90 = prep_data.SREC_YM1_SL(pCa90_trial);
                SREC_YM1_FL_90 = prep_data.SREC_YM1_FL(pCa90_trial);
            end
        end
        
        if (strcmp(params.pCa45_normalizing_mode,'interpolation'))
            % P_ss
            out = fit_linear_model( ...
                pCa45_indices,prep_data.P_ss(pCa45_indices));
            P_ss_45 = out.intercept + file_counter*out.slope;
            
            % k_half
            out = fit_linear_model( ...
                pCa45_indices,prep_data.k_half(pCa45_indices));
            k_half_45 = out.intercept + file_counter*out.slope;
            
            % k_tr
            out = fit_linear_model( ...
                pCa45_indices,prep_data.k_tr(pCa45_indices));
            k_tr_45 = out.intercept + file_counter*out.slope;
            
            % SREC_YM1_SL
            if (isfield(prep_data, 'SREC_YM1_SL'))
                if (~isnan(prep_data.SREC_YM1_SL(pCa45_indices(1))))
                    out = fit_linear_model( ...
                        pCa45_indices,prep_data.SREC_YM1_SL(pCa45_indices));
                    SREC_YM1_SL_45 = out.intercept + file_counter*out.slope;
                else
                    SREC_YM1_SL_45 = NaN;
                end
            
                % SREC_YM1_FL
                out = fit_linear_model( ...
                    pCa45_indices,prep_data.SREC_YM1_FL(pCa45_indices));
                SREC_YM1_FL_45 = out.intercept + file_counter*out.slope;
            end
        else
            pCa45_trial=set_normalizing_trial_number(file_counter, ...
                pCa45_indices,params.pCa45_normalizing_mode);
            P_ss_45 = prep_data.P_ss(pCa45_trial);
            k_half_45 = prep_data.k_half(pCa45_trial);
            k_tr_45 = prep_data.k_tr(pCa45_trial);
            
            if (isfield(prep_data, 'SREC_YM1_SL'))
                SREC_YM1_SL_45 = prep_data.SREC_YM1_SL(pCa45_trial);
                SREC_YM1_FL_45 = prep_data.SREC_YM1_FL(pCa45_trial);
            end
        end
        
        % Relative values
        prep_data.rel_ten(file_counter) = ...
            prep_data.P_ss(file_counter) / P_ss_45;
            
        prep_data.Ca_act_ten(file_counter) = ...
            prep_data.P_ss(file_counter) - P_ss_90;
            
        prep_data.rel_Ca_act_ten(file_counter) = ...
            prep_data.Ca_act_ten(file_counter) / ...
                (P_ss_45 - P_ss_90);
                
        prep_data.rel_k_half(file_counter) = ...
            prep_data.k_half(file_counter) / k_half_45;
            
        prep_data.rel_k_tr(file_counter) = ...
            prep_data.k_tr(file_counter) / k_tr_45;
            
        % Relative residual
        if (abs(prep_data.P_ss(file_counter)-P_ss_90)>0)
            prep_data.rel_resid(file_counter) = ...
                ((prep_data.resid(file_counter) * ...
                       prep_data.P_ss(file_counter)) - P_ss_90) / ...
                    prep_data.Ca_act_ten(file_counter);
        else
            prep_data.rel_resid(file_counter)=NaN;
        end
        
        % Run-down
        if (prep_data.pCa(file_counter)==4.5)
            prep_data.run_down(file_counter) = ...
                -(prep_data.P_ss(file_counter)-prep_data.P_ss(pCa45_indices(1))) / ...
                    prep_data.P_ss(pCa45_indices(1));
        else
            prep_data.run_down(file_counter) = NaN;
        end

        % Calculate relative stiffness and SREC f values
        % if the data exists
        if (isfield(prep_data,'SREC_YM1_SL'))
            
            % Stiffness values
            prep_data.SREC_YM1_SL_to_90(file_counter) = ...
                prep_data.SREC_YM1_SL(file_counter) / ...
                    SREC_YM1_SL_90;
            prep_data.SREC_YM1_FL_to_90(file_counter) = ...
                prep_data.SREC_YM1_FL(file_counter) / ...
                    SREC_YM1_FL_90;                
            prep_data.SREC_YM1_SL_to_45(file_counter) = ...
                prep_data.SREC_YM1_SL(file_counter) / ...
                    SREC_YM1_SL_45;
            prep_data.SREC_YM1_FL_to_45(file_counter) = ...
                prep_data.SREC_YM1_FL(file_counter) / ...
                    SREC_YM1_FL_45;

            % Short-range forces
            prep_data.SREC_f1_to_P_ss(file_counter) = ...
               prep_data.SREC_f1(file_counter) / ...
                    prep_data.P_ss(file_counter);
            prep_data.SREC_f1_to_Ca_act_ten(file_counter) = ...
               prep_data.SREC_f1(file_counter) / ...
                    prep_data.Ca_act_ten(file_counter);
        end

    end
    
    % Update run_down data
    prep_data.final_run_down(1:length(prep_indices)) = ...
        prep_data.run_down(pCa45_indices(end))*ones(length(prep_indices),1);
        
    % Cycle through the extract conditions,
    % find which indexes match the chosen condition
    % and put the first match in a holder
    
    holder=[];
        
    for condition_counter=1:no_of_extract_conditions
        vi=find_matching_indices(prep_conditions, ...
            extract_conditions(condition_counter,:));
    
        if (length(vi)>0)
            holder=[holder vi(1)];
        end
    end

    % Take the prep_data with indices from the holder and
    % add the terms in to the processed_data structure
    field_names=fieldnames(prep_data);
    for field_counter=1:length(field_names)
        for entry_counter=1:length(holder)
            processed_data.(field_names{field_counter}) ...
                    (processed_entries+entry_counter) = ...
                prep_data.(field_names{field_counter}) ...
                  (holder(entry_counter));
        end
    end
    processed_entries=processed_entries+length(holder);
end

% Write to excel sheet
write_structure_to_excel('filename',params.output_file_string, ...
    'sheet',params.output_sheet, ...
    'structure',processed_data)

% End of main function code

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NESTED FUNCTIONS
    
    function normalizing_trial=set_normalizing_trial_number(test_trial, ...
        possible_indices,mode)
    
        % Returns the appropriate trial for normalization
        % It's used to find the desired pCa 9.0 and pCa 4.5 trials
        % to compare records to
        
        switch (mode)
            case 'first'
                normalizing_trial=possible_indices(1);
            case 'last'
                normalizing_trial=possible_indices(end);
            case 'nearest'
                index_difference=abs(test_trial-possible_indices);
                [temp,ii]=min(index_difference);
                normalizing_trial=possible_indices(ii);
            case 'prevailing'
                ii=find(test_trial>=possible_indices,1,'last');
                if (length(ii)==0)
                    normalizing_trial=possible_indices(end);
                else
                    normalizing_trial=possible_indices(ii);
                end
            case 'min_tension'
                [temp,ii]=min(prep_data.P_ss(possible_indices));
                normalizing_trial=possible_indices(ii);
            case 'max_tension'
                [temp,ii]=max(prep_data.P_ss(possible_indices));
                normalizing_trial=possible_indices(ii);
            otherwise
                error(['Invalid normalizing mode in ' ...
                    'set_normalizing_trial_number()']);
        end
    end

end

