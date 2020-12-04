function varargout = analysis_gui(varargin)
% ANALYSIS_GUI MATLAB code for analysis_gui.fig
%      ANALYSIS_GUI, by itself, creates a new ANALYSIS_GUI or raises the existing
%      singleton*.
%
%      H = ANALYSIS_GUI returns the handle to a new ANALYSIS_GUI or the handle to
%      the existing singleton*.
%
%      ANALYSIS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS_GUI.M with the given input arguments.
%
%      ANALYSIS_GUI('Property','Value',...) creates a new ANALYSIS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysis_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysis_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analysis_gui

% Last Modified by GUIDE v2.5 18-Feb-2016 10:33:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before analysis_gui is made visible.
function analysis_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analysis_gui (see VARARGIN)

% Choose default command line output for analysis_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes analysis_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = analysis_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function lc_analysis_data_folder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lc_analysis_data_folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_analysis_data_folder_edit as text
%        str2double(get(hObject,'String')) returns contents of lc_analysis_data_folder_edit as a double


% --- Executes during object creation, after setting all properties.
function lc_analysis_data_folder_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_analysis_data_folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lc_analysis_data_folder_push.
function lc_analysis_data_folder_push_Callback(hObject, eventdata, handles)
% hObject    handle to lc_analysis_data_folder_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

path_string = uigetdir2();

if (path_string~=0)
    set(handles.lc_analysis_data_folder_edit, ...
        'String',path_string);
end

function lc_analysis_output_file_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lc_analysis_output_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function lc_analysis_output_file_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_analysis_output_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lc_analysis_output_file_push.
function lc_analysis_output_file_push_Callback(hObject, eventdata, handles)
% hObject    handle to lc_analysis_output_file_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[file_string,path_string]=uiputfile2( ...
    {'*.xlsx;*.xls','Excel files (*.xlsx, *.xls)'},'Select output file');
if (path_string~=0)
    set(handles.lc_analysis_output_file_edit, ...
        'String',fullfile(path_string,file_string));
end

function lc_analysis_include_string_Callback(hObject, eventdata, handles)
% hObject    handle to lc_analysis_include_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_analysis_include_string as text
%        str2double(get(hObject,'String')) returns contents of lc_analysis_include_string as a double


% --- Executes during object creation, after setting all properties.
function lc_analysis_include_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_analysis_include_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lc_analysis_exclude_string_Callback(hObject, eventdata, handles)
% hObject    handle to lc_analysis_exclude_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_analysis_exclude_string as text
%        str2double(get(hObject,'String')) returns contents of lc_analysis_exclude_string as a double


% --- Executes during object creation, after setting all properties.
function lc_analysis_exclude_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_analysis_exclude_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lc_analysis_short_range_fit_time_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lc_analysis_short_range_fit_time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_analysis_short_range_fit_time_edit as text
%        str2double(get(hObject,'String')) returns contents of lc_analysis_short_range_fit_time_edit as a double


% --- Executes during object creation, after setting all properties.
function lc_analysis_short_range_fit_time_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_analysis_short_range_fit_time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lc_analysis_second_fit_time_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lc_analysis_second_fit_time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_analysis_second_fit_time_edit as text
%        str2double(get(hObject,'String')) returns contents of lc_analysis_second_fit_time_edit as a double


