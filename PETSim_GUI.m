function varargout = PETSim_GUI(varargin)
% PETSIM_GUI MATLAB code for PETSim_GUI.fig
%      PETSIM_GUI, by itself, creates a new PETSIM_GUI or raises the existing
%      singleton*.
%
%      H = PETSIM_GUI returns the handle to a new PETSIM_GUI or the handle to
%      the existing singleton*.
%
%      PETSIM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PETSIM_GUI.M with the given input arguments.
%
%      PETSIM_GUI('Property','Value',...) creates a new PETSIM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PETSim_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PETSim_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PETSim_GUI

% Last Modified by GUIDE v2.5 01-Oct-2014 09:26:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PETSim_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PETSim_GUI_OutputFcn, ...
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


% --- Executes just before PETSim_GUI is made visible.
function PETSim_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PETSim_GUI (see VARARGIN)

% set the name of the GUI
set(hObject, 'Name', 'PETSTEP');

% Choose default command line output for PETSim_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PETSim_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PETSim_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiwait
% Get default command line output from handles structure
varargout = {handles.output};


% --- Executes on selection change in Sitelistbox.
function Sitelistbox_Callback(hObject, eventdata, handles)
% hObject    handle to Sitelistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Sitelistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Sitelistbox
val=get(hObject,'Value');
Sites=handles.Sites;
s=Sites(val);
site=char(s);
handles.site=site;
switch site
    case 'Brain'
h=SimParam_Brain(handles);
handles=h;
                
         set(findobj('Tag','maxSUVEdit'),'String',num2str(handles.maxSUV));
%         handles.maxSUV=7;
         set(findobj('Tag','ContrastEdit'),'String',num2str(handles.maxCtrast));
%         handles.maxCtrast=0.125;
         set(findobj('Tag','BlurEdit'),'String',num2str(handles.blurSize));
%         handles.blurSize=4;

         % counts parameters
         set(findobj('Tag','RFEdit'),'String',num2str(handles.RF));
%         handles.RF=0.4;
         set(findobj('Tag','SFEdit'),'String',num2str(handles.SF));
         set(findobj('Tag','SensitivityEdit'),'String',num2str(handles.Se));
         set(findobj('Tag','ActivityEdit'),'String',num2str(handles.ActV));
         set(findobj('Tag','ScanTimeEdit'),'String',num2str(handles.ScanTime));
         set(findobj('Tag','OverlapEdit'),'String',num2str(handles.overlap));
%         handles.SF=0.4;
%          set(findobj('Tag','TotalCountsEdit'),'String',num2str(handles.counts));
% %         handles.counts=4000000;
% countsRandoms = round(handles.counts*handles.RF);
% countsScatter = round((handles.counts - countsRandoms)*handles.SF);
% countsTrue = handles.counts - countsRandoms - countsScatter;
% nec=round(countsTrue^2/(countsRandoms+countsScatter+countsTrue)/1000);
% set(findobj('Tag','NECtext'),'String',num2str(nec));

%         % scanner parameters
         set(findobj('Tag','RadBinEdit'),'String',num2str(handles.radBin));
%         handles.radBin=329;
         set(findobj('Tag','TanBinEdit'),'String',num2str(handles.tanBin));
         set(findobj('Tag','RingEdit'),'String',num2str(handles.RingSize));
%         handles.tanBin=280;
         set(findobj('Tag','PSFEdit'),'String',num2str(handles.PSF));
%         handles.PSF=4;
        set(findobj('Tag','matchcheckbox'),'Value',1);
          if get(findobj('Tag','matchcheckbox'),'Value')==1
            val=get(findobj('Tag','BlurEdit'),'String');
             set(findobj('Tag','PSFEdit'),'String',val);   
          end

%         % reconstruction parameters
         set(findobj('Tag','SimSizeEdit'),'String',num2str(handles.SimSize));
%         handles.SimSize=256;
         set(findobj('Tag','PostFilterEdit'),'String',num2str(handles.postFilter));
%         handles.postFilter=4;
         set(findobj('Tag','IterEdit'),'String',num2str(handles.IterNum));
%         handles.IterNum=4;
         set(findobj('Tag','SubsetEdit'),'String',num2str(handles.SubNum));
%         handles.SubNum=14;
         handles.nRep=1;
    case 'H&N'
 %tumor parameters
h=SimParam_HN(handles);
handles=h;
                
         set(findobj('Tag','maxSUVEdit'),'String',num2str(handles.maxSUV));
