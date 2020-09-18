function fv_analysis(varargin)

% Variables
params.search_directory='';
params.include_tag='';
params.exclude_tag='';
params.pCa_value='';
params.output_file_string='';
params.sheet='fv_raw';
params.fit_time_range=[0.3 0.95];
params.isometric_time_range=[0.01 0.03];
params.skip_files_shortening_beyond_ktr=1;
params.skip_files_with_stretching=1;
params.skip_sheet='skipped_files';
params.raw_figure=11;
params.fit_figure=12;

% Code

% Update variables
params=parse_pv_pairs(params,varargin);

% Find all slc files in the specified directory
all_files=findfiles('slc',params.search_directory,1);

% Display
progress_bar(0.1,sprintf('Finding %.0f SLControl files',numel(all_files)));

% Keep the ones that have the include_tag and
% do not have the exclude tag
slc_counter=0;
for all_counter=1:length(all_files)
    
    [~,file_name_string,~]=fileparts(all_files{all_counter});
    
    if (length(strfind(lower(file_name_string), ...
            lower(params.include_tag)))>0)
        if (length(strfind(lower(file_name_string), ...
                lower(params.exclude_tag)))==0)
            slc_counter=slc_counter+1;
            slc_files{slc_counter}=all_files{all_counter};
        end
    end
end

if (~isempty(params.pCa_value))
    % Scan through them and find the ones that match the pCa
    vi=[];
    for i=1:numel(slc_files)
        progress_bar(i/numel(slc_files),'Screening pCa values');
        d=load_slcontrol_file(slc_files{i},1);
        if (d.pCa == params.pCa_value)
            vi=[vi i];
        end
    end
else
    vi = 1:numel(slc_files);
end
slc_files = slc_files(vi)

% Empty output
output = [];

% Analyse
no_of_fv_files = numel(slc_files);

output_counter = 0;
skip_counter = 0;

