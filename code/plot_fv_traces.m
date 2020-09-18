function plot_fv_traces(varargin)

p = inputParser;
addOptional(p,'record_file_strings','');
addOptional(p,'start_time_s',[]);
addOptional(p,'stop_time_s',[]);
addOptional(p,'figure_number',52);
addOptional(p,'title_string','');

parse(p,varargin{:});

% Code
fs = p.Results.record_file_strings;
td = transform_slcontrol_record(load_slcontrol_file(fs{1}));

if (~isempty(p.Results.start_time_s))
    p.Results.start_time_s = 0.001*(td.pre_servo_ms-25);
end

if (~isempty(p.Results.stop_time_s))
    p.Results.stop_time_s = 0.001*(td.pre_servo_ms+td.servo_ms+25);
end


% Make figure
figure(p.Results.figure_number);
sp = initialise_publication_quality_figure( ...
        'no_of_panels_wide',1, ...
        'no_of_panels_high',2, ...
        'x_to_y_axes_ratio',2, ...
        'axes_padding_bottom',0.1, ...
        'axes_padding_left',1, ...
        'axes_padding_right',0.5, ...
        'panel_label_font_size',0, ...
        'top_margin',0.15);


plot_data = display_slcontrol_records( ...
    'record_file_strings',p.Results.record_file_strings, ...
    'force_subplot',sp(1), ...
    'fl_subplot',sp(2), ...
    'start_time_s',p.Results.start_time_s, ...
    'stop_time_s',p.Results.stop_time_s, ...
    'force_scale_factor',0.001, ...
    'display_pCa_values',0, ...
    'normalize_fl',0, ...
    'fl_scale_factor',1e6);

% Tidy the axes using the return values from display_slcontrol_records
% to do the scaling
subplot(sp(1));
improve_axes( ...
    'y_axis_label',{'Force','(kN m^{-2})'}, ...
    'y_ticks',[0 multiple_greater_than(plot_data.max_force,10)], ...
    'y_tick_decimal_places',0, ...
    'x_ticks',[p.Results.start_time_s p.Results.stop_time_s], ...
    'x_axis_off',1, ...
    'title',p.Results.title_string, ...
    'title_text_interpreter','none');

subplot(sp(2));
improve_axes( ...
    'y_axis_label',{'Muscle','length','(�m)'}, ...
    'y_ticks',[plot_data.min_fl plot_data.max_fl], ...
    'y_tick_decimal_places',0, ...
    'x_axis_label','Time (s)', ...
    'x_ticks',[p.Results.start_time_s p.Results.stop_time_s], ...
    'x_tick_decimal_places',3);


    