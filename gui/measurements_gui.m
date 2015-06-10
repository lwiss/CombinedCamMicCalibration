function varargout = measurements_gui(varargin)
% MEASUREMENTS_GUI MATLAB code for measurements_gui.fig
%      MEASUREMENTS_GUI, by itself, creates a new MEASUREMENTS_GUI or
%      raises the existing singleton*.
%
%      H = MEASUREMENTS_GUI returns the handle to a new MEASUREMENTS_GUI or
%      the handle to the existing singleton*.
%
%      MEASUREMENTS_GUI('CALLBACK',hObject,eventData,handles,...) calls the
%      local function named CALLBACK in MEASUREMENTS_GUI.M with the given
%      input arguments.
%
%      MEASUREMENTS_GUI('Property','Value',...) creates a new
%      MEASUREMENTS_GUI or raises the existing singleton*.  Starting from
%      the left, property value pairs are applied to the GUI before
%      measurements_gui_OpeningFcn gets called.  An unrecognized property
%      name or invalid value makes property application stop.  All inputs
%      are passed to measurements_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help measurements_gui

% Last Modified by GUIDE v2.5 26-May-2015 23:06:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @measurements_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @measurements_gui_OutputFcn, ...
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


% --- Executes just before measurements_gui is made visible.
function measurements_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn. hObject    handle to
% figure eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) varargin
% command line arguments to measurements_gui (see VARARGIN)

% Choose default command line output for measurements_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = measurements_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT); hObject
% handle to figure eventdata  reserved - to be defined in a future version
% of MATLAB handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in takeImage.
function takeImage_Callback(hObject, eventdata, handles)
% hObject    handle to takeImage (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)

set(handles.takeImage,'Enable','off');

load('primary_calibration_data');
load('current_workspace');

%code for taking an image with the image acquisition toolbox of matlab
%then reflect the image save it into a .tif file
%show it in the figure part 


set(handles.expInstruction1,'String',['Image ' num2str(my_current_image) ' OK']);
set(handles.expInstruction2,'String',['Speaker ' num2str(my_current_speaker) '/' num2str(nSpeakers)]);
set(handles.recordfromSp,'Enable','on');




% --- Executes on button press in recordfromSp.
function recordfromSp_Callback(hObject, eventdata, handles)
% hObject    handle to recordfromSp (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
   set(handles.recordfromSp,'Enable','off');
   load('primary_calibration_data');
   load('current_workspace');

%code that records from a speaker 
    %y=soundDataAcquisition(calibSound,my_current_speaker,T,Fs,1024,nMics);
    y=soundDataAcquisitionWithSync(calibSound,my_current_speaker,T,Fs,1024,nMics,syncChanelIn,syncChanelOut);
    measurements(my_current_speaker,:,:) =y;
    pause (1);
    if my_current_speaker<nSpeakers
       set(handles.recordfromSp,'Enable','on'); 
       my_current_speaker=my_current_speaker+1;
       set(handles.expInstruction2,'String',['Speaker ' num2str(my_current_speaker) '/' num2str(nSpeakers)]);
       save('current_workspace','measurements','my_current_image','my_current_speaker');
    else 
        set(handles.recordfromSp,'Enable','off'); 
        save(['calib_sounds_pos' num2str(my_current_image)],'measurements');
        if my_current_image==nImages % end of the experiments
           set(handles.expInstruction1,'String','Measurement phase');
           set(handles.expInstruction2,'String','Status : OK');
        else 
           set(handles.expInstruction2,'String',['Speaker ' num2str(my_current_speaker) '/' num2str(nSpeakers)]);
           measurements=zeros(nSpeakers,2*T*Fs,nMics+1);
           my_current_speaker=1;
           my_current_image=my_current_image+1;
           save('current_workspace','measurements','my_current_image','my_current_speaker');
           set(handles.expInstruction1,'String',['Image ' num2str(my_current_image) ]);
           set(handles.expInstruction2,'String','');
           set(handles.takeImage,'Enable','on'); 
        end
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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA) Hints: contents =
% cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popupmenu1
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
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called Hint: popupmenu controls
% usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO) eventdata  reserved - to be defined
% in a future version of MATLAB handles    structure with handles and user
% data (see GUIDATA)
nMics=str2num(handles.nMics.String);
nSpeakers=str2num(handles.nSpeakers.String);
nImages=str2num(handles.nImages.String);
T=str2num(handles.signalLength.String);
Fs=str2num(handles.samplingFrequency.String);
val = get(handles.popupmenu1,'Value');
calibSound=generateCalibrationSound(val,T,Fs);
calibSound=calibSound(:);
syncChanelIn=4;
syncChanelOut=7;
save('primary_calibration_data','nMics','nSpeakers','nImages','calibSound','T','Fs','syncChanelIn','syncChanelOut');
%disable all he un-necessary fields
set(handles.start,'Enable','off');
set(handles.nMics,'Enable','off');
set(handles.nSpeakers,'Enable','off'); 
set(handles.nImages,'Enable','off');
set(handles.popupmenu1,'Enable','off'); 
set(handles.samplingFrequency,'Enable','off'); 
set(handles.signalLength,'Enable','off'); 




