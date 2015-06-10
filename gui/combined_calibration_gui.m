function varargout = combined_calibration_gui(varargin)
% COMBINED_CALIBRATION_GUI MATLAB code for combined_calibration_gui.fig
%      COMBINED_CALIBRATION_GUI, by itself, creates a new COMBINED_CALIBRATION_GUI or raises the existing
%      singleton*.
%
%      H = COMBINED_CALIBRATION_GUI returns the handle to a new COMBINED_CALIBRATION_GUI or the handle to
%      the existing singleton*.
%
%      COMBINED_CALIBRATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMBINED_CALIBRATION_GUI.M with the given input arguments.
%
%      COMBINED_CALIBRATION_GUI('Property','Value',...) creates a new COMBINED_CALIBRATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before combined_calibration_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to combined_calibration_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help combined_calibration_gui

% Last Modified by GUIDE v2.5 27-May-2015 23:19:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @combined_calibration_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @combined_calibration_gui_OutputFcn, ...
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


% --- Executes just before combined_calibration_gui is made visible.
function combined_calibration_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to combined_calibration_gui (see VARARGIN)

% Choose default command line output for combined_calibration_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes combined_calibration_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = combined_calibration_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calibration_phase.
function calibration_phase_Callback(hObject, eventdata, handles)
% hObject    handle to calibration_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    calibration_process_gui;

% --- Executes on button press in measurements_phase.
function measurements_phase_Callback(hObject, eventdata, handles)
% hObject    handle to measurements_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    measurements_gui;
