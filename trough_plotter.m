function varargout = trough_plotter(varargin)
% TROUGH_PLOTTER MATLAB code for trough_plotter.fig
%      TROUGH_PLOTTER, by itself, creates a new TROUGH_PLOTTER or raises the existing
%      singleton*.
%
%      H = TROUGH_PLOTTER returns the handle to a new TROUGH_PLOTTER or the handle to
%      the existing singleton*.
%
%      TROUGH_PLOTTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TROUGH_PLOTTER.M with the given input arguments.
%
%      TROUGH_PLOTTER('Property','Value',...) creates a new TROUGH_PLOTTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trough_plotter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trough_plotter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trough_plotter

% Last Modified by GUIDE v2.5 01-May-2017 15:19:27

% Begin initialization code - DO NOT EDIT
global listBoxSentinel;
listBoxSentinel=0;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trough_plotter_OpeningFcn, ...
                   'gui_OutputFcn',  @trough_plotter_OutputFcn, ...
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


% --- Executes just before trough_plotter is made visible.
function trough_plotter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trough_plotter (see VARARGIN)

% Choose default command line output for trough_plotter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes trough_plotter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = trough_plotter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in data_set_listbox.
function data_set_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to data_set_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns data_set_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from data_set_listbox
contents=cellstr(get(hObject,'String'));
fileToPlot=contents{get(hObject,'Value')};
plot(handles.axes1,handles.(fileToPlot)(:,1),handles.(fileToPlot)(:,2));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function data_set_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_set_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global listBoxSentinel;
if listBoxSentinel==1
    set(handles.data_set_listbox, 'String', handles.FileNames);
else
    set(handles.data_set_listbox, 'String', ''); %this throws error on initial startup but works to clear files
end
guidata(hObject,handles);


% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileNames=handles.FileNames; %this doesnt work
for i=1:length(FileNames)
    name=(char(FileNames(i)));
    handles=rmfield(handles,(name));
end
%handles=rmfield(handles,'FileNames');
global listBoxSentinel;
listBoxSentinel=0;
guidata(hObject,handles);
data_set_listbox_CreateFcn(hObject, [], handles);


% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileNames,~] = uigetfile({'*.*', 'All Files'},'Load trough datasets','MultiSelect','on');
FileNames=cellstr(FileNames);
handles.FileNames=FileNames;
for i=1:length(FileNames)
    name=(char(FileNames(i)));
    [C,~]=importdata(name);
    x=str2double(C.textdata(4:length(C.textdata),2));
    y=str2double(C.textdata(4:length(C.textdata),3));
    r=[x,y];
    handles.(name)=r;
end
global listBoxSentinel;
listBoxSentinel=1;
data_set_listbox_CreateFcn(hObject, [], handles);
guidata(hObject,handles);
