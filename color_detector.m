function varargout = color_detector(varargin)
% COLOR_DETECTOR MATLAB code for color_detector.fig
%      COLOR_DETECTOR, by itself, creates a new COLOR_DETECTOR or raises the existing
%      singleton*.
%
%      H = COLOR_DETECTOR returns the handle to a new COLOR_DETECTOR or the handle to
%      the existing singleton*.
%
%      COLOR_DETECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COLOR_DETECTOR.M with the given input arguments.
%
%      COLOR_DETECTOR('Property','Value',...) creates a new COLOR_DETECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before color_detector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to color_detector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help color_detector

% Last Modified by GUIDE v2.5 26-Jul-2021 22:32:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @color_detector_OpeningFcn, ...
                   'gui_OutputFcn',  @color_detector_OutputFcn, ...
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


% --- Executes just before color_detector is made visible.
function color_detector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to color_detector (see VARARGIN)

% Choose default command line output for color_detector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes color_detector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = color_detector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
global rgbImage
K = get(handles.listbox1, 'value');
red = rgbImage(:,:,1);
green = rgbImage(:,:,2);
blue = rgbImage(:,:,3);
switch K
    case 2
        % color bands
        % red
        redband = (red<=255 & red>180);
        greenband = (green<=120);
        blueband = (blue<=100);
        % mask
        det = redband & greenband & blueband;
    case 3
        % orange
        % color bands
        redband = (red<=255 & red>160);
        greenband = (green<=165 & green>0);
        blueband = (blue<10);
        % mask
        det = redband & greenband & blueband;
    case 4
        % yellow
        redband = (red<=255 & red>160);
        greenband = (green<=255 & green>160);
        blueband = (blue<10);
        det = redband & greenband & blueband;
    case 5
        % green
        redband = (red<=125);
        greenband = (green<=255 & green>100);
        blueband = (blue<=180);
        det = redband & greenband & blueband;
    case 6
        %blue
        redband = (red<=50);
        greenband = (green<=200);
        blueband = (blue<=255 & blue>130);
        det = redband & greenband & blueband;
    case 7
        % indigo
        redband = (red<=140);
        greenband = (green<65);
        blueband = (blue<=170);
        det = redband & greenband & blueband;
    case 8
        % violet
        redband = (red<=255 & red>100);
        greenband = (green<40);
        blueband = (blue<=255 & blue>=120);
        det = redband & greenband & blueband;
    
        
    otherwise
        disp('No filter');
        det = 0;
       
end

axes(handles.axes2);
if sum(det) == 0
    disp('Color not detected');
    imshow(rgb2gray(rgbImage));
else
    %image enhancement
    det_1 = imfill(det, 'holes');
    det_2 = bwmorph(det_1, 'dilate',3);
    detect = imfill(det_2, 'holes');
    %highlight the image
    %img_high = imoverlay(rgbImage,detect,'black');
    detect = cast(detect, class(red));
    maskedImageR = detect .* red;
	maskedImageG = detect .* green; 
	maskedImageB = detect .* blue;
    maskedRGBImage = cat(3, maskedImageR, maskedImageG, maskedImageB);
    imshow(maskedRGBImage);
    %imshow(img_high)
end
    


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rgbImage
[file,path] = uigetfile(('*.*'));
img_path = fullfile(path, file);
rgbImage = imread(img_path);
axes(handles.axes1);
imshow(rgbImage);