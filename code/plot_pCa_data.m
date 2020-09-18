function plot_pCa_data(varargin)
% Plots pCa data

% Defaults
params.data_file_string = '';
params.type_string = '';
params.sample_string = '';
params.output_file_string = '';

% Update
params = parse_pv_pairs(params,varargin);

% Code
if (strcmp(params.type_string,'Preps'))
    pCa_sheet_string = 'pCa_prep';
    summary_sheet_string = 'summary_prep';
else
    pCa_sheet_string = 'pCa_tag';
    summary_sheet_string = 'summary_tag';
end

% Load pCa data
d_pCa = read_structure_from_excel('filename',params.data_file_string, ...
        'sheet',pCa_sheet_string);

% See how many samples there are
if (iscell(params.sample_string))
    no_of_samples = numel(params.sample_string)
else
    no_of_samples = 1;
end

progress_bar(0);
for i=1:no_of_samples
    progress_bar(i/no_of_samples, ...
        sprintf('Sample %.0f of %.0f',i,no_of_samples));
    
    if (no_of_samples>1)
        sample_string = params.sample_string{i};
    else
        sample_string = params.sample_string;
    end
    
ss = sample_string    
    
    pCa = d_pCa.pCa;
    fs = sprintf('P_ss_%s',sample_string);
    y = d_pCa.(fs);

    % Load summary data
    d = read_structure_from_excel('filename',params.data_file_string, ...
            'sheet',summary_sheet_string);

    % Find the right row in the summary file
    ri = regexp(sample_string,'_');
    id_string = sample_string((ri(end)+1):end);
    if (strcmp(params.type_string,'Preps'))
        vi = find(strcmp(d.prep,id_string));
    else
        vi = find(strcmp(d.tag,id_string));
    end

    % Construct a fit curve
    n = d.n(vi)
    pCa50 = d.pCa50(vi)
    pCa_offset = d.pCa_offset(vi)
    pCa_scaling_factor = d.pCa_scaling_factor(vi)
    r_squared = d.r_squared(vi)

    pCa_x_fit = linspace(9.0,4.0,100);
    for j=1:numel(pCa_x_fit)
        pCa_y_fit(j) = pCa_offset + pCa_scaling_factor * ...
            ((10^-pCa_x_fit(j)))^n / ...
                (((10^-pCa_x_fit(j)))^n + ((10^-pCa50))^n);
    end

    % Display
    figure(51);
    clf;

    sp = initialise_publication_quality_figure( ...
            'right_margin',4, ...
            'x_to_y_axes_ratio',1, ...
            'no_of_panels_wide',1, ...
            'no_of_panels_high',1, ...
            'axes_padding_left',1.2, ...
            'axes_padding_right',0.5, ...
            'top_margin',0.3, ...
            'axes_padding_bottom',0.3);

    plot(pCa,y,'bo');
    hold on;
    plot(pCa_x_fit,pCa_y_fit,'r-');
    set(gca,'XDir','reverse');
    x_limits = xlim;    
    y_limits = ylim;

    text_string = sprintf('n=%g\npCa_{50}=%g\nr^2=%g',n,pCa50,r_squared);
    text(x_limits(end)-0.5,mean(y_limits),text_string);
    xlabel('pCa');
    ylabel({'Stress','(N m^{-2})'});
    
    title(sample_string,'Interpreter','none');
    
    [path_string,file_name,ext]=fileparts(params.output_file_string);
    temp_output_string{i} = fullfile(path_string, ...
        sprintf('%s_%.0f',file_name,i));
    output_string{i} = sprintf('%s.pdf',temp_output_string{i});
    figure_export('output_file_string',temp_output_string{i}, ...
        'output_type','pdf');
end

% Merge pdfs
delete(params.output_file_string);
append_pdfs(params.output_file_string,output_string{:});

% Delete temp files
for i=1:numel(output_string)
    disp(sprintf('Deleting %s',output_string{i}))
    delete(output_string{i});
end

