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

% Last Modified by GUIDE v2.5 07-May-2017 17:48:26

% Begin initialization code - DO NOT EDIT
%lol fuck that noise, initializing listbox sentinel variable
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

%initialize labels on the plot, as well as the counter and alreadyPlotted
%handles (which are used later)
axes(handles.axes1);
xlabel('area ($\rm{\AA}^2$/molecule)','interpreter','latex');
ylabel('surface pressure (mN/m)','interpreter','latex');
handles.alreadyPlotted=[];
handles.counter=1;
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

%the plot will dynamically update when a dataset is clicked
contents=cellstr(get(hObject,'String'));
fileToPlot=contents{get(hObject,'Value')};
counter=handles.counter;
%if we're just doing single plots, we're in the top block. multiplot is the
%bottom block
if ishold(handles.axes1)==0
    %these two statements are necessary, as we increment the counter and 
    %alter the list of plotted things after plotting to prepare for the possibility of mulitplot.
    counter=1;
    handles.listOfPlots={};
    listOfPlots=handles.listOfPlots;
    listOfPlots=[listOfPlots,fileToPlot]; %append fileToPlot to listOfPlots, used for multiplot
    p=handles.alreadyPlotted;
    p(counter)=plot(handles.axes1,handles.(fileToPlot)(:,1),handles.(fileToPlot)(:,2));
    counter=counter+1;
    axes(handles.axes1);
    xlabel('area ($\rm{\AA}^2$/molecule)','interpreter','latex');
    ylabel('surface pressure (mN/m)','interpreter','latex');
    %fileToPlot needs to be {} below to be produced with no interpreter
    legend({fileToPlot},'interpreter','none');
    %update handles structure
    handles.listOfPlots=listOfPlots;
    handles.alreadyPlotted=p;
    handles.counter=counter;
    handles.currentPlotAxes=handles.axes1;
    handles.currentPlotLegend=legend(handles.axes1);
    guidata(hObject,handles);
else
    listOfPlots=handles.listOfPlots;
    listOfPlots=[listOfPlots,fileToPlot]; %append fileToPlot to listOfPlots
    p=handles.alreadyPlotted;
    axes(handles.axes1);
    xlabel('area ($\rm{\AA}^2$/molecule)','interpreter','latex');
    ylabel('surface pressure (mN/m)','interpreter','latex');
    fileToPlot=listOfPlots{counter};
    p(counter)=plot(handles.axes1,handles.(fileToPlot)(:,1),handles.(fileToPlot)(:,2));
    counter=counter+1;
    %assign legend from listOfPlots and array of plots (p)
    for i=1:length(listOfPlots)
        legend(p(1:i),listOfPlots(1:i),'interpreter','none');
    end
    %update handles structure
    handles.listOfPlots=listOfPlots;
    handles.alreadyPlotted=p;
    handles.counter=counter;
    handles.currentPlotAxes=handles.axes1;
    handles.currentPlotLegend=legend(handles.axes1);
    guidata(hObject,handles);
end


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
%based on the value of listBoxSentinel, either populate the listbox with
%dataset names or empty it
global listBoxSentinel;
if listBoxSentinel==1
    set(handles.data_set_listbox, 'String', handles.FileNames);
else
    set(handles.data_set_listbox, 'String', '');
end
guidata(hObject,handles);


% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileNames=handles.FileNames; %this doesnt work
%iteratively remove stored filenames
for i=1:length(FileNames)
    name=(char(FileNames(i)));
    handles=rmfield(handles,(name));
end
%reset listBoxSentinel to draw empty listbox
global listBoxSentinel;
listBoxSentinel=0;
%clear axes and legend
cla(handles.axes1);
legend1=legend(handles.axes1);
set(legend1,'visible','off');
%update handles, and call listbox draw function
handles.listOfPlots={};
handles.counter=1;
guidata(hObject,handles);
data_set_listbox_CreateFcn(hObject, [], handles);

%this load button seems to only work if the directory is already selected
%in the matlab window
% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%prompt user to load files, populate FileNames with the list of selected
%files
[FileNames,~] = uigetfile({'*.*', 'All Files'},'Load trough datasets','MultiSelect','on');
%if no files selected, FileNames returns 0
if isnumeric(FileNames)
    disp('No file selected');
else
    %import data from files, store as x,y array in handles.FileName
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
end
%update listBoxSentinal to draw datasets, redraw listbox, update handles
global listBoxSentinel;
listBoxSentinel=1;
data_set_listbox_CreateFcn(hObject, [], handles);
guidata(hObject,handles);


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

%toggle to turn hold on or off on the axes
if (get(hObject,'Value') == get(hObject,'Max'))
    hold(handles.axes1, 'on');
else
    hold(handles.axes1, 'off');
end
guidata(hObject,handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%saveFig=handles.axes1;

%prompt user with dialog box to input name of save file
prompt='Enter File Name';
saveName=inputdlg(prompt,'Save Figure',[1 50]);
%open a new figure, copy GUI axes into new figure, and save to pdf
newFig=figure;
copyobj([handles.currentPlotAxes;handles.currentPlotLegend],newFig);
set(newFig, 'Units', 'normalized', 'Position', [114 15 89 30]);
newFig.PaperPositionMode = 'auto';
print(newFig,'-dpdf',saveName{1});
close(newFig);
%confirm in command window that figure has been saved
disp('Saved file:');
disp(saveName{1});