% --- Executes during object creation, after setting all properties.
function lc_analysis_second_fit_time_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_analysis_second_fit_time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lc_analysis_analyze_folder_push.
function lc_analysis_analyze_folder_push_Callback(hObject, eventdata, handles)
% hObject    handle to lc_analysis_analyze_folder_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

       % Get the strings from the screen
        top_data_folder_string = ...
            get(handles.lc_analysis_data_folder_edit,'String');
        output_file_string = ...
            get(handles.lc_analysis_output_file_edit,'String');
        include_string = ...
            get(handles.lc_analysis_include_string,'String');
        exclude_string = ...
            get(handles.lc_analysis_exclude_string,'String');
        
        % Deduce data from the parameter table
        d = handles.lc_parameters_table.Data;
        parameter_strings = d(:,1);
        parameter_values = cell2mat(d(:,2));
        
        vi = find(strcmp(parameter_strings,'short_range_fit_time_s'));
        short_range_fit_time = parameter_values(vi);
        
        vi = find(strcmp(parameter_strings,'second_fit_time_s'));
        second_fit_time = parameter_values(vi);
        
        vi = find(strcmp(parameter_strings,'spike_window_s'));
        spike_window = parameter_values(vi);
        
        vi = find(strcmp(parameter_strings,'stiffness_smoothing_window'));
        stiffness_smoothing_window = parameter_values(vi);
        
        vi = find(strcmp(parameter_strings,'apply_smoothing_for_regression'));
        apply_smoothing_for_regression = parameter_values(vi);
        
        % Run analysis
        analyse_slc_files_command_line( ...
            'top_data_folder_string',top_data_folder_string, ...
            'output_file_string',output_file_string, ...
            'include_tag',include_string, ...
            'exclude_tag',exclude_string, ...
            'initial_fitting_time',short_range_fit_time, ...
            'second_fitting_time',second_fit_time, ...
            'spike_window',spike_window, ...
            'stiffness_smoothing_window',stiffness_smoothing_window, ...
            'apply_smoothing_for_regression',apply_smoothing_for_regression);

function lc_collate_data_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lc_collate_data_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_collate_data_edit as text
%        str2double(get(hObject,'String')) returns contents of lc_collate_data_edit as a double


% --- Executes during object creation, after setting all properties.
function lc_collate_data_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_collate_data_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lc_collate_data_push.
function lc_collate_data_push_Callback(hObject, eventdata, handles)
% hObject    handle to lc_collate_data_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file_string,path_string]=uigetfile2( ...
    {'*.xlsx;*.xls','Excel files (*.xlsx, *.xls)'},'Select analysis file');
if (path_string~=0)
    set(handles.lc_collate_data_edit, ...
        'String',fullfile(path_string,file_string));
end

function lc_collate_output_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lc_collate_output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_collate_output_edit as text
%        str2double(get(hObject,'String')) returns contents of lc_collate_output_edit as a double


% --- Executes during object creation, after setting all properties.
function lc_collate_output_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_collate_output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lc_collate_output_push.
function lc_collate_output_push_Callback(hObject, eventdata, handles)
% hObject    handle to lc_collate_output_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file_string,path_string]=uiputfile2( ...
    {'*.xlsx;*.xls','Excel files (*.xlsx, *.xls)'},'Select output file');
if (path_string~=0)
    set(handles.lc_collate_output_edit, ...
        'String',fullfile(path_string,file_string));
end

function lc_collate_extract_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lc_collate_extract_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_collate_extract_edit as text
%        str2double(get(hObject,'String')) returns contents of lc_collate_extract_edit as a double


% --- Executes during object creation, after setting all properties.
function lc_collate_extract_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_collate_extract_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

path_string = fileparts(which(mfilename));
extract_string = fullfile(path_string,'extract','control_pCa.xlsx')
set(hObject,'String',extract_string);

% --- Executes on button press in lc_collate_push.
function lc_collate_push_Callback(hObject, eventdata, handles)
% hObject    handle to lc_collate_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the right inputs from the dialog
    data_file_string = get(handles.lc_collate_data_edit,'String');
    output_file_string = get(handles.lc_collate_output_edit,'String');
    extract_file_string = get(handles.lc_collate_extract_edit,'String');
    
    possible_strings = get(handles.lc_collate_pCa90_normalization,'String');
    control_value = get(handles.lc_collate_pCa90_normalization,'Value');
    pCa90_normalization_string = char(deblank(possible_strings(control_value,:)));
    
    possible_strings = get(handles.lc_collate_pCa45_normalization,'String');
    control_value = get(handles.lc_collate_pCa45_normalization,'Value');
    pCa45_normalization_string = char(deblank(possible_strings(control_value,:)));
    
    % Deduce normalizating conditions
    d = read_structure_from_excel('filename', ...
            get(handles.lc_collate_normalization_edit,'String'));
    pCa90_normalizing_condition = [d.pCa(1) d.pH(1) d.ADP(1) d.Pi(1)]
    pCa45_normalizing_condition = [d.pCa(2) d.pH(2) d.ADP(2) d.Pi(2)]
    
    collate_prep_and_tag_data( ...
        'data_file_string',data_file_string, ...
        'output_file_string',output_file_string, ...
        'extract_file_string',extract_file_string, ...
        'pCa90_normalizing_mode',pCa90_normalization_string, ...
        'pCa45_normalizing_mode',pCa45_normalization_string, ...
        'pCa90_normalizing_condition',pCa90_normalizing_condition, ...
        'pCa45_normalizing_condition',pCa45_normalizing_condition);


