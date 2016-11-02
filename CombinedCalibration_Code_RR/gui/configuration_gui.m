function varargout = configuration_gui(varargin)
% CONFIGURATION_GUI MATLAB code for configuration_gui.fig
%      CONFIGURATION_GUI, by itself, creates a new CONFIGURATION_GUI or raises the existing
%      singleton*.
%
%      H = CONFIGURATION_GUI returns the handle to a new CONFIGURATION_GUI or the handle to
%      the existing singleton*.
%
%      CONFIGURATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGURATION_GUI.M with the given input arguments.
%
%      CONFIGURATION_GUI('Property','Value',...) creates a new CONFIGURATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before configuration_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to configuration_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help configuration_gui

% Last Modified by GUIDE v2.5 11-Jun-2015 04:17:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @configuration_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @configuration_gui_OutputFcn, ...
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


% --- Executes just before configuration_gui is made visible.
function configuration_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to configuration_gui (see VARARGIN)

% Choose default command line output for configuration_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes configuration_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = configuration_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in speedofsoundnextBtn.
function speedofsoundnextBtn_Callback(hObject, eventdata, handles)
% hObject    handle to speedofsoundnextBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getspeedofsoundReferenceFrame;

% --- Executes on button press in internalDelayNextBtn.
function internalDelayNextBtn_Callback(hObject, eventdata, handles)
% hObject    handle to internalDelayNextBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load 'internalDelay';
if clickCounter==2
    %call the method of internal delay estimation 
    internalDelayEstimation;
else 
    %print a guidance message for the user 
    message = 'Connect output channel1 to input channel1. Press Next when the setup is ready';
    set(handles.internalDelayTag,'String',message);
    clickCounter=clickCounter+1;
    save('internalDelay','clickCounter');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO) eventdata  reserved - to be defined
% in a future version of MATLAB handles    structure with handles and user
% data (see GUIDATA)
nMics=str2num(handles.nMics.String);
nSpeakers=str2num(handles.nSpeakers.String);
nImages=str2num(handles.nImages.String);
T=str2num(handles.signalLength.String)
Fs=str2num(handles.samplingFrequency.String)
val = get(handles.calibsignalchooser,'Value');
calibSound=generateCalibrationSound(val,T,Fs);
calibSound=calibSound(:);
syncChanelIn=4;
syncChanelOut=7;
clickCounter=1;
save('internalDelay','clickCounter');
save('primary_calibration_data','nMics','nSpeakers','nImages','calibSound','T','Fs','syncChanelIn','syncChanelOut');
%disable all he un-necessary fields
set(handles.start,'Enable','off');
set(handles.nMics,'Enable','off');
set(handles.nSpeakers,'Enable','off'); 
set(handles.nImages,'Enable','off');
set(handles.calibsignalchooser,'Enable','off'); 
set(handles.signalLength,'Enable','off'); 
set(handles.samplingFrequency,'Enable','off'); 


function signalLength_Callback(hObject, eventdata, handles)
% hObject    handle to samplingFrequency (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA) Hints: get(hObject,'String') returns contents
% of samplingFrequency as text
%        str2double(get(hObject,'String')) returns contents of samplingFrequency
%        as a double
    
    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function signalLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplingFrequency (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called Hint: edit controls usually
% have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function samplingFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to samplingFrequency (see GCBO) eventdata  reserved -
% to be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA) Hints: get(hObject,'String') returns
% contents of samplingFrequency as text
%        str2double(get(hObject,'String')) returns contents of
%        samplingFrequency as a double

    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function samplingFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplingFrequency (see GCBO) eventdata  reserved -
% to be defined in a future version of MATLAB handles    empty - handles
% not created until after all CreateFcns called Hint: edit controls usually
% have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function nMics_Callback(hObject, eventdata, handles)
% hObject    handle to nMics (see GCBO) eventdata  reserved - to be defined
% in a future version of MATLAB handles    structure with handles and user
% data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of nMics as text
%        str2double(get(hObject,'String')) returns contents of nMics as a
%        double

    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function nMics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nMics (see GCBO) eventdata  reserved - to be defined
% in a future version of MATLAB handles    empty - handles not created
% until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nSpeakers_Callback(hObject, eventdata, handles)
% hObject    handle to nSpeakers (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of nSpeakers as text
%        str2double(get(hObject,'String')) returns contents of nSpeakers as
%        a double

    guidata(hObject,handles);
    
    
% --- Executes during object creation, after setting all properties.
function nSpeakers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nSpeakers (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nImages_Callback(hObject, eventdata, handles)
% hObject    handle to nImages (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of nImages as text
%        str2double(get(hObject,'String')) returns contents of nImages as a
%        double

    guidata(hObject,handles);
    
    
% --- Executes during object creation, after setting all properties.
function nImages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nImages (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in calibsignalchooser.
function calibsignalchooser_Callback(hObject, eventdata, handles)
% hObject    handle to calibsignalchooser (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA) Hints: contents =
% cellstr(get(hObject,'String')) returns calibsignalchooser contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        calibsignalchooser
   % Determine the selected data set.
    str = get(hObject, 'String');
    val = get(hObject,'Value');
    % Set current data to the selected data set.
    switch str{val};
    case 'Maximum Length Sequence' % generates a maximum length sequences
       handles.calibSignal = 'call the function that generates the mls ';
    case 'Chirp Signal' % User selects membrane.
       handles.calibSignal = 'call the function that generates the chirp signal ';
    end
    


% --- Executes during object creation, after setting all properties.
function calibsignalchooser_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calibsignalchooser (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called Hint: popupmenu controls
% usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in begin.
function begin_Callback(hObject, eventdata, handles)
% hObject    handle to begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp 'preview camera'
cam=webcam('Logitech Camera');
preview(cam);
message1=['Put a reference microphone on a stan in front of the microphone array'];
message2=['The corner of the calibration rig has to be placed at the center of the reference microphone'];
message3=['Press Next to take the image'];
set(handles.speedofsound_t1,'String',message1);
set(handles.speedofsound_t2,'String',message2);
set(handles.speedofsound_t3,'String',message3);