%         handles.maxSUV=19;
         set(findobj('Tag','ContrastEdit'),'String',num2str(handles.maxCtrast));
%         handles.maxCtrast=0.125;
         set(findobj('Tag','BlurEdit'),'String',num2str(handles.blurSize));
%         handles.blurSize=4;

         % counts parameters
         set(findobj('Tag','RFEdit'),'String',num2str(handles.RF));
%         handles.RF=0.4;
         set(findobj('Tag','SFEdit'),'String',num2str(handles.SF));
         set(findobj('Tag','SensitivityEdit'),'String',num2str(handles.Se));
         set(findobj('Tag','ActivityEdit'),'String',num2str(handles.ActV));
         set(findobj('Tag','ScanTimeEdit'),'String',num2str(handles.ScanTime));
         set(findobj('Tag','OverlapEdit'),'String',num2str(handles.overlap));
%         handles.SF=0.4;
%          set(findobj('Tag','TotalCountsEdit'),'String',num2str(handles.counts));
% %         handles.counts=2000000;
% countsRandoms = round(handles.counts*handles.RF);
% countsScatter = round((handles.counts - countsRandoms)*handles.SF);
% countsTrue = handles.counts - countsRandoms - countsScatter;
% nec=round(countsTrue^2/(countsRandoms+countsScatter+countsTrue)/1000);
% set(findobj('Tag','NECtext'),'String',num2str(nec));

%         % scanner parameters
         set(findobj('Tag','RadBinEdit'),'String',num2str(handles.radBin));
%         handles.radBin=329;
         set(findobj('Tag','TanBinEdit'),'String',num2str(handles.tanBin));
         set(findobj('Tag','RingEdit'),'String',num2str(handles.RingSize));
%         handles.tanBin=280;
  %       set(findobj('Tag','PSFEdit'),'String',num2str(handles.PSF));
%         handles.PSF=4;
        set(findobj('Tag','matchcheckbox'),'Value',1);
          if get(findobj('Tag','matchcheckbox'),'Value')==1
            val=get(findobj('Tag','BlurEdit'),'String');
            set(findobj('Tag','PSFEdit'),'String',val);   
          end

%         % reconstruction parameters
         set(findobj('Tag','SimSizeEdit'),'String',num2str(handles.SimSize));
%         handles.SimSize=256;
         set(findobj('Tag','PostFilterEdit'),'String',num2str(handles.postFilter));
%         handles.postFilter=6;
         set(findobj('Tag','IterEdit'),'String',num2str(handles.IterNum));
%         handles.IterNum=4;
         set(findobj('Tag','SubsetEdit'),'String',num2str(handles.SubNum));
%         handles.SubNum=14;
         handles.nRep=1;
    case 'Whole Body'
 %tumor parameters
h=SimParam_WB(handles);
handles=h;
                
         set(findobj('Tag','maxSUVEdit'),'String',num2str(handles.maxSUV));
%         handles.maxSUV=7;
         set(findobj('Tag','ContrastEdit'),'String',num2str(handles.maxCtrast));
%         handles.maxCtrast=0.125;
         set(findobj('Tag','BlurEdit'),'String',num2str(handles.blurSize));
%         handles.blurSize=4;

         % counts parameters
         set(findobj('Tag','RFEdit'),'String',num2str(handles.RF));
%         handles.RF=0.4;
         set(findobj('Tag','SFEdit'),'String',num2str(handles.SF));
         set(findobj('Tag','SensitivityEdit'),'String',num2str(handles.Se));
         set(findobj('Tag','ActivityEdit'),'String',num2str(handles.ActV));
         set(findobj('Tag','ScanTimeEdit'),'String',num2str(handles.ScanTime));
         set(findobj('Tag','OverlapEdit'),'String',num2str(handles.overlap));
%         handles.SF=0.4;
%          set(findobj('Tag','TotalCountsEdit'),'String',num2str(handles.counts));
% %         handles.counts=4000000;
% countsRandoms = round(handles.counts*handles.RF);
% countsScatter = round((handles.counts - countsRandoms)*handles.SF);
% countsTrue = handles.counts - countsRandoms - countsScatter;
% nec=round(countsTrue^2/(countsRandoms+countsScatter+countsTrue)/1000);
% set(findobj('Tag','NECtext'),'String',num2str(nec));

%         % scanner parameters
         set(findobj('Tag','RadBinEdit'),'String',num2str(handles.radBin));
%         handles.radBin=329;
         set(findobj('Tag','TanBinEdit'),'String',num2str(handles.tanBin));
         set(findobj('Tag','RingEdit'),'String',num2str(handles.RingSize));