% --- Executes on button press in lc_collate_extract_push.
function lc_collate_extract_push_Callback(hObject, eventdata, handles)
% hObject    handle to lc_collate_extract_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file_string,path_string]=uigetfile2( ...
    {'*.xlsx;*.xls','Excel files (*.xlsx, *.xls)'},'Select extract file');
if (path_string~=0)
    set(handles.lc_collate_extract_edit, ...
        'String',fullfile(path_string,file_string));
end

% --- Executes on selection change in lc_collate_pCa90_normalization.
function lc_collate_pCa90_normalization_Callback(hObject, eventdata, handles)
% hObject    handle to lc_collate_pCa90_normalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lc_collate_pCa90_normalization contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lc_collate_pCa90_normalization


% --- Executes during object creation, after setting all properties.
function lc_collate_pCa90_normalization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_collate_pCa90_normalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lc_collate_pCa45_normalization.
function lc_collate_pCa45_normalization_Callback(hObject, eventdata, handles)
% hObject    handle to lc_collate_pCa45_normalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lc_collate_pCa45_normalization contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lc_collate_pCa45_normalization


% --- Executes during object creation, after setting all properties.
function lc_collate_pCa45_normalization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_collate_pCa45_normalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fv_data_folder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fv_data_folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fv_data_folder_edit as text
%        str2double(get(hObject,'String')) returns contents of fv_data_folder_edit as a double


% --- Executes during object creation, after setting all properties.
function fv_data_folder_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fv_data_folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fv_data_folder_push.
function fv_data_folder_push_Callback(hObject, eventdata, handles)
% hObject    handle to fv_data_folder_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

path_string = uigetdir2();

if (path_string~=0)
    set(handles.fv_data_folder_edit, ...
        'String',path_string);
end

function fv_output_file_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fv_output_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fv_output_file_edit as text
%        str2double(get(hObject,'String')) returns contents of fv_output_file_edit as a double


% --- Executes during object creation, after setting all properties.
function fv_output_file_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fv_output_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fv_output_file_push.
function fv_output_file_push_Callback(hObject, eventdata, handles)
% hObject    handle to fv_output_file_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file_string,path_string]=uiputfile2( ...
    {'*.xlsx;*.xls','Excel files (*.xlsx, *.xls)'},'Select output file');
if (path_string~=0)
    set(handles.fv_output_file_edit, ...
        'String',fullfile(path_string,file_string));
end

function fv_include_string_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fv_include_string_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fv_include_string_edit as text
%        str2double(get(hObject,'String')) returns contents of fv_include_string_edit as a double


% --- Executes during object creation, after setting all properties.
function fv_include_string_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fv_include_string_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fv_exclude_string_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fv_exclude_string_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fv_exclude_string_edit as text
%        str2double(get(hObject,'String')) returns contents of fv_exclude_string_edit as a double


% --- Executes during object creation, after setting all properties.
function fv_exclude_string_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fv_exclude_string_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fv_analyze_folder.
function fv_analyze_folder_Callback(hObject, eventdata, handles)
% hObject    handle to fv_analyze_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get the right inputs from the dialog
    data_folder_string = get(handles.fv_data_folder_edit,'String');
    output_file_string = get(handles.fv_output_file_edit,'String');
    include_string = get(handles.fv_include_string_edit,'String');
    exclude_string = get(handles.fv_exclude_string_edit,'String');
    
    pCa_value = str2num(get(handles.fv_analysis_pCa_edit,'String'));
    
    fv_analysis( ...
        'search_directory',data_folder_string, ...
        'output_file_string',output_file_string, ...
        'include_string',include_string, ...
        'exclude_string',exclude_string, ...
        'pCa_value',pCa_value);


