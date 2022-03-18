function calculate_pCa_curves(varargin)

params.data_file_string = '';
params.data_type_strings = {'prep','tag'};
params.field_string = '';
params.figure_number = 0;

% Update
params = parse_pv_pairs(params,varargin);

% Cycle through prep types
for t = 1:numel(params.data_type_strings)
    
    % Clear output data
    out_curves = [];
    out_summary = [];
    
    % Clear counter
    entry_counter = 0;
    
    % Read data
    d = read_structure_from_excel('filename',params.data_file_string, ...
            'sheet',sprintf('dumped_%s',params.data_type_strings{t}));
        
    % Check for numeric tags
    if (isnumeric(d.tag))
        for i=1:numel(d.tag)
            d.temp{i}=num2str(d.tag(i));
        end
        d.tag = d.temp;
    end
    
    % Force tags to be valid
    d.tag = matlab.lang.makeValidName(d.tag);
        
    % Find unique pCa values
    unique_pCas = unique(d.pCa);
    unique_pCas = sort(unique_pCas,'descend');
    
    % Store
    out_curves.pCa = unique_pCas;
        
    % Find factors
    unique_f1s = unique(d.factor_1);
    unique_f2s = unique(d.factor_2);
    
    % Find types
    unique_ms = unique(d.(params.data_type_strings{t}));
    
    % Find files that match both factors and each muscle type
    for f1 = 1:numel(unique_f1s)
        for f2 = 1:numel(unique_f2s)
            
            vi_f = find( ...
                    strcmp(d.factor_1,unique_f1s{f1}) & ...
                    strcmp(d.factor_2,unique_f2s{f2}));
                
            for m = 1:numel(unique_ms)
                
                vi_m = find(strcmp(d.(params.data_type_strings{t}), ...
                            unique_ms{m}));
                        
                % Matching preps
                vi = intersect(vi_f,vi_m);
                
                if (numel(vi)>0)
                    % We have data
                    entry_counter = entry_counter+1;
                    
                    % Pull the y_data for the sample
                    all_x = d.pCa(vi);
                    all_y = d.(params.field_string)(vi);
                    
                    y=[];
                    for i=1:numel(unique_pCas)
                        vu = find(all_x == unique_pCas(i));
                        if (isempty(vu))
                            y(i) = NaN;
                        else
                            y(i) = all_y(vu);
                        end
                    end
                    
                    % Store the data
                    field_string = sprintf('%s_%s_%s_%s', ...
                        params.field_string, ...
                        unique_f1s{f1}, ...
                        unique_f2s{f2}, ...
                        unique_ms{m});
                    
                    out_curves.(field_string) = y';
                    
                    % Now fit the data
                    [pCa50,n,scaling_factor,offset,r_sq,x_fit,y_fit] = ...
                        fit_Hill_curve(unique_pCas,y, ...
                            'figure_number',params.figure_number);
                        
                  % Store data
                    out_summary.factor_1{entry_counter} = unique_f1s{f1};
                    out_summary.factor_2{entry_counter} = unique_f2s{f2};
                    if (strcmp(params.data_type_strings{t},'prep'))
                        out_summary.prep{entry_counter} = d.prep{vi(1)};
                        out_summary.tag{entry_counter} = d.tag{vi(1)};
                    else
                        out_summary.tag{entry_counter} = d.tag{vi(1)};
                    end
                    out_summary.muscle_length(entry_counter) = ...
                        d.muscle_length(vi(1));
                    out_summary.sarcomere_length(entry_counter) = ...
                        d.sarcomere_length(vi(1));
                    out_summary.area(entry_counter) = ...
                        d.area(vi(1));
                    out_summary.P_ss_90(entry_counter) = ...
                        d.P_ss(vi(find(d.pCa(vi)==9.0)));
                    out_summary.P_ss_45(entry_counter) = ...
                        d.P_ss(vi(find(d.pCa(vi)==4.5)));
                    out_summary.k_tr_45(entry_counter) = ...
                        d.k_tr(vi(find(d.pCa(vi)==4.5)));
                    out_summary.k_half_ss_45(entry_counter) = ...
                        d.k_half(vi(find(d.pCa(vi)==4.5)));
                    out_summary.pCa50(entry_counter) = pCa50;
                    out_summary.n(entry_counter) = n;
                    out_summary.r_squared(entry_counter) = r_sq;
                    out_summary.pCa_scaling_factor(entry_counter) = ...
                        scaling_factor;
                    out_summary.pCa_offset(entry_counter) = offset;
                    out_summary.min_rel_tension(entry_counter) = ...
                        d.rel_ten(vi(find(d.pCa(vi)==9.0)));
                    out_summary.max_rel_tension(entry_counter) = ...
                        d.rel_ten(vi(find(d.pCa(vi)==4.5)));
                    if (isfield(d, 'SREC_YM1_FL'))
                        out_summary.SREC_YM1_FL_90(entry_counter) = ...
                            d.SREC_YM1_FL(vi(find(d.pCa(vi)==9.0)));
                        out_summary.SREC_YM1_FL_45(entry_counter) = ...
                            d.SREC_YM1_FL(vi(find(d.pCa(vi)==4.5)));
                        out_summary.SREC_f1_45(entry_counter) = ...
                            d.SREC_f1(vi(find(d.pCa(vi)==4.5)));
                        out_summary.SREC_f1_to_Ca_act_ten_45(entry_counter) = ...
                            d.SREC_f1_to_Ca_act_ten(vi(find(d.pCa(vi)==4.5)));
                        out_summary.SREC_Rel_FLf1_45(entry_counter) = ...
                            d.SREC_Rel_FLf1(vi(find(d.pCa(vi)==4.5)));
                    end
                    out_summary.final_run_down(entry_counter) = ...
                        d.final_run_down(vi(find(d.pCa(vi)==4.5)));
                    
                end
            end
        end
    end
    
    % Output
    write_structure_to_excel( ...
        'filename',params.data_file_string, ...
        'sheet',sprintf('pCa_%s',params.data_type_strings{t}), ...
        'structure',out_curves);
    
    write_structure_to_excel( ...
        'filename',params.data_file_string, ...
        'sheet',sprintf('summary_%s',params.data_type_strings{t}), ...
        'structure',out_summary);
end