%         handles.tanBin=280;
        % set(findobj('Tag','PSFEdit'),'String',num2str(handles.PSF));
%         handles.PSF=4;
            set(findobj('Tag','matchcheckbox'),'Value',1);
            if get(findobj('Tag','matchcheckbox'),'Value')==1
            val=get(findobj('Tag','BlurEdit'),'String');
            set(findobj('Tag','PSFEdit'),'String',val);   
            end

%         % reconstruction parameters
         set(findobj('Tag','SimSizeEdit'),'String',num2str(handles.SimSize));
%         handles.SimSize=256;
         set(findobj('Tag','PostFilterEdit'),'String',num2str(handles.postFilter));
%         handles.postFilter=4;
         set(findobj('Tag','IterEdit'),'String',num2str(handles.IterNum));
%         handles.IterNum=4;
         set(findobj('Tag','SubsetEdit'),'String',num2str(handles.SubNum));
%         handles.SubNum=14;
%         handles.nRep=1;
        
end

handles.OSEM=0;
handles.OSEMPSF=0;
handles.FBP=0;
handles.Additive=0;
handles.Preexist='false';

set(findobj('Tag','Instructions'),'Visible','off');
% make panels visible
% tumor panel
set(findobj('Tag','tumorPanel'),'Visible','on');
set(findobj('Tag','maxSUVEdit'),'Visible','on');
set(findobj('Tag','maxSUVText'),'Visible','on');
set(findobj('Tag','ContrastEdit'),'Visible','on');
set(findobj('Tag','ContrastText'),'Visible','on');
set(findobj('Tag','BlurEdit'),'Visible','on');
set(findobj('Tag','BlurText'),'Visible','on');
set(findobj('Tag','AdditiveCheckbox'),'Visible','on');
set(findobj('Tag','PETscanUsedCheckbox'),'Visible','on');

% counts panel
set(findobj('Tag','countPanel'),'Visible','on');
set(findobj('Tag','SensitivityEdit'),'Visible','on');
set(findobj('Tag','SensitivityText'),'Visible','on');
set(findobj('Tag','ScanTimeEdit'),'Visible','on');
set(findobj('Tag','ScanTimeText'),'Visible','on');
set(findobj('Tag','OverlapEdit'),'Visible','on');
set(findobj('Tag','OverlapText'),'Visible','on');
set(findobj('Tag','ActivityEdit'),'Visible','on');
set(findobj('Tag','ActivityText'),'Visible','on');
set(findobj('Tag','SFEdit'),'Visible','on');
set(findobj('Tag','SFText'),'Visible','on');
set(findobj('Tag','RFEdit'),'Visible','on');
set(findobj('Tag','RFText'),'Visible','on');
% set(findobj('Tag','NECtext'),'Visible','on');
% set(findobj('Tag','NECtext2'),'Visible','on');
% set(findobj('Tag','NECtext'),'Visible','on');


% Scanner panel
set(findobj('Tag','scannerSettingsPanel'),'Visible','on');
set(findobj('Tag','PSFEdit'),'Visible','on');
set(findobj('Tag','PSFText'),'Visible','on');

set(findobj('Tag','TanBinEdit'),'Visible','on');
set(findobj('Tag','TanBinText'),'Visible','on');
set(findobj('Tag','RingEdit'),'Visible','on');
set(findobj('Tag','RingText'),'Visible','on');
set(findobj('Tag','matchcheckbox'),'Visible','on');

% Reconstruction panel
set(findobj('Tag','reconstructionPanel'),'Visible','on');
set(findobj('Tag','ReconText'),'Visible','on');
set(findobj('Tag','ReconParamtext'),'Visible','on');
set(findobj('Tag','SimSizeEdit'),'Visible','on');
set(findobj('Tag','SimSizeText'),'Visible','on');
set(findobj('Tag','PostFilterEdit'),'Visible','on');
set(findobj('Tag','PostFilterText'),'Visible','on');
set(findobj('Tag','IterEdit'),'Visible','on');
set(findobj('Tag','IterText'),'Visible','on');
set(findobj('Tag','SubsetEdit'),'Visible','on');
set(findobj('Tag','SubsetText'),'Visible','on');
set(findobj('Tag','FBPCheckbox'),'Visible','on');
set(findobj('Tag','OSEMPSFCheckbox'),'Visible','on');
set(findobj('Tag','OSEMCheckbox'),'Visible','on');

