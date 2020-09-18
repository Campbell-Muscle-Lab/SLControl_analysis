function create_dumped_tension_files(varargin)

% Code extracts absolute P_ss values and rel_Ca_act_ten values
% from both the processed_slr_file (values dumped for all preps)
% and the dumped_tags file (average values for each ID_tag) and
% sends the data out to specified files

% Set defaults
params.input_file_string='';
params.processed_slr_sheet='processed_slr';
params.dumped_tag_sheet='dumped_tag';
params.extract_file_string='';
params.prep_abs_tensions_sheet='prep_abs_tensions';
params.prep_rel_tensions_sheet='prep_rel_tensions';
params.tag_abs_tensions_sheet='tag_abs_tensions';
params.tag_rel_tensions_sheet='tag_rel_tensions';

% Update
params=parse_pv_pairs(params,varargin);

% Code

% Loop through the basic program twice, once for prep_data and once
% for the tags

for loop_counter=1:2
    
    % Switch depending on whether we are dumping prep data or tags
    if (loop_counter==1)
        input_sheet=params.processed_slr_sheet
        output_abs_sheet=params.prep_abs_tensions_sheet;
        output_rel_sheet=params.prep_rel_tensions_sheet;
        
%         
%         input_file_string=params.input_processed_slr_file_string;
%         output_abs_file_string=params.output_prep_abs_tension_file_string;
%         output_rel_file_string=params.output_prep_rel_Ca_act_tension_file_string;
        extract_field='Directory';
    else
        input_sheet=params.dumped_tag_sheet;
        output_abs_sheet=params.tag_abs_tensions_sheet;
        output_rel_sheet=params.tag_rel_tensions_sheet;
        
%         input_file_string=params.input_tag_slr_file_string;
%         output_abs_file_string=params.output_tag_abs_tension_file_string;
%         output_rel_file_string=params.output_tag_rel_Ca_act_tension_file_string;
        extract_field='ID_tag';
    end

    % Create empty structures
    abs_ten_structure=[];
    rel_Ca_act_ten_structure=[];

    % Read in data
    d=read_structure_from_excel('filename',params.input_file_string, ...
        'sheet',input_sheet);

    % Extract prep_names
    extract_strings=unique(d.(extract_field));

    % Read in the extract_conditions
    extract_conditions=dlmread(params.extract_file_string,'\t',1,0);
    [no_of_extract_conditions,temp]=size(extract_conditions);

    % Now cycle through the preps
    for i=1:length(extract_strings)

        if (loop_counter==1)
            % Extract prep_dir
            temp_string=char(extract_strings{i});
            ii=regexp(temp_string,'\');
            new_field(i)=cellstr(temp_string(ii(end)+1:end));
        else
            new_field(i)=cellstr(extract_strings{i});
        end

        % Make fields in structures
        field_string=sprintf('f_%s',new_field{i});
        abs_ten_structure.(field_string) = ...
            NaN*ones(1,no_of_extract_conditions);
        rel_Ca_act_ten_structure.(field_string) = ...
            NaN*ones(1,no_of_extract_conditions);

        % Find the data associated with the prep
        vi=find(strcmp(d.(extract_field),extract_strings{i}));

        % Create a prep_data structure with the necessary fields
        extract_data=[];
        extract_data.pCa = d.pCa(vi);
        extract_data.pH = d.pH(vi);
        extract_data.ADP = d.ADP(vi);
        extract_data.Pi = d.Pi(vi);
        extract_data.P_ss = d.P_ss(vi);
        extract_data.rel_Ca_act_ten = d.rel_Ca_act_ten(vi);

        % Create a prep_condition_matrix
        extract_condition_matrix=[extract_data.pCa extract_data.pH ...
            extract_data.ADP extract_data.Pi];

        % Cycle through the extract matrix picking off the data
        for extract_counter=1:no_of_extract_conditions

            % Set up the dump
            abs_ten_structure.pCa(extract_counter) = ...
                extract_conditions(extract_counter,1);
            abs_ten_structure.pH(extract_counter) = ...
                extract_conditions(extract_counter,2);
            abs_ten_structure.ADP(extract_counter) = ...
                extract_conditions(extract_counter,3);
            abs_ten_structure.Pi(extract_counter) = ...
                extract_conditions(extract_counter,4);
            
            rel_Ca_act_ten_structure.pCa(extract_counter) = ...
                extract_conditions(extract_counter,1);
            rel_Ca_act_ten_structure.pH(extract_counter) = ...
                extract_conditions(extract_counter,2);
            rel_Ca_act_ten_structure.ADP(extract_counter) = ...
                extract_conditions(extract_counter,3);
            rel_Ca_act_ten_structure.Pi(extract_counter) = ...
                extract_conditions(extract_counter,4);
            
            % Look for matching data
            vi2=find_matching_indices(extract_condition_matrix, ...
                extract_conditions(extract_counter,:));

            if (length(vi2)>0)
                abs_ten_structure.(field_string)(extract_counter) = ...
                    extract_data.P_ss(vi2);
                rel_Ca_act_ten_structure.(field_string)(extract_counter) = ...
                    extract_data.rel_Ca_act_ten(vi2);
            end
        end
    end
    
    % Reorder fields so that metabolites comes first
    abs_ten_structure=orderfields(abs_ten_structure, ...
        [[2:5] 1 [6:length(extract_strings)+4]]);
    rel_Ca_act_ten_structure=orderfields(rel_Ca_act_ten_structure, ...
        [[2:5] 1 [6:length(extract_strings)+4]]);

    % Now dump the data to files
    write_structure_to_excel('filename',params.input_file_string, ...
        'structure',abs_ten_structure, ...
        'sheet',output_abs_sheet);
    write_structure_to_excel('filename',params.input_file_string, ...
        'structure',rel_Ca_act_ten_structure, ...
        'sheet',output_rel_sheet);
end

