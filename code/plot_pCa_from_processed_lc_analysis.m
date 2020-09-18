function plot_pCa_from_processed_lc_analysis(lc_excel_file_string,varargin)

v = varargin

% Set up inputs
p = inputParser;
addRequired(p,'lc_excel_file_string');
addOptional(p,'excel_sheet','averaged_prep');
addOptional(p,'pCa_field_string','pCa');
addOptional(p,'field_string','rel_ten');
addOptional(p,'error_string','SEM');
addOptional(p,'line_colors',[0 0 0]);
addOptional(p,'figure_number',13);

% Parse the inputs
parse(p,lc_excel_file_string,varargin{:});

% Code

% Load Excel data
d = read_structure_from_excel( ...
        'filename',p.Results.lc_excel_file_string, ...
        'sheet',p.Results.excel_sheet)
    
% Set value and error field_strings
value_field_string = ...
    sprintf('Mean_%s',p.Results.field_string);
error_field_string = ...
    sprintf('%s_%s',p.Results.error_string,p.Results.field_string);
    
% Find factor_1 and factor_2 strings
f1_strings = unique(d.factor_1);
f2_strings = unique(d.factor_2);

% Cycle through all combinations of f1_string and f2_string
dataset_counter = 0;
for f1_counter = 1:numel(f1_strings)
    for f2_counter = 1:numel(f2_strings)
        
        dataset_counter = dataset_counter+1;
        
        vi = find( ...
                strcmp(d.factor_1,f1_strings{f1_counter}) & ...
                strcmp(d.factor_2,f2_strings{f2_counter}));
            
        pCa_values = d.(p.Results.pCa_field_string)(vi);
        x_data(dataset_counter).mean_values = pCa_values;
        x_data(dataset_counter).error_values = zeros(size(pCa_values));
        
        y_values = d.(value_field_string)(vi);
        y_errors = d.(error_field_string)(vi);
        
        y_data(dataset_counter).mean_values = y_values;
        y_data(dataset_counter).error_values = y_errors;
        
        % Fit Hill curve
        [pCa50(dataset_counter),n(dataset_counter), ...
            scaling_factor(dataset_counter),offset(dataset_counter), ...
            r_squared(dataset_counter), ...
            x_fit{dataset_counter},y_fit{dataset_counter}] = ...
                fit_Hill_curve(pCa_values,y_values);
    end
end
no_of_datasets = dataset_counter;

% Make the figure
figure(p.Results.figure_number);
clf;

plot_with_error_bars( ...
    'x_data',x_data, ...
    'y_data',y_data);
    
hold on;

for i=1:no_of_datasets
    plot(x_fit{i},y_fit{i},'b-');
end