set(findobj('Tag','RunButton'),'Visible','on');
set(findobj('Tag','RepEdit'),'Visible','on');
set(findobj('Tag','ZFilterText'),'Visible','on');
set(findobj('Tag','zFilterListbox'),'Visible','on');
set(findobj('Tag','LoadRepsCheckbox'),'Visible','on');
set(findobj('Tag','LoadIterCheckbox'),'Visible','on');
set(findobj('Tag','RepText'),'Visible','on');
set(findobj('Tag','SaveSimParamButton'),'Visible','on');

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Sitelistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sitelistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'Brain','H&N','Whole Body'});
handles.Sites={'Brain','H&N','Whole Body'};
guidata(hObject,handles);





function ScanTimeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ScanTimeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ScanTimeEdit as text
%        str2double(get(hObject,'String')) returns contents of ScanTimeEdit as a double
a=get(hObject,'String');
ScanTime=str2double(a);
handles.ScanTime=ScanTime;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ScanTimeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScanTimeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SFEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SFEdit as text
%        str2double(get(hObject,'String')) returns contents of SFEdit as a double
a=get(hObject,'String');
SF=str2double(a);
handles.SF=SF;
% countsRandoms = round(handles.counts*handles.RF);
% countsScatter = round((handles.counts - countsRandoms)*handles.SF);
% countsTrue = handles.counts - countsRandoms - countsScatter;
% nec=round(countsTrue^2/(countsRandoms+countsScatter+countsTrue)/1000);
% set(findobj('Tag','NECtext'),'String',num2str(nec));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function SFEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RFEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RFEdit as text
%        str2double(get(hObject,'String')) returns contents of RFEdit as a double
a=get(hObject,'String');
RF=str2double(a);
handles.RF=RF;
% countsRandoms = round(handles.counts*handles.RF);
% countsScatter = round((handles.counts - countsRandoms)*handles.SF);
% countsTrue = handles.counts - countsRandoms - countsScatter;
% nec=round(countsTrue^2/(countsRandoms+countsScatter+countsTrue)/1000);
% set(findobj('Tag','NECtext'),'String',num2str(nec));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function RFEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxSUVEdit_Callback(hObject, eventdata, handles)
% hObject    handle to maxSUVEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxSUVEdit as text
%        str2double(get(hObject,'String')) returns contents of maxSUVEdit as a double
a=get(hObject,'String');
maxSUV=str2double(a);
handles.maxSUV=maxSUV;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function maxSUVEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxSUVEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ContrastEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ContrastEdit as text
%        str2double(get(hObject,'String')) returns contents of ContrastEdit as a double
a=get(hObject,'String');
maxCtrast=str2double(a);
handles.maxCtrast=maxCtrast;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ContrastEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ContrastEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BlurEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BlurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BlurEdit as text
%        str2double(get(hObject,'String')) returns contents of BlurEdit as a double
a=get(hObject,'String');
blurSize=str2double(a);
handles.blurSize=blurSize;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function BlurEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlurEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AdditiveCheckbox.
function AdditiveCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to AdditiveCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AdditiveCheckbox

if get(hObject,'Value')==1

handles.Additive='true';
end
guidata(hObject,handles);


% --- Executes on button press in FBPCheckbox.
function FBPCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to FBPCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FBPCheckbox
if get(hObject,'Value')==1

handles.FBP='true';
end
guidata(hObject,handles);


% --- Executes on button press in OSEMCheckbox.
function OSEMCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to OSEMCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OSEMCheckbox
if get(hObject,'Value')==1

handles.OSEM='true';
end
guidata(hObject,handles);

% --- Executes on button press in OSEMPSFCheckbox.
function OSEMPSFCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to OSEMPSFCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OSEMPSFCheckbox
if get(hObject,'Value')==1

handles.OSEMPSF='true';
end
guidata(hObject,handles);

function SimSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SimSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SimSizeEdit as text
%        str2double(get(hObject,'String')) returns contents of SimSizeEdit as a double
a=get(hObject,'String');
SimSize=str2double(a);
handles.SimSize=SimSize;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function SimSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SimSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PostFilterEdit_Callback(hObject, eventdata, handles)
% hObject    handle to PostFilterEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PostFilterEdit as text
%        str2double(get(hObject,'String')) returns contents of PostFilterEdit as a double
a=get(hObject,'String');
postFilter=str2double(a);
handles.postFilter=postFilter;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function PostFilterEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PostFilterEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IterEdit_Callback(hObject, eventdata, handles)
% hObject    handle to IterEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IterEdit as text
%        str2double(get(hObject,'String')) returns contents of IterEdit as a double
a=get(hObject,'String');
IterNum=str2double(a);
handles.IterNum=IterNum;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function IterEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IterEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SubsetEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SubsetEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SubsetEdit as text
%        str2double(get(hObject,'String')) returns contents of SubsetEdit as a double
a=get(hObject,'String');
SubNum=str2double(a);
data=guidata(hObject);
% if isfield(data,'tanBin') && rem(data.tanBin,SubNum)~=0
%     warndlg('Warning: The projection bin value should be divisible by the number of subsets, please correct values')
% end
handles.SubNum=SubNum;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function SubsetEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SubsetEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TanBinEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TanBinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TanBinEdit as text
%        str2double(get(hObject,'String')) returns contents of TanBinEdit as a double
a=get(hObject,'String');
tanBin=str2double(a);
data=guidata(hObject);
% if isfield(data,'SubNum') && rem(tanBin,data.SubNum)~=0
%     warndlg('Warning: the projection bin value should be divisible by the number of subsets, please correct values')
% end
handles.tanBin=tanBin;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function TanBinEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TanBinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PSFEdit_Callback(hObject, eventdata, handles)
% hObject    handle to PSFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PSFEdit as text
%        str2double(get(hObject,'String')) returns contents of PSFEdit as a double
a=get(hObject,'String');
psf=str2double(a);
handles.PSF=psf;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function PSFEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSFEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in RunButton.
function RunButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% retrieve GUI data

global planC
indexS=planC{end};
global stateS



% find the list and type of available scans
ListScans={};
PT=zeros(1,length(planC{indexS.scan}));
CT=zeros(1,length(planC{indexS.scan}));
for i=1:length(planC{indexS.scan})
    ScanType=planC{indexS.scan}(i).scanInfo(1).imageType;
    if ~isempty(strfind(ScanType,'PET')) || ~isempty(strfind(ScanType,'PT'))
        PT(i)=1;
    end
    if ~isempty(strfind(ScanType,'CT')) 
        CT(i)=1;
    end
    ListScans=[ListScans, planC{indexS.scan}(i).scanType];
end

if sum(CT(:))>1
    CTscanNum=SelectScan(ListScans,CT,'CT');
else
    CTscanNum=find(CT==1);
end
    
if sum(PT(:))>1
    PTscanNum=SelectScan(ListScans,PT,'PT');
else
    PTscanNum=find(PT==1);
end       
    
data=guidata(hObject);

if isfield(data,'tanBin') && isfield(data,'SubNum') && rem(data.tanBin,data.SubNum)~=0
    warndlg('Warning: The projection bin value should be divisible by the number of subsets, please correct values')
end

if ~isfield(handles,'Preexist') || isempty(handles.Preexist)
    handles.Preexist='false';
end

maxSUV=data.maxSUV;
maxCtrast=data.maxCtrast;
Additive=data.Additive;
blurT=data.blurSize;
%countsTotal=data.counts;
RF=data.RF;
SF=data.SF;
psf=data.PSF;
tanBin=data.tanBin;
SimSize=data.SimSize;
RingSize=data.RingSize;
postFilter=data.postFilter;
IterNum=data.IterNum;
SubNum=data.SubNum;
nRep=data.nRep;
ScanTime=data.ScanTime;
ActV=data.ActV;
Se=data.Se;
overlap=data.overlap;
LOAD_REPS=data.LOAD_REPS;
LOAD_ITER=data.LOAD_ITER;
zFilterVal=data.zFilterListboxVal;
FBP=data.FBP;
OSEM=data.OSEM;
OSEMPSF=data.OSEMPSF;

switch zFilterVal % store in handles
    case 1
zFilter=[1,1,1];
    case 2
zFilter=[1,2,1];
    case 3
zFilter=[1,4,1];
    case 4
zFilter=[1,8,1];
end

opts=struct('CTscanNum',CTscanNum,'PTscanNum',PTscanNum,'maxSUV',maxSUV,'maxTRAST',maxCtrast,'USE_ADDITIVE',Additive,'blurT',blurT,'minRegionSize',3,'RF',RF,'SF',SF,'tanBin',tanBin,'RingData',RingSize,'psf',psf,'simSize',SimSize,'postFilter',postFilter,'iterNUM',IterNum,'subNUM',SubNum,'nREP',nRep,'FBP_OUT',FBP,'OS_OUT',OSEM,'OSpsf_OUT',OSEMPSF,'countSens',Se,'overlap',overlap,'activityConc',ActV,'dwellTime',ScanTime,'LOAD_REPS',LOAD_REPS,'LOAD_ITER',LOAD_ITER,'zFilter',zFilter);
if strcmp(handles.Preexist,'true')
    tumorBuilderPreExist_v1(planC,opts);
else
tumorBuilderObject_v1(planC,opts);
end
disp('Simulation complete')
uiresume
close(get(gcbo,'Parent'))


% --- Executes on button press in QuitButton.
function QuitButton_Callback(hObject, eventdata, handles)
% hObject    handle to QuitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume
close()



function RepEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RepEdit as text
%        str2double(get(hObject,'String')) returns contents of RepEdit as a double
a=get(hObject,'String');
nRep=str2double(a);
handles.nRep=nRep;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function RepEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PreexistCheckbox.
function PETscanUsedCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PreexistCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PreexistCheckbox
if get(hObject,'Value')==1

handles.Preexist='true';
end
guidata(hObject,handles);

% --- Executes on button press in SaveSimParamButton.
function SaveSimParamButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveSimParamButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=guidata(hObject);
maxSUV=data.maxSUV;
maxCtrast=data.maxCtrast;
blurT=data.blurSize;
RF=data.RF;
SF=data.SF;
psf=data.PSF;
tanBin=data.tanBin;
SimSize=data.SimSize;
RingSize=data.RingSize;
postFilter=data.postFilter;
IterNum=data.IterNum;
SubNum=data.SubNum;
nRep=data.nRep;
ScanTime=data.ScanTime;
ActV=data.ActV;
Se=data.Se;
Ov=data.overlap;
zFilterListboxVal=data.zFilterListboxVal;

prompt = {'Enter file name:'};
dlg_title = 'Saving simulation parameters';
num_lines = 1;
def = {'ParamListNew','hsv'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
name=[answer{1} '.m'];
fid = fopen(name, 'w');
fprintf(fid,'%s\n',['function handles=' answer{1} '(h)'], ...
['handles=h;'],['handles.maxSUV=' num2str(maxSUV) ';'], ...
['handles.maxCtrast=' num2str(maxCtrast) ';'],   ['handles.blurSize=' num2str(blurT) ';'], ...
    ['handles.RF=' num2str(RF) ';'], ['handles.SF=' num2str(SF) ';'], ['handles.PSF=' num2str(psf) ';'], ['handles.tanBin=' num2str(tanBin) ';'], ...
    ['handles.SimSize=' num2str(SimSize) ';'],['handles.RingSize=' num2str(RingSize) ';'], ['handles.postFilter=' num2str(postFilter) ';'], ['handles.IterNum=' num2str(IterNum) ';'], ...
['handles.SubNum=' num2str(SubNum) ';'],['handles.ScanTime=' num2str(ScanTime) ';'], ['handles.Se=' num2str(Se) ';'],['handles.overlap=' num2str(Ov) ';'],['handles.ActV=' num2str(ActV) ';'], ...
['handles.zFilterListboxVal=' num2str(zFilterListboxVal) ';'],['handles.nRep=' num2str(nRep) ';']);
fclose(fid);


% --- Executes on button press in CustomSiteButton.
function CustomSiteButton_Callback(hObject, eventdata, handles)
% hObject    handle to CustomSiteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,path]=uigetfile();
 %tumor parameters
 newpath=strrep(path,[pwd '/'],'');
 if isempty(newpath)
     newpath=[pwd '/'];
 end
cd(newpath(1:(end-1)));
eval(['fhandles=@' FileName(1:(end-2))]);
data=guidata(hObject);
h=feval(fhandles ,data);
handles=h;
                
         set(findobj('Tag','maxSUVEdit'),'String',num2str(handles.maxSUV));
%         handles.maxSUV=19;
         set(findobj('Tag','ContrastEdit'),'String',num2str(handles.maxCtrast));
%         handles.maxCtrast=0.125;
         set(findobj('Tag','BlurEdit'),'String',num2str(handles.blurSize));
%         handles.blurSize=4;

         % counts parameters
         set(findobj('Tag','RFEdit'),'String',num2str(handles.RF));
%         handles.RF=0.4;
         set(findobj('Tag','SFEdit'),'String',num2str(handles.SF));
