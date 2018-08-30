function varargout = recipe_2p_GUI(varargin)
% RECIPE_2P_GUI MATLAB code for recipe_2p_GUI.fig
%      RECIPE_2P_GUI, by itself, creates a new RECIPE_2P_GUI or raises the existing
%      singleton*.
%
%      H = RECIPE_2P_GUI returns the handle to a new RECIPE_2P_GUI or the handle to
%      the existing singleton*.
%
%      RECIPE_2P_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECIPE_2P_GUI.M with the given input arguments.
%
%      RECIPE_2P_GUI('Property','Value',...) creates a new RECIPE_2P_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recipe_2p_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recipe_2p_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recipe_2p_GUI

% Last Modified by GUIDE v2.5 08-Mar-2018 22:00:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @recipe_2p_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @recipe_2p_GUI_OutputFcn, ...
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


% --- Executes just before recipe_2p_GUI is made visible.
function recipe_2p_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recipe_2p_GUI (see VARARGIN)

global recipe_data
recipe_data = [];

% Choose default command line output for recipe_2p_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.figure1,'CloseRequestFcn',[]);
% UIWAIT makes recipe_2p_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = recipe_2p_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in but_addstimulus.
function but_addstimulus_Callback(hObject, eventdata, handles)
% hObject    handle to but_addstimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global recipe_data
[fn, datadir] = uigetfile('Z:\MASTER_STIMULUS_FOLDER');

if ~(fn==0) % Check tha it wasnt cancelled
    entry_tmp = cell(1,2); 
    entry_tmp{1} = fullfile(datadir, fn);
    try    
        load(entry_tmp{1}, 'stimParams')
        entry_tmp{2} = stimParams.framerate;
    catch
        entry_tmp{2} = 2;
    end

    % Get number of frames
    x = whos(matfile(fullfile(datadir, fn)), 'moviedata')
    if length(x) == 0 % The stimulus here is not named moviedata
        error('Stimulus data is not named moviedata, correctly format data as moviedata and metadata as stimParams')
    else
        entry_tmp{3} = x.size(end);

        % Minutes that will elapse...
        entry_tmp{4} = entry_tmp{3}/entry_tmp{2}/60

        if isempty(recipe_data)
            recipe_data = entry_tmp;
        else
            recipe_data = [recipe_data ;entry_tmp];
        end
    end
end

set(handles.uitable1, 'data', recipe_data);

% --- Executes on button press in but_removestim.
function but_removestim_Callback(hObject, eventdata, handles)
% hObject    handle to but_removestim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global recipe_data

n = inputdlg('Enter the number of stimulus to remove...')

if ~isempty(n)
    n = str2num(n{1});
    recipe_data(n, :) = [];
    
    % remove the emptys..
    set(handles.uitable1, 'data', recipe_data);
    
end


% --- Executes on button press in but_loadrecipe.
function but_loadrecipe_Callback(hObject, eventdata, handles)
% hObject    handle to but_loadrecipe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global recipe_data

[FileName,PathName] = uigetfile
load(fullfile(PathName, FileName), 'recipe_data')

% Refresh display
set(handles.uitable1, 'data', recipe_data);
disp('REFRESHED to most up to date recipe')



% --- Executes on button press in but_saverecipe.
function but_saverecipe_Callback(hObject, eventdata, handles)
% hObject    handle to but_saverecipe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global recipe_data
[filename, pathname] = uiputfile('*.mat', 'Save Workspace as');
save(fullfile(pathname, filename), 'recipe_data', '-v7.3');

% --- Executes on button press in but_clearrecipe.
function but_clearrecipe_Callback(hObject, eventdata, handles)
% hObject    handle to but_clearrecipe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global recipe_data

recipe_data = []

set(handles.uitable1, 'data', cell(2,1));


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

global recipe_data
eventdata.NewData
if isstr(eventdata.NewData)
    recipe_data{eventdata.Indices(1),eventdata.Indices(2)} = str2num(eventdata.NewData)
else
    recipe_data{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.NewData
end

% Update the estimated time...
recipe_data{eventdata.Indices(1),4} = recipe_data{eventdata.Indices(1),3}/recipe_data{eventdata.Indices(1),2}/60;

set(handles.uitable1, 'data', recipe_data);


% --- Executes on button press in but_refresh.
function but_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to but_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global recipe_data
set(handles.uitable1, 'data', recipe_data);
disp('REFRESHED to most up to date recipe')