function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fv_analysis_pCa_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fv_analysis_pCa_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fv_analysis_pCa_edit as text
%        str2double(get(hObject,'String')) returns contents of fv_analysis_pCa_edit as a double


% --- Executes during object creation, after setting all properties.
function fv_analysis_pCa_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fv_analysis_pCa_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fv_plots_results_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fv_plots_results_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fv_plots_results_edit as text
%        str2double(get(hObject,'String')) returns contents of fv_plots_results_edit as a double


% --- Executes during object creation, after setting all properties.
function fv_plots_results_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fv_plots_results_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in fv_plots_results_push.
function fv_plots_results_push_Callback(hObject, eventdata, handles)
% hObject    handle to fv_plots_results_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [file_string,path_string]=uigetfile2( ...
        {'*.xlsx;*.xls','Excel files (*.xlsx, *.xls)'},'Select results file');
    if (path_string~=0)
        set(handles.fv_plots_results_edit, ...
            'String',fullfile(path_string,file_string));
    end
    
    % Fill list box
    d = read_structure_from_excel( ...
            'filename',fullfile(path_string,file_string), ...
            'sheet','prep_curves');
    
    lb={};
    fn = fieldnames(d);
    for i=1:numel(fn)
        ii = strfind(fn{i},'f_raw_');
        if (~isempty(ii))
            temp=fn{i};
            lb = [lb(:) ; cellstr(temp(7:end))];
        end
    end
    set(handles.fv_plots_preps_listbox,'String',lb);
    set(handles.fv_plots_preps_listbox,'Value',1);

    
% --- Executes on button press in fv_plots_folder_push.
function fv_plots_folder_push_Callback(hObject, eventdata, handles)
% hObject    handle to fv_plots_folder_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

path_string = uigetdir2();

if (path_string~=0)
    set(handles.fv_plots_folder_edit, ...
        'String',path_string);
end
    
% --- Executes on selection change in fv_plots_preps_listbox.
function fv_plots_preps_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to fv_plots_preps_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fv_plots_preps_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fv_plots_preps_listbox


% --- Executes during object creation, after setting all properties.
function fv_plots_preps_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fv_plots_preps_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fv_plots_push.
function fv_plots_push_Callback(hObject, eventdata, handles)
% hObject    handle to fv_plots_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data_file_string = get(handles.fv_plots_results_edit,'String');
prep_strings = get(handles.fv_plots_preps_listbox,'String');
v = get(handles.fv_plots_preps_listbox,'Value');

temp_strings = get(handles.fv_plots_output_type,'String');
output_type_string = temp_strings{ ...
        get(handles.fv_plots_output_type,'Value')};

progress_bar(0);
for i=1:numel(v)
    progress_bar(i/numel(v),prep_strings{v(i)});
    plot_fv_and_power_data('data_file_string',data_file_string, ...
        'prep_string',prep_strings{v(i)});
    
    
    figure_export('output_file', ...
        fullfile(get(handles.fv_plots_folder_edit,'String'), ...
            sprintf('fv_and_power_%s',prep_strings{v(i)})), ...
        'output_type',output_type_string);
end

% Now drop fv traces
d = read_structure_from_excel('filename',data_file_string, ...
        'sheet','fv_raw');
% Cycle through preps    
progress_bar(0);
for i=1:numel(v)
    progress_bar(i/numel(v),prep_strings{v(i)});
    prep_string = prep_strings{v(i)};
    vi = regexp(prep_string,'_');
    prep_string = prep_string((vi(end)+1):end);
    
    vi = find(strcmp(d.prep,prep_string));
    slc_strings = [];
    for j=1:numel(vi)
        slc_strings{j} = fullfile(d.directory{vi(j)}, ...
            sprintf('%s.slc',d.file{vi(j)}));
    end
    
    plot_fv_traces( ...
        'record_file_strings',slc_strings, ...
        'title_string',prep_strings{v(i)});
    
    figure_export('output_file', ...
        fullfile(get(handles.fv_plots_folder_edit,'String'), ...
            sprintf('fv_traces_%s',prep_strings{v(i)})), ...
        'output_type',output_type_string);
end


function lc_plot_pCa_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lc_plot_pCa_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_plot_pCa_edit as text
%        str2double(get(hObject,'String')) returns contents of lc_plot_pCa_edit as a double