%         handles.SF=0.4;
set(findobj('Tag','SensitivityEdit'),'String',num2str(handles.Se));
set(findobj('Tag','ActivityEdit'),'String',num2str(handles.ActV));
set(findobj('Tag','ScanTimeEdit'),'String',num2str(handles.ScanTime));
set(findobj('Tag','OverlapEdit'),'String',num2str(handles.overlap));
%         set(findobj('Tag','TotalCountsEdit'),'String',num2str(handles.counts));
%         handles.counts=2000000;
% countsRandoms = round(handles.counts*handles.RF);
% countsScatter = round((handles.counts - countsRandoms)*handles.SF);
% countsTrue = handles.counts - countsRandoms - countsScatter;
% nec=round(countsTrue^2/(countsRandoms+countsScatter+countsTrue)/1000);
% set(findobj('Tag','NECtext'),'String',num2str(nec));
%         % scanner parameters

%         handles.radBin=329;
         set(findobj('Tag','TanBinEdit'),'String',num2str(handles.tanBin));
%         handles.PSF=4;
         set(findobj('Tag','RingEdit'),'String',num2str(handles.RingSize));
%         handles.PSF=4;
         set(findobj('Tag','matchcheckbox'),'Value',1);
  %         handles.tanBin=280;
  
  if get(findobj('Tag','matchcheckbox'),'Value')==1
      val=get(findobj('Tag','BlurEdit'),'String');
         set(findobj('Tag','PSFEdit'),'String',val);   
  end
         
         
         
%         % reconstruction parameters
         set(findobj('Tag','SimSizeEdit'),'String',num2str(handles.SimSize));
%         handles.SimSize=256;
         set(findobj('Tag','PostFilterEdit'),'String',num2str(handles.postFilter));
%         handles.postFilter=6;
         set(findobj('Tag','IterEdit'),'String',num2str(handles.IterNum));
%         handles.IterNum=4;
         set(findobj('Tag','SubsetEdit'),'String',num2str(handles.SubNum));
set(findobj('Tag','zFilterListbox'),'Value',handles.zFilterListboxVal);
if ~isfield(handles,'LOAD_REPS') || isempty(handles.LOAD_REPS)
    handles.LOAD_REPS='false';
end
if strcmp(handles.LOAD_REPS,'false')
set(findobj('Tag','LoadRepsCheckbox'),'Value',0);
else
    set(findobj('Tag','LoadRepsCheckbox'),'Value',1);
end
if ~isfield(handles,'LOAD_ITER') || isempty(handles.LOAD_ITER)
    handles.LOAD_ITER='false';
end
if strcmp(handles.LOAD_ITER,'false')
set(findobj('Tag','LoadIterCheckbox'),'Value',0);
else
    set(findobj('Tag','LoadIterCheckbox'),'Value',1);
end
%         handles.SubNum=14;
         handles.nRep=1;

handles.OSEM='false';
handles.OSEMPSF='false';
handles.FBP='false';
handles.Additive='false';
handles.Preexist='false';

set(findobj('Tag','Instructions'),'Visible','off');
% make panels visible
% tumor panel
set(findobj('Tag','tumorPanel'),'Visible','on');
set(findobj('Tag','maxSUVEdit'),'Visible','on');
set(findobj('Tag','maxSUVText'),'Visible','on');
set(findobj('Tag','ContrastEdit'),'Visible','on');
set(findobj('Tag','ContrastText'),'Visible','on');
set(findobj('Tag','BlurEdit'),'Visible','on');
set(findobj('Tag','BlurText'),'Visible','on');
set(findobj('Tag','AdditiveCheckbox'),'Visible','on');
set(findobj('Tag','PETscanUsedCheckbox'),'Visible','on');

% counts panel
set(findobj('Tag','countPanel'),'Visible','on');
set(findobj('Tag','TotalCountsEdit'),'Visible','on');
set(findobj('Tag','TotalCountsText'),'Visible','on');
set(findobj('Tag','OverlapEdit'),'Visible','on');
set(findobj('Tag','OverlapText'),'Visible','on');
set(findobj('Tag','SFEdit'),'Visible','on');
set(findobj('Tag','SFText'),'Visible','on');
set(findobj('Tag','RFEdit'),'Visible','on');
set(findobj('Tag','RFText'),'Visible','on');
set(findobj('Tag','SensitivityText'),'Visible','on');
set(findobj('Tag','SensitivityEdit'),'Visible','on');
set(findobj('Tag','ActivityText'),'Visible','on');
set(findobj('Tag','ActivityEdit'),'Visible','on');
set(findobj('Tag','ScanTimeText'),'Visible','on');
set(findobj('Tag','ScanTimeEdit'),'Visible','on');


% set(findobj('Tag','NECtext'),'Visible','on');
% set(findobj('Tag','NECtext2'),'Visible','on');


