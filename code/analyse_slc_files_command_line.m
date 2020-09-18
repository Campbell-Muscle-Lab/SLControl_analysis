function analyse_slc_files_command_line(varargin);

% Code analyses all the slc files in a directory and its sub-directories
% that meet a specific criteria and outputs selected results
% to the specified filename.

disp('----');
disp('STARTED ANALYSE_SLC_FILES');
disp('----');

% Set up defaults
params.top_data_folder_string='';
params.output_file_string='';
params.sheet = 'SLC_files';
params.include_tag='';
params.exclude_tag='';
params.initial_fitting_time=[];
params.second_fitting_time=[];
params.srec_detection_threshold=6;
params.include_stiffness_analysis=1;
params.velocity_criterion_min=0.001;
params.velocity_criterion_max=10.0;
params.max_ktr_fitting_period=25;
params.spike_window = [];
params.stiffness_smoothing_window = [];
params.apply_smoothing_for_regression = [];

% Update params
params=parse_pv_pairs(params,varargin);

% Set new variables
search_directory=params.top_data_folder_string;
output_file_string=params.output_file_string;
initial_fitting_time=params.initial_fitting_time;
second_fitting_time=params.second_fitting_time;
srec_detection_threshold=params.srec_detection_threshold;
include_stiffness_analysis=params.include_stiffness_analysis;
velocity_criteria.min=params.velocity_criterion_min;
velocity_criteria.max=params.velocity_criterion_max;
max_ktr_fitting_period=params.max_ktr_fitting_period;
spike_window = params.spike_window;
stiffness_smoothing_window = params.stiffness_smoothing_window;
apply_smoothing_for_regression = params.apply_smoothing_for_regression;

% Set figure handles
raw_display_figure_window=10;
ktr_figure_window=11;
stiffness_figure_window=12;

% Find files in specified directory
all_files=findfiles('slc',search_directory,1);

% Screen for include and exclude tags
slc_counter=0;
for all_counter=1:length(all_files)
    [~,file_name_string,~]=fileparts(all_files{all_counter});
    
    if (length(params.include_tag)>0)
        include_result = length(regexp(file_name_string, ...
            params.include_tag));
    else
        include_result=1;
    end
    
    if (length(params.exclude_tag)>0)
        exclude_result = length(regexp(file_name_string, ...
            params.exclude_tag));
    else
        exclude_result=0;
    end
    
    if ((include_result)&&(~exclude_result))
        slc_counter=slc_counter+1;
        slc_files{slc_counter}=all_files{all_counter};
    end
end
no_of_slc_files=slc_counter

% Check for valid no_of_files
if (no_of_slc_files==0)
    msgbox(sprintf( ...
        'No SLC files to analyze\nInclude tag: %s\nExclude tag: %s', ...
            params.include_tag,params.exclude_tag), ...
        'Failed Include/Exclude filter','error');
    return
end

slc_files=slc_files

% Pre-screen for conditions
display_string=sprintf('Pre-screening %i files', ...
    no_of_slc_files);
disp(display_string);

progress_bar(0);
for file_counter=1:no_of_slc_files
    progress_bar(file_counter/no_of_slc_files,'Pre-screening files');
    
    d=load_slcontrol_file(slc_files{file_counter},1);
    
    if (d.no_of_triangles>0)
        file_stretch_velocity(file_counter)= ...
            (d.triangle_size/d.muscle_length) / d.triangle_halftime;
    else
        file_stretch_velocity(file_counter)=0;
    end
end

stretch_velocities=unique(file_stretch_velocity);

selected_files=[];
if (length(velocity_criteria.min)>0)
    selected_files=find((file_stretch_velocity>velocity_criteria.min) & ...
        (file_stretch_velocity<velocity_criteria.max));
else
    selected_files=1:no_of_slc_files;
end

% Check for valid no_of_files
if (length(selected_files)==0)
    msgbox(sprintf( ...
        'No SLC files to analyze\nVelocity_criteria.min: %g\nVelocity_criteria.max: %g', ...
            velocity_criteria.min,velocity_criteria.max), ...
        'Failed Velocity Filter','error');
    return
end

% Run analysis
% with waitbar

temp_string=sprintf('Analysing %i slc files',length(selected_files));
disp(temp_string);