% --- Executes during object creation, after setting all properties.
function lc_plot_pCa_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_plot_pCa_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lc_plot_pCa_select_push.
function lc_plot_pCa_select_push_Callback(hObject, eventdata, handles)
% hObject    handle to lc_plot_pCa_select_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [file_string,path_string]=uigetfile2( ...
        {'*.xlsx;*.xls','Excel files (*.xlsx, *.xls)'},'Select analysis file');
    if (path_string~=0)
        set(handles.lc_plot_pCa_edit, ...
            'String',fullfile(path_string,file_string));
    end
    
    populate_lc_plot_pCa_listbox(hObject,eventdata,handles);
    
function populate_lc_plot_pCa_listbox(hObject,eventdata,handles)

    data_file_string = get(handles.lc_plot_pCa_edit,'String');
    popup_strings = get(handles.lc_plot_pCa_mode,'String');
    popup_value = get(handles.lc_plot_pCa_mode,'Value');
    if (strcmp(popup_strings{popup_value},'Preps'))
        sheet_name = 'pCa_prep';
    else
        sheet_name = 'pCa_tag';
    end
    
    % Fill list box
    d = read_structure_from_excel( ...
            'filename',data_file_string, ...
            'sheet',sheet_name);
    
    lb={};
    fn = fieldnames(d);
    for i=1:numel(fn)
        ii = strfind(fn{i},'P_ss_');
        if (~isempty(ii))
            temp=fn{i};
            lb = [lb(:) ; cellstr(temp(6:end))];
        end
    end
    set(handles.lc_plot_pCa_listbox,'String',lb);
    set(handles.lc_plot_pCa_listbox,'Value',1);
    

% --- Executes on selection change in lc_plot_pCa_listbox.
function lc_plot_pCa_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to lc_plot_pCa_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lc_plot_pCa_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lc_plot_pCa_listbox


% --- Executes during object creation, after setting all properties.
function lc_plot_pCa_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_plot_pCa_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lc_plot_pCa_push.
function lc_plot_pCa_push_Callback(hObject, eventdata, handles)
% hObject    handle to lc_plot_pCa_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data_file_string = get(handles.lc_plot_pCa_edit,'String');
output_file_string = get(handles.lc_plot_pCa_output_edit,'String');
popup_strings = get(handles.lc_plot_pCa_mode,'String');
popup_value = get(handles.lc_plot_pCa_mode,'Value');
sample_strings = get(handles.lc_plot_pCa_listbox,'String');
v = get(handles.lc_plot_pCa_listbox,'Value');

if (numel(v)>1)
    sample_strings = sample_strings(v);
else
    sample_strings = sample_strings{v};
end


plot_pCa_data('data_file_string',data_file_string, ...
    'type_string',popup_strings{popup_value}, ...
    'sample_string',sample_strings, ...
    'output_file_string',output_file_string);