% Scanner panel
set(findobj('Tag','scannerSettingsPanel'),'Visible','on');
set(findobj('Tag','PSFEdit'),'Visible','on');
set(findobj('Tag','PSFText'),'Visible','on');
set(findobj('Tag','TanBinEdit'),'Visible','on');
set(findobj('Tag','TanBinText'),'Visible','on');
set(findobj('Tag','RingEdit'),'Visible','on');
set(findobj('Tag','RingText'),'Visible','on');
set(findobj('Tag','matchcheckbox'),'Visible','on');

% Reconstruction panel
set(findobj('Tag','reconstructionPanel'),'Visible','on');
set(findobj('Tag','ReconText'),'Visible','on');
set(findobj('Tag','ReconParamtext'),'Visible','on');
set(findobj('Tag','SimSizeEdit'),'Visible','on');
set(findobj('Tag','SimSizeText'),'Visible','on');
set(findobj('Tag','PostFilterEdit'),'Visible','on');
set(findobj('Tag','PostFilterText'),'Visible','on');
set(findobj('Tag','IterEdit'),'Visible','on');
set(findobj('Tag','IterText'),'Visible','on');
set(findobj('Tag','SubsetEdit'),'Visible','on');
set(findobj('Tag','SubsetText'),'Visible','on');
set(findobj('Tag','FBPCheckbox'),'Visible','on');
set(findobj('Tag','OSEMPSFCheckbox'),'Visible','on');
set(findobj('Tag','OSEMCheckbox'),'Visible','on');

set(findobj('Tag','RunButton'),'Visible','on');
set(findobj('Tag','RepEdit'),'Visible','on');
set(findobj('Tag','ZFilterText'),'Visible','on');
set(findobj('Tag','zFilterListbox'),'Visible','on');
set(findobj('Tag','LoadRepsCheckbox'),'Visible','on');
set(findobj('Tag','LoadIterCheckbox'),'Visible','on');
set(findobj('Tag','RepText'),'Visible','on');
set(findobj('Tag','SaveSimParamButton'),'Visible','on');


guidata(hObject,handles);


% --- Executes on button press in matchcheckbox.
function matchcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to matchcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of matchcheckbox

if get(findobj('Tag','matchcheckbox'),'Value')==0
      set(findobj('Tag','PSFEdit'),'Enable','on')
else
    psf=get(findobj('Tag','BlurEdit'),'Value');
    set(findobj('Tag','PSFEdit'),'Value',psf)
end



function RingEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RingEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RingEdit as text
%        str2double(get(hObject,'String')) returns contents of RingEdit as a double
a=get(hObject,'String');
Ring=str2double(a);
handles.RingSize=Ring;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function RingEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RingEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ActivityEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ActivityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ActivityEdit as text
%        str2double(get(hObject,'String')) returns contents of ActivityEdit as a double
a=get(hObject,'String');
ActV=str2double(a);
handles.ActV=ActV;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function ActivityEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ActivityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SensitivityEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SensitivityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensitivityEdit as text
%        str2double(get(hObject,'String')) returns contents of SensitivityEdit as a double
a=get(hObject,'String');
Se=str2double(a);
handles.Se=Se;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function SensitivityEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensitivityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadRepsCheckbox.
function LoadRepsCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to LoadRepsCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LoadRepsCheckbox
if get(hObject,'Value')==0
      handles.LOAD_REPS='false';
else
    handles.LOAD_REPS='true';
end

% --- Executes on button press in LoadIterCheckbox.
function LoadIterCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to LoadIterCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LoadIterCheckbox
if get(hObject,'Value')==0
      handles.LOAD_ITER='false';
else
    handles.LOAD_ITER='true';
end


% --- Executes on selection change in zFilterListbox.
function zFilterListbox_Callback(hObject, eventdata, handles)
% hObject    handle to zFilterListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns zFilterListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zFilterListbox
% get name and number of filter selected
NameFilter=(get(hObject, 'String'))';
NumFilter=get(hObject, 'Value');
switch NumFilter % store in handles
    case 1
handles.zFilter=[1,1,1];
    case 2
handles.zFilter=[1,2,1];
    case 3
handles.zFilter=[1,4,1];
    case 4
handles.zFilter=[1,8,1];
end
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function zFilterListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zFilterListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OverlapEdit_Callback(hObject, eventdata, handles)
% hObject    handle to OverlapEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OverlapEdit as text
%        str2double(get(hObject,'String')) returns contents of OverlapEdit as a double
overlap=str2double(get(hObject, 'String'));
handles.overlap=overlap;

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function OverlapEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OverlapEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