for file_counter=1:no_of_fv_files
    progress_bar(file_counter/no_of_fv_files, ...
        sprintf('Analyzing %.0f files',no_of_fv_files));
    
    % Analyze file name and path
    [path_string,name,temp]= ...
        fileparts(slc_files{file_counter});
    
    ii=regexp(path_string,'\\');
    prep_string = path_string(ii(end)+1:end);
    tag_string=path_string(ii(end-1)+1:ii(end)-1);
    factor_2_string = path_string(ii(end-2)+1:ii(end-1)-1);
    factor_1_string = path_string(ii(end-3)+1:ii(end-2)-1);
    
    % Load and transform the data
    td=transform_slcontrol_record( ...
        load_slcontrol_file(slc_files{file_counter}));
    
    % Check to see whether the fl shortened too far - this indicates
    % the prep probably fell slack
    if (params.skip_files_shortening_beyond_ktr)
        ktr_index_start = find( ...
            td.time > (td.ktr_initiation_time+0.1*td.ktr_duration), ...
            1,'first');
        ktr_index_stop = find( ...
            td.time < (td.ktr_initiation_time+0.8*td.ktr_duration), ...
            1,'last');
        
        ktr_fl = mean(td.fl(ktr_index_start:ktr_index_stop));
        
        ktr_initiation_index = find( ...
            td.time < td.ktr_initiation_time,1,'last');
        
        if (min(td.fl(1:ktr_initiation_index))<ktr_fl)
            % Skip to next slc file
            skip_counter=skip_counter+1;
            skip.file{skip_counter} = slc_files{file_counter};
            skip.reason{skip_counter} = sprintf( ...
                'FL shortened to %.3f of ktr_fl', ...
                min(td.fl(1:ktr_initiation_index))/ktr_fl);
            continue;
        end
    end

    % Deduce display indices
    display_index_start=round(0.9*td.pre_servo_time * ...
        td.sampling_rate);
    display_index_stop=round(1.1*td.ktr_initiation_time * ...
        td.sampling_rate);
    display_indices=display_index_start:display_index_stop;
    
    % Deduce fit indices
    fit_index_start=round((td.pre_servo_time + ...
            params.fit_time_range(1) * td.servo_time) * td.sampling_rate);
    fit_index_stop=round((td.pre_servo_time + ...
            params.fit_time_range(2) * td.servo_time) * td.sampling_rate);
    fit_indices=fit_index_start:fit_index_stop;
    
    % Calculate mean force
    mean_force = mean(td.force(fit_indices));
    
    % Fit straight line
    s = fit_linear_model(td.time(fit_indices),td.fl(fit_indices), ...
        'x_fit',td.time(fit_indices));
    
    % Fit single exponential
    t_exp_fit = td.time(fit_indices);
    [exp_start,exp_amplitude,exp_rate,exp_r_squared,exp_y_fit] = ...
        fit_single_exponential(t_exp_fit,td.fl(fit_indices));
    % Calculate the velocity at the beginning of the release
    exp_velocity = -exp_rate*exp_amplitude* ...
        exp(exp_rate*(t_exp_fit(1)-td.pre_servo_time-(1/td.sampling_rate)));
    
    % Check for stretching
    if (params.skip_files_with_stretching)
        if (s.slope>0)
            % Skip to next slc file
            skip_counter=skip_counter+1;
            skip.file{skip_counter} = slc_files{file_counter};
            skip.reason{skip_counter} = sprintf( ...
                'FL lengthened at %.3f',s.slope);
            continue;
        end
    end
    
    % Store data
    output_counter = output_counter+1;
    out.directory{output_counter} = path_string;
    out.factor_1{output_counter} = factor_1_string;
    out.factor_2{output_counter} = factor_2_string;
    out.tag{output_counter} = tag_string;
    out.prep{output_counter} = prep_string;
    out.file{output_counter} = name;
    out.pCa(output_counter) = td.pCa;
    out.pH(output_counter) = td.pH;
    out.ADP(output_counter) = td.ADP;
    out.Pi(output_counter) = td.Pi;
    out.muscle_length(output_counter) = td.muscle_length;
    out.sarcomere_length(output_counter) = td.sarcomere_length;
    out.area(output_counter) = td.area;
    out.mean_force(output_counter) = mean_force;
    out.linear_velocity(output_counter) = -s.slope;
    out.linear_r_squared(output_counter) = (s.r)^2;
    out.exp_velocity(output_counter) = -exp_velocity;
    out.exp_r_squrared(output_counter) = exp_r_squared;
    
    % Display raw figure
    if (params.raw_figure)
        display_slcontrol_record(td,params.raw_figure,0,1,[1 3]);
    end
    
    % FV figure
    if (params.fit_figure)
        
        % Extrapolate the single exponential to the step time
        exp_display_indices = ...
            (find(td.time>td.pre_servo_time,1,'first')+1) : ...
                fit_indices(end);
        t_fit = td.time(exp_display_indices);
        y_exp_fit = exp_start + exp_amplitude * ...
            exp(-exp_rate*(t_fit-td.time(fit_index_start)));

        figure(params.fit_figure);
        clf;
        subplot(2,1,1);
        plot(td.time(display_indices),td.force(display_indices),'b-');
        hold on;
        plot(td.time(fit_indices([1 end])),mean_force*[1 1],'r-');
        subplot(2,1,2);
        plot(td.time(display_indices),td.fl(display_indices),'b-');
        hold on;
        plot(t_fit,y_exp_fit,'g-','LineWidth',2);
        plot(td.time(fit_indices),s.y_fit,'r-', ...
            'LineWidth',1.5);
        
        y_limits=ylim;
        x_limits=xlim;
        text(x_limits(1)+0.2*diff(x_limits),y_limits(2)-0.1*diff(y_limits), ...
            sprintf('Linear velocity (l_0 s^{-1}): %.4f', ...
                s.slope/td.muscle_length));
        text(x_limits(1)+0.2*diff(x_limits),y_limits(2)-0.4*diff(y_limits), ...
            sprintf('Extrapolated velocity (l_0 s^{-1}): %.4f', ...
                exp_velocity/td.muscle_length));
    end
end

% Output
write_structure_to_excel('filename',params.output_file_string, ...
    'sheet',params.sheet, ...
    'structure',out);

if (exist('skip'))
    write_structure_to_excel('filename',params.output_file_string, ...
        'sheet',params.skip_sheet, ...
        'structure',skip);
end