function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit37_Callback(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit37 as text
%        str2double(get(hObject,'String')) returns contents of edit37 as a double


% --- Executes during object creation, after setting all properties.
function edit37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit38 as text
%        str2double(get(hObject,'String')) returns contents of edit38 as a double


% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% 
% % --- Executes on button press in pushbutton20.
% function pushbutton20_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton20 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% % --- Executes on selection change in popupmenu6.
% function popupmenu6_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu6 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu6
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu6_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu6 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% % --- Executes on selection change in popupmenu7.
% function popupmenu7_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu7 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu7
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu7_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu7 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 

% --- Executes on selection change in lc_plot_pCa_mode.
function lc_plot_pCa_mode_Callback(hObject, eventdata, handles)
% hObject    handle to lc_plot_pCa_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lc_plot_pCa_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lc_plot_pCa_mode

if (~isempty(get(handles.lc_plot_pCa_edit,'String')))
    populate_lc_plot_pCa_listbox(hObject,eventdata,handles);
end

% --- Executes during object creation, after setting all properties.
function lc_plot_pCa_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_plot_pCa_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fv_plots_folder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fv_plots_folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fv_plots_folder_edit as text
%        str2double(get(hObject,'String')) returns contents of fv_plots_folder_edit as a double


% --- Executes during object creation, after setting all properties.
function fv_plots_folder_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fv_plots_folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in fv_plots_output_type.
function fv_plots_output_type_Callback(hObject, eventdata, handles)
% hObject    handle to fv_plots_output_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fv_plots_output_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fv_plots_output_type


% --- Executes during object creation, after setting all properties.
function fv_plots_output_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fv_plots_output_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lc_parameter_file_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lc_parameter_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_parameter_file_edit as text
%        str2double(get(hObject,'String')) returns contents of lc_parameter_file_edit as a double

parameter_file_string = get(handles.lc_parameter_file_edit,'String');
[~,sheets]=xlsfinfo(parameter_file_string);
set(handles.lc_parameter_options,'String',sheets);
set(handles.lc_parameter_options,'Value',1);
lc_parameter_change(handles);

% --- Executes during object creation, after setting all properties.
function lc_parameter_file_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_parameter_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

path_string = fileparts(which(mfilename));
set(hObject,'String',fullfile(path_string,'parameters','parameters.xlsx'));

% --- Executes on selection change in lc_parameter_options.
function lc_parameter_options_Callback(hObject, eventdata, handles)
% hObject    handle to lc_parameter_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lc_parameter_options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lc_parameter_options

lc_parameter_change(handles);

% --- Executes during object creation, after setting all properties.
function lc_parameter_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_parameter_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

path_string = fileparts(which(mfilename));
parameter_file_string = fullfile(path_string,'parameters','parameters.xlsx')
[~,sheets]=xlsfinfo(parameter_file_string)
set(hObject,'String',sheets);

% --- Executes during object creation, after setting all properties.
function lc_parameters_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_parameters_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

path_string = fileparts(which(mfilename));
parameter_file_string = fullfile(path_string,'parameters','parameters.xlsx');
[~,sheets]=xlsfinfo(parameter_file_string);
d = read_structure_from_excel('filename',parameter_file_string,'Sheet', ...
        sheets{1})
hObject.ColumnName = fieldnames(d);
n = numel(d.Parameter);
for i=1:n
    t{i,1} = d.Parameter{i};
    t{i,2} = d.Value(i);
end
hObject.Data = t;
hObject.ColumnWidth={200 75};
    
function lc_parameter_change(handles)

parameter_file_string = get(handles.lc_parameter_file_edit,'String');
sheet_strings = get(handles.lc_parameter_options,'String');
sheet = sheet_strings{get(handles.lc_parameter_options,'Value')};
d = read_structure_from_excel('filename',parameter_file_string, ...
        'Sheet',sheet)
handles.lc_parameters_table.ColumnName = fieldnames(d);
n = numel(d.Parameter);
for i=1:n
    t{i,1} = d.Parameter{i};
    t{i,2} = d.Value(i);
end
handles.lc_parameters_table.Data = t;
handles.lc_parameters_table.ColumnWidth={200 75};

function lc_collate_normalization_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lc_collate_normalization_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_collate_normalization_edit as text
%        str2double(get(hObject,'String')) returns contents of lc_collate_normalization_edit as a double


% --- Executes during object creation, after setting all properties.
function lc_collate_normalization_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_collate_normalization_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

path_string = fileparts(which(mfilename));
set(hObject,'String',fullfile(path_string,'normalization','pH_70_no_ADP_no_Pi.xlsx'));

% --- Executes on button press in lc_collate_normalization_push.
function lc_collate_normalization_push_Callback(hObject, eventdata, handles)
% hObject    handle to lc_collate_normalization_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file_string,path_string]=uigetfile2( ...
    {'*.xlsx;*.xls','Excel files (*.xlsx, *.xls)'},'Select normalization file');
if (path_string~=0)
    set(handles.lc_collate_normalization_edit, ...
        'String',fullfile(path_string,file_string));
end



function lc_plot_pCa_output_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lc_plot_pCa_output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lc_plot_pCa_output_edit as text
%        str2double(get(hObject,'String')) returns contents of lc_plot_pCa_output_edit as a double


% --- Executes during object creation, after setting all properties.
function lc_plot_pCa_output_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lc_plot_pCa_output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lc_plot_pCa_output_select.
function lc_plot_pCa_output_select_Callback(hObject, eventdata, handles)
% hObject    handle to lc_plot_pCa_output_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
