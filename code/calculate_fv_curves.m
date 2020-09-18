function calculate_fv_curves(varargin)
% Fits fv and power curves to prep data

params.data_file_string = '';
params.input_sheet = 'fv_raw';
params.prep_curves_sheet = 'prep_curves';
params.prep_summary_sheet = 'summary_prep';
params.vel_mode = 'linear';
params.muscle_density = 1.06e3;             % density of muscle in kg m^{-3}
params.figure_fv = 30;
params.figure_pow = 31;

% Update
params = parse_pv_pairs(params,varargin);

% Clear output data
out_fv_curves = [];
out_summary = [];

% Clear counter
entry_counter = 0;

% Read data
d = read_structure_from_excel('filename',params.data_file_string, ...
        'sheet',params.input_sheet);
    
% Check for numeric tags
if (isnumeric(d.tag))
    for i=1:numel(d.tag)
        d.temp{i}=num2str(d.tag(i));
    end
    d.tag = d.temp;
end

% Find factors
unique_f1s = unique(d.factor_1);
unique_f2s = unique(d.factor_2);

% Find preps
unique_preps = unique(d.prep);

% Find files that match both factors and each prep
for f1 = 1:numel(unique_f1s)
    for f2 = 1:numel(unique_f2s)

        vi_f = find( ...
                strcmp(d.factor_1,unique_f1s{f1}) & ...
                strcmp(d.factor_2,unique_f2s{f2}));

        for p = 1:numel(unique_preps)
            
            progressbar(f1/numel(unique_f1s),f2/numel(unique_f2s), ...
                            p/numel(unique_preps));

            vi_p = find(strcmp(d.prep,unique_preps{p}));

            % Matching preps
            vi = intersect(vi_f,vi_p);

            if (numel(vi)>0)
                % We have data
                entry_counter = entry_counter+1;

                % Pull the y_data for the sample
                all_f = d.mean_force(vi);
                if (strcmp(params.vel_mode,'linear'))
                    all_v = d.linear_velocity(vi) ./ d.muscle_length(vi(1));
                else
                    all_v = d.exp_velocity(vi) ./ d.muscle_length(vi(1));
                end
               
                % Fit fv curve constrained to go through isometric point
                [fv_P0,fv_a,fv_b,fv_r_squared,fv_f_fit,fv_v_fit] = fit_hyperbola( ...
                    'x_data',all_f, ...
                    'y_data',all_v, ...
                    'x_fit',linspace(0,max(all_f),100), ...
                    'x0_guess',max(all_f), ...
                    'x0_min',max(all_f), ...
                    'x0_max',max(all_f));
                
                % Calculate v_max
                fv_v_max = fv_b * (fv_P0 + fv_a) / fv_a - fv_b;
                
                % Fit power_data, W per kg
                all_power = (d.muscle_length(vi(1)) * all_v) .* ...         % m s^-1
                            d.area(vi(1)) .* all_f ./ ...                   % N
                            ((d.area(vi(1)) * d.muscle_length(vi(1))) * ... % volume (m^3)
                                params.muscle_density);                     % density (kg m^-3)
                
                [pow_P0,pow_a,pow_b,pow_r_squared,pow_f_fit,pow_fit, ...
                    pow_max,rel_f_at_max] = ...
                    fit_power_curve(all_f,all_power, ...
                        'x_fit',linspace(0,max(all_f),100), ...
                        'x0_guess',max(all_f), ...
                        'x0_min',max(all_f), ...
                        'x0_max',max(all_f));

                % Store summary                
                out_summary.factor_1{entry_counter} = unique_f1s{f1};
                out_summary.factor_2{entry_counter} = unique_f2s{f2};
                out_summary.tag{entry_counter} = d.tag{vi(1)};
                out_summary.prep{entry_counter} = unique_preps{p};
                out_summary.muscle_length(entry_counter) = ...
                    d.muscle_length(vi(1));
                out_summary.sarcomere_length(entry_counter) = ...
                    d.sarcomere_length(vi(1));
                out_summary.area(entry_counter) = ...
                    d.area(vi(1));

                out_summary.fv_P0(entry_counter) = fv_P0;
                out_summary.fv_v_max(entry_counter) = fv_v_max;
                out_summary.fv_a(entry_counter) = fv_a;
                out_summary.fv_b(entry_counter) = fv_b;
                out_summary.fv_r_squared(entry_counter) = fv_r_squared;
                
                out_summary.pow_a(entry_counter) = pow_a;
                out_summary.pow_b(entry_counter) = pow_b;
                out_summary.pow_r_squared(entry_counter) = pow_r_squared;
                out_summary.pow_max(entry_counter) = pow_max;
                out_summary.rel_f_at_max_power(entry_counter) = rel_f_at_max;
                
                % Store curves
                field_string = sprintf('f_raw_%s_%s_%s_%s', ...
                    unique_f1s{f1},unique_f2s{f2},d.tag{vi(1)},unique_preps{p});
                out_fv_curves.(field_string) = all_f';
                
                field_string = sprintf('v_raw_%s_%s_%s_%s', ...
                    unique_f1s{f1},unique_f2s{f2},d.tag{vi(1)},unique_preps{p});
                out_fv_curves.(field_string) = all_v';
                
                field_string = sprintf('p_raw_%s_%s_%s_%s', ...
                    unique_f1s{f1},unique_f2s{f2},d.tag{vi(1)},unique_preps{p});
                out_fv_curves.(field_string) = all_power';

                field_string = sprintf('fv_f_fit_%s_%s_%s_%s', ...
                    unique_f1s{f1},unique_f2s{f2},d.tag{vi(1)},unique_preps{p});
                out_fv_curves.(field_string) = fv_f_fit';
                
                field_string = sprintf('fv_v_fit_%s_%s_%s_%s', ...
                    unique_f1s{f1},unique_f2s{f2},d.tag{vi(1)},unique_preps{p});
                out_fv_curves.(field_string) = fv_v_fit';
                
                field_string = sprintf('pf_f_fit_%s_%s_%s_%s', ...
                    unique_f1s{f1},unique_f2s{f2},d.tag{vi(1)},unique_preps{p});
                out_fv_curves.(field_string) = pow_f_fit';
                
                field_string = sprintf('pf_pow_fit_%s_%s_%s_%s', ...
                    unique_f1s{f1},unique_f2s{f2},d.tag{vi(1)},unique_preps{p});
                out_fv_curves.(field_string) = pow_fit';
                
                % Display
                if (params.figure_fv)
                    figure(params.figure_fv);
                    clf;
                    hold on;
                    plot(all_f,all_v,'bo');
                    plot(fv_f_fit,fv_v_fit,'r-');
                    xlabel('Stress (N m^{-2})');
                    ylabel({'Shortening','velocity','(l_0 s^{-1})'}, ...
                        'Rotation',0);
                    x_limits = xlim;
                    y_limits = ylim;
                    text(mean(x_limits),mean(y_limits), ...
                        sprintf('f0=%f\na=%g\nb=%g\nv_{max}=%g\nr^{2}=%g', ...
                            fv_P0,fv_a,fv_b,fv_v_max,fv_r_squared));
                end
                
                if (params.figure_pow)
                    figure(params.figure_pow);
                    clf;
                    hold on;
                    plot(all_f,all_power,'bo');
                    plot(pow_f_fit,pow_fit,'r-');
                    xlabel('Stress (N m^{-2})');
                    ylabel({'Power','(W kg{-1})'}, ...
                        'Rotation',0);
                    x_limits = xlim;
                    y_limits = ylim;
                    text(mean(x_limits),mean(y_limits), ...
                        sprintf('f0=%f\na=%g\nb=%g\nP_{max}=%g\nrel f at max %g\nr^2=%g', ...
                            pow_P0,pow_a,pow_b,pow_max,rel_f_at_max,pow_r_squared));
                end
            end
        end
    end
end

% Output
write_structure_to_excel( ...
    'filename',params.data_file_string, ...
    'sheet',params.prep_curves_sheet, ...
    'structure',out_fv_curves);

write_structure_to_excel( ...
    'filename',params.data_file_string, ...
    'sheet',params.prep_summary_sheet, ...
    'structure',out_summary);
end