for file_counter=1:length(selected_files)
    progress_bar(file_counter/length(selected_files),temp_string);
    
    % Load file
    d = load_slcontrol_file( ...
            slc_files{selected_files(file_counter)});
    
    % Check for ramp mode
    if ((d.ramp_mode == 1) & (d.no_of_triangles == 1))
        of = gcf;
        figure(7)
        dfl = diff(d.fl);
        plot(dfl,'b-');
        figure(of);
        error('ken');
        
        d.ktr_initiation_time = d.pre_triangle_time + ...
            d.triangle_halftime + d.pre_ktr;
    end

    % Transform
    td=transform_slcontrol_record(d);
        
    display_slcontrol_record(td,raw_display_figure_window);

    % ktr analysis
    ktr_results=analyse_ktr_parsed(...
        'data',td, ...
        'figure_number',ktr_figure_window, ...
        'max_fitting_period',max_ktr_fitting_period, ...
        'log_scale',1, ...
        'threshold',1.0, ...
        'fit_double_exponential',0, ...
        'residual_search_factor',2.5, ...
        'recovery_threshold',0.97, ...
        'spike_window',spike_window ...
        );
    
    if (include_stiffness_analysis)
        % Stiffness analysis
        % Figure 3, initial_fitting_time, 50 ms
        stiffness_results=analyse_stiffness_parsed( ...
            'data',td, ...
            'figure_number',stiffness_figure_window, ...
            'initial_fitting_time',initial_fitting_time, ...
            'second_fitting_time',second_fitting_time, ...
            'SREC_detection_threshold',srec_detection_threshold, ...
            'smoothing_window',stiffness_smoothing_window, ...
            'apply_smoothing_for_regression',apply_smoothing_for_regression);
    end
    
    % Analyze file name and path
    [path_string,name,temp]= ...
        fileparts(slc_files{selected_files(file_counter)});
    
    ii=regexp(path_string,'\\');
    prep_string = path_string(ii(end)+1:end);
    tag_string=path_string(ii(end-1)+1:ii(end)-1);
    factor_2_string = path_string(ii(end-2)+1:ii(end-1)-1);
    factor_1_string = path_string(ii(end-3)+1:ii(end-2)-1);
    
    % Store data
    out.directory{file_counter} = path_string;
    out.factor_1{file_counter} = factor_1_string;
    out.factor_2{file_counter} = factor_2_string;
    out.tag{file_counter} = tag_string;
    out.prep{file_counter} = prep_string;
    out.file{file_counter} = name;
    out.pCa(file_counter) = td.pCa;
    out.pH(file_counter) = td.pH;
    out.ADP(file_counter) = td.ADP;
    out.Pi(file_counter) = td.Pi;
    out.drug{file_counter} = td.drug;
    out.drug_concentration(file_counter) = td.drug_concentration;
    out.vehicle{file_counter} = td.vehicle;
    out.vehicle_per_cent(file_counter) = td.vehicle_per_cent;
    out.P_ss(file_counter) = ktr_results.isometric_tension;
    out.k_half(file_counter) = ktr_results.k_half;
    out.k_tr(file_counter) = ktr_results.k_tr;
    out.resid(file_counter) = ktr_results.residual;
    out.resid_time(file_counter) = ktr_results.resid_time;
    out.r_squared(file_counter) = ktr_results.single_exp_data.r_squared;
    
    if (include_stiffness_analysis)
        for tri_counter=1:td.no_of_triangles
            field_string = sprintf('SREC_YM%.0f_SL',tri_counter);
            out.(field_string)(file_counter) = ...
                stiffness_results(tri_counter).SREC_YM_sl;
            field_string = sprintf('SREC_YM%.0f_FL',tri_counter);
            out.(field_string)(file_counter) = ...
                stiffness_results(tri_counter).SREC_YM_fl;
            field_string = sprintf('SREC_f%.0f',tri_counter);
            out.(field_string)(file_counter) = ...
                stiffness_results(tri_counter).SREC_f;
            field_string = sprintf('SREC_Rel_SLf%.0f',tri_counter);
            out.(field_string)(file_counter) = ...
                stiffness_results(tri_counter).SREC_sl/td.sarcomere_length;
            field_string = sprintf('SREC_Rel_FLf%.0f',tri_counter);
            out.(field_string)(file_counter) = ...
                stiffness_results(tri_counter).SREC_fl/td.muscle_length;
            field_string = sprintf('SREC_P_end%.0f',tri_counter);
            out.(field_string)(file_counter) = ...
                stiffness_results(tri_counter).P_end./ktr_results.isometric_tension;

            field_string = sprintf('final_YM_fl_%.0f',tri_counter); 
            out.(field_string)(file_counter) = stiffness_results(tri_counter).final_YM_fl;
        end
    end
    
    % Prep data
    out.muscle_length(file_counter) = td.muscle_length;
    out.sarcomere_length(file_counter) = td.sarcomere_length;
    out.area(file_counter) = td.area;
end

% Output
write_structure_to_excel('filename',params.output_file_string, ...
    'structure',out, ...
    'sheet',params.sheet);
delete_excel_sheets('filename',params.output_file_string);

msgbox(sprintf('Data written to %s',params.output_file_string));

% Close windows
close(raw_display_figure_window);
% close(ktr_figure_window);
% close(stiffness_figure_window);

