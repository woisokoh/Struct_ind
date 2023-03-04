function varargout = slide_plot2(varargin)
% SLIDE_PLOT2 MATLAB code for slide_plot2.fig
%      SLIDE_PLOT2, by itself, creates a new SLIDE_PLOT2 or raises the existing
%      singleton*.
%
%      H = SLIDE_PLOT2 returns the handle to a new SLIDE_PLOT2 or the handle to
%      the existing singleton*.
%
%      SLIDE_PLOT2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SLIDE_PLOT2.M with the given input arguments.
%
%      SLIDE_PLOT2('Property','Value',...) creates a new SLIDE_PLOT2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before slide_plot2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to slide_plot2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help slide_plot2

% Last Modified by GUIDE v2.5 03-Mar-2023 23:40:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @slide_plot2_OpeningFcn, ...
                   'gui_OutputFcn',  @slide_plot2_OutputFcn, ...
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


% --- Executes just before slide_plot2 is made visible.
function slide_plot2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to slide_plot2 (see VARARGIN)

% Choose default command line output for slide_plot2
handles.output = hObject;
global maxt x deltas
set(handles.slider1,'Max',maxt);
set(handles.slider1,'Value',0);
network_plot(handles);
set(handles.edit1,'Value',0);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes slide_plot2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = slide_plot2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


network_plot(handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function network_plot(handles)
global maxt x deltas
time = round(get(handles.slider1,'Value'))+1;
tx = num2str(time-1);
set(handles.edit1,'String',time);
ax1 = findobj(gcf,'Tag','axes1');
axes(ax1)
g = graph(deltas{time});
colormap(flipud(cool))
p1 = plot(g);
title('Temporal network structures')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
layout(p1,'force','UseGravity',true);
g.Nodes.NodeColors = x(:,time);
p1.NodeCData = g.Nodes.NodeColors;
p1.MarkerSize = 5;
c1 = colorbar;
set(get(c1,'label'),'string','Opinion state');





function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
