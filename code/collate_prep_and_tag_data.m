function collate_prep_and_tag_data(varargin)

params.data_file_string = [];
params.output_file_string = [];
params.processed_sheet = 'dumped_prep';
params.extract_file_string = [];
params.pCa90_normalizing_mode = [];
params.pCa45_normalizing_mode = [];
params.pCa_data_field_string = 'rel_Ca_act_ten';
params.pCa90_normalizing_condition = [];
params.pCa45_normalizing_condition = [];

% Update
params = parse_pv_pairs(params,varargin);

% Code

if 1
% Delete the output file if it's there
try
    delete(params.output_file_string);
catch
end

% First calculate normalized data for each prep
progress_bar(0.1,'Collating prep and tag data');
extract_and_normalize_prep_data( ...
    'data_file_string',params.data_file_string, ...
    'extract_file_string',params.extract_file_string, ...
    'pCa90_normalizing_mode',params.pCa90_normalizing_mode, ...
    'pCa45_normalizing_mode',params.pCa45_normalizing_mode, ...
    'pCa90_normalizing_condition',params.pCa90_normalizing_condition, ...
    'pCa45_normalizing_condition',params.pCa45_normalizing_condition, ...
    'output_file_string',params.output_file_string, ...
    'output_sheet',params.processed_sheet);

% Delete default sheets
progress_bar(0.2,'Deleting default excel sheets');
delete_excel_sheets('filename',params.output_file_string);

% Calculate average, sd, sem, and n for data
progress_bar(0.3,'Averaging processed data');
average_processed_data( ...
    'input_file_string',params.output_file_string, ...
    'extract_file_string',params.extract_file_string);
end

% Pull out y verus pCa data
progress_bar(0.4,'Extracting tension pCa data');
calculate_pCa_curves( ...
    'data_file_string',params.output_file_string, ...
    'field_string',params.pCa_data_field_string);

% Finished
progress_bar(1);
msgbox(sprintf('Data summarized in %s',params.output_file_string));



