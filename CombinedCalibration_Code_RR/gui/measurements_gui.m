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
    
    
