function varargout = calibration_process_gui(varargin)
% CALIBRATION_PROCESS_GUI MATLAB code for calibration_process_gui.fig
%      CALIBRATION_PROCESS_GUI, by itself, creates a new CALIBRATION_PROCESS_GUI or raises the existing
%      singleton*.
%
%      H = CALIBRATION_PROCESS_GUI returns the handle to a new CALIBRATION_PROCESS_GUI or the handle to
%      the existing singleton*.
%
%      CALIBRATION_PROCESS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATION_PROCESS_GUI.M with the given input arguments.
%
%      CALIBRATION_PROCESS_GUI('Property','Value',...) creates a new CALIBRATION_PROCESS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calibration_process_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calibration_process_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calibration_process_gui

% Last Modified by GUIDE v2.5 28-May-2015 02:13:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calibration_process_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @calibration_process_gui_OutputFcn, ...
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


% --- Executes just before calibration_process_gui is made visible.
function calibration_process_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calibration_process_gui (see VARARGIN)

% Choose default command line output for calibration_process_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calibration_process_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calibration_process_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in camCalib.
function camCalib_Callback(hObject, eventdata, handles)
% hObject    handle to camCalib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    calib_gui_normal;

% --- Executes on button press in mapSrcCoord.
function mapSrcCoord_Callback(hObject, eventdata, handles)
% hObject    handle to mapSrcCoord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mapSoundSrcCoordToCam;

% --- Executes on button press in compDelays.
function compDelays_Callback(hObject, eventdata, handles)
% hObject    handle to compDelays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('primary_calibration_data');
    load('Calib_Results');
    s = zeros(2*T*Fs,1); %create a signal that is 4 seconds long
    s(1:T*Fs,1) = 0.9*calibSound(1:T*Fs); 
    disp 'Computing TOFs...';
    Delta=ComputeDelaysV2(nImages,nSpeakers,nMics,Fs,s,active_images);%ComputeDelays(nImages,nSpeakers,nMics,Fs,s);
    disp 'saving Delta ...';
    save('Delta','Delta');
    disp 'Completed';

% --- Executes on button press in findMicsPos.
function findMicsPos_Callback(hObject, eventdata, handles)
% hObject    handle to findMicsPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in export.
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