% --- Executes on button press in saveData.
function saveData_Callback(hObject, eventdata, handles)
% hObject    handle to saveData (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)


% --- Executes on button press in endMeasurement.
function endMeasurement_Callback(hObject, eventdata, handles)
% hObject    handle to endMeasurement (see GCBO) eventdata  reserved - to
% be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA)



function signalLength_Callback(hObject, eventdata, handles)
% hObject    handle to signalLength (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA) Hints: get(hObject,'String') returns contents
% of signalLength as text
%        str2double(get(hObject,'String')) returns contents of signalLength
%        as a double
    
    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function signalLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signalLength (see GCBO) eventdata  reserved - to be
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


% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
    set(handles.record,'Enable','off');
    load('primary_calibration_data');
    load('speakersReferenceRecording');

    y=speakersReferenceRecordingAcquisition(calibSound,T,Fs,1024,1,activeSpeaker, handles);
    speakersReferenceRecording(:,activeSpeaker) = y;
    
    if activeSpeaker<nSpeakers
       set(handles.instructionMsg1,'String',...
           ['fix the microphone at a distance of 2 mm from speaker ' num2str(activeSpeaker+1)]);
       set(handles.instructionMsg2,'String','press RECORD when you are ready to continue');
       set(handles.record,'Enable','on'); 
       activeSpeaker=activeSpeaker+1;
       save('speakersReferenceRecording','speakersReferenceRecording','activeSpeaker');
       guidata(hObject,handles);
    else
       save('speakersReferenceRecording','speakersReferenceRecording','activeSpeaker');
       set(handles.instructionMsg1,'String','Reference Recordings Acquisition');
       set(handles.instructionMsg2,'String','Status : DONE');
    end

    
% --- Executes on button press in startAcquisition.
function startAcquisition_Callback(hObject, eventdata, handles)
% hObject    handle to startAcquisition (see GCBO) eventdata  reserved - to
% be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA)
    set(handles.instructionMsg,'String','Starting...');
    set(handles.instructionMsg1,'String','fix the microphone at a distance of 2 mm from the first speaker');
    set(handles.instructionMsg2,'String','press RECORD when you are ready to continue');
    load('primary_calibration_data');
    speakersReferenceRecording=zeros(T*Fs,nSpeakers);
    activeSpeaker=1;
    save('speakersReferenceRecording','speakersReferenceRecording','activeSpeaker');
    set(handles.record,'Enable','on');
    set(handles.startAcquisition,'Enable','off');


% --- Executes on button press in startMeasurements.
function startMeasurements_Callback(hObject, eventdata, handles)
% hObject    handle to startMeasurements (see GCBO) eventdata  reserved -
% to be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA)
    if ~exist('current_workspace.mat') % the first time user clics
        set(handles.expInstruction1,'String','Starting... Image 1');
        %set(handles.expInstruction2,'String',['Speaker 1 ']);
        load('primary_calibration_data');
        measurements=zeros(nSpeakers,2*T*Fs,nMics+1); % the matrix that will contain the measurement for each position
        my_current_image=1;
        my_current_speaker=1;
        save('current_workspace','measurements','my_current_image','my_current_speaker');
        set(handles.takeImage,'Enable','on');
    else 
        load('primary_calibration_data');
        load('current_workspace');
        if my_current_speaker==1
            set(handles.expInstruction1,'String',['Image ' num2str(my_current_image)]);
            set(handles.expInstruction2,'String',['Speaker 1 / ' num2str(nSpeakers)]);
            set(handles.takeImage,'Enable','on');
        else 
            set(handles.expInstruction1,'String',['Image ' num2str(my_current_image) ' OK']);
            set(handles.expInstruction2,'String',['Speaker ' num2str(my_current_speaker) '/' num2str(nSpeakers)]);
            set(handles.takeImage,'Enable','off');
            set(handles.recordfromSp,'Enable','on');
        end
    
    end
    set(handles.startMeasurements,'Enable','off');
    
    
