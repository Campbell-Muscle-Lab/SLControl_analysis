function fv_analysis(varargin)

params.search_directory = '';
params.output_file_string = '';
params.include_string = '';
params.exclude_string = '';
params.pCa_value = [];
params.raw_sheet = 'fv_raw';

% Update
params = parse_pv_pairs(params,varargin);

% Code
progress_bar(0.1,'Analyzing individual *.slc records');
analyse_fv_slc_files( ...
    'search_directory',params.search_directory, ...
    'output_file_string',params.output_file_string, ...
    'include_tag',params.include_string, ...
    'exclude_tag',params.exclude_string, ...
    'pCa_value',params.pCa_value, ...
    'sheet',params.raw_sheet);

progress_bar(0.2,'Tidying excel file');
delete_excel_sheets('filename',params.output_file_string);

progress_bar(0.3,'Calculating force-velocity and power-force curves');
calculate_fv_curves( ...
    'data_file_string',params.output_file_string, ...
    'input_sheet',params.raw_sheet);

progress_bar(0.4,'Collating tag data');
collate_fv_tag_data( ...
    'data_file_string',params.output_file_string);

progress_bar(1);
msgbox(sprintf('Data written to %s',params.output_file_string));
