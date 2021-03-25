function varargout = HyDEgui(varargin)
%HYDEGUI M-file for HyDEgui.fig
%      HYDEGUI, by itself, creates a new HYDEGUI or raises the existing
%      singleton*.
%
%      H = HYDEGUI returns the handle to a new HYDEGUI or the handle to
%      the existing singleton*.
%
%      HYDEGUI('Property','Value',...) creates a new HYDEGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to HyDEgui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      HYDEGUI('CALLBACK') and HYDEGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in HYDEGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HyDEgui

% Last Modified by GUIDE v2.5 07-Aug-2009 10:02:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HyDEgui_OpeningFcn, ...
                   'gui_OutputFcn',  @HyDEgui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


function HyDEgui_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for HyDEgui
handles.output = hObject;

% 
[handles.iRODS.local,handles.irods_user,handles.iRODS.remote,handles.returnPath.iRODS] = irodsMount();


% Update handles structure
set(handles.dirtype,'SelectionChangeFcn',@dirtype_SelectionChangeFcn);
handles.analysis_type = 1;
guidata(hObject, handles);

% UIWAIT makes HyDEgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function varargout = HyDEgui_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit_superdirectory_Callback(hObject, eventdata, handles)
function edit_superdirectory_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function analyze_Callback(hObject, eventdata, handles)
set(handles.analyze,'String','Analyzing...');
set(handles.analyze,'Enable','off');
drawnow();
a1 = get(handles.edit_starttime,'String'); 
if(isempty(a1)) 
  errordlg('One or more assay parameters is missing.  Please verify all parameters are entered properly');
  set(handles.analyze,'String','Begin Analysis');
  set(handles.analyze,'Enable','on');
  return;
end
a2 = get(handles.edit_treattime,'String');
if(isempty(a2)) 
  errordlg('One or more assay parameters is missing.  Please verify all parameters are entered properly');
  set(handles.analyze,'String','Begin Analysis');
  set(handles.analyze,'Enable','on');
  return;
end
a3 = get(handles.edit_endtime,'String');
if(isempty(a3)) 
  errordlg('One or more assay parameters is missing.  Please verify all parameters are entered properly');
  set(handles.analyze,'String','Begin Analysis');
  set(handles.analyze,'Enable','on');
  return;
end
a4 = get(handles.edit_minutesperframe,'String');
if(isempty(a4)) 
  errordlg('One or more assay parameters is missing.  Please verify all parameters are entered properly');
  set(handles.analyze,'String','Begin Analysis');
  set(handles.analyze,'Enable','on');
  return;
end
a5 = get(handles.edit_framesperinterval,'String');
if(isempty(a5)) 
  errordlg('One or more assay parameters is missing.  Please verify all parameters are entered properly');
  set(handles.analyze,'String','Begin Analysis');
  set(handles.analyze,'Enable','on');
  return;
end
a6 = get(handles.edit_pixelspermm,'String');
if(isempty(a6)) 
  errordlg('One or more assay parameters is missing.  Please verify all parameters are entered properly');
  set(handles.analyze,'String','Begin Analysis');
  set(handles.analyze,'Enable','on');
  return;
end
a7 = get(handles.edit_assaytag,'String');
if(isempty(a7)) 
  errordlg('One or more assay parameters is missing.  Please verify all parameters are entered properly');
  set(handles.analyze,'String','Begin Analysis');
  set(handles.analyze,'Enable','on');
  return;
end

set(handles.analyze,'String','Analyzing...');
cb1 = get(handles.cb_raw,'Value');
cb2 = get(handles.cb_len,'Value');
cb3 = get(handles.cb_gr,'Value');
cb4 = get(handles.cb_movie,'Value');
save_directory = get(handles.savedir,'String');
% a1 = str2num(a1);
% a2 = str2num(a2);
% a3 = str2num(a3);
% a4 = str2num(a4);
% a5 = str2num(a5);
% a6 = str2num(a6);
assay = [a1,',',a2,',',a3,',',a4,',',a5,',',a6];
newassay = str2num(assay);

directory = get(handles.edit_superdirectory,'String');
if(~exist(directory,'dir'))
  errordlg('Directory does not exist: please check to make sure you entered it correctly')
  set(handles.analyze,'String','Begin Analysis');
  set(handles.analyze,'Enable','on');
  return;
end
switch(handles.analysis_type)
  case 1
    try
        raw = HyDE(directory,save_directory,newassay,a7,1,[cb1,cb2,cb3,cb4]);
    catch myEx
        disp(myEx.message);
        raw = [];
    end
    if(length(raw) > 1)
      axes(handles.axes1);
      plot(raw(:,1),raw(:,4));
      line([0,0],ylim,'Color','black');
      line(xlim,[0,0],'Color','black');
      xlabel('Time (min)','Color','white');
      ylabel('New Growth (mm)','Color','white');
      set(handles.axes1,'XColor','w','YColor','w');
      set(handles.analyze,'String','Begin Analysis');
      set(handles.analyze,'Enable','on');
    else
      errordlg('Image stack produced no data...check that stack exists in specified directory and that image quality is sufficient, or try another stack');
      set(handles.analyze,'String','Begin Analysis');
      set(handles.analyze,'Enable','on');
      return;
    end
  case 2
    try
      raw = HyDE(directory,save_directory, newassay,a7,2,[cb1,cb2,cb3,cb4]);
    catch myEx
        errordlg('AHHHH!')
        set(handles.analyze,'String','Begin Analysis');
        set(handles.analyze,'Enable','on');
        return;
    end
    if(length(raw) > 1)
      axes(handles.axes1);
      plot(raw(:,1),raw(:,2),'LineWidth',2); hold on;
      errorbar(raw(:,1),raw(:,2),raw(:,3),'.k');
      line([0,0],ylim,'Color','black');
      line(xlim,[0,0],'Color','black');
      xlabel('Time (min)','Color','white');
      ylabel('New Growth (mm)','Color','white');
      set(handles.axes1,'XColor','w','YColor','w');
      hold off;
    else
      errordlg('No data was generated from images.  Please check that your directory structure is correct, and that images are of proper quality');
    end
  case 3
    [raw,err,names] = HyDE(directory,save_directory, newassay,a7,3,[cb1,cb2,cb3,cb4]);
    if(length(raw)>1)
      colors = 'cmbryg';
      for i=2:size(raw,2)
        color = colors(mod(i,6)+1);
        axes(handles.axes1);
        plot(raw(:,1),raw(:,i),'LineWidth',2,'Color',color); hold on;
      end
      legend(names);
      for i=2:size(raw,2)
        errorbar(raw(:,1),raw(:,i),err(:,i),'.k');
      end
      line([0,0],ylim,'Color','black');
      line(xlim,[0,0],'Color','black');
      xlabel('Time (min)','Color','white');
      ylabel('New Growth (mm)','Color','white');
      set(handles.axes1,'XColor','w','YColor','w');
      hold off;
    else
      errordlg('No data was generated from images.  Please check that your directory structure is correct, and that images are of proper quality');
    end
    
    
end
set(handles.analyze,'String','Begin Analysis');
set(handles.analyze,'Enable','on');


function cb_raw_Callback(hObject, eventdata, handles)


function cb_len_Callback(hObject, eventdata, handles)


function cb_gr_Callback(hObject, eventdata, handles)


function cb_movie_Callback(hObject, eventdata, handles)


function edit_starttime_Callback(hObject, eventdata, handles)


function edit_starttime_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_treattime_Callback(hObject, eventdata, handles)


function edit_treattime_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_endtime_Callback(hObject, eventdata, handles)


function edit_endtime_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_assaytag_Callback(hObject, eventdata, handles)


function edit_assaytag_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_minutesperframe_Callback(hObject, eventdata, handles)


  
function edit_minutesperframe_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_pixelspermm_Callback(hObject, eventdata, handles)


function edit_pixelspermm_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_framesperinterval_Callback(hObject, eventdata, handles)


function edit_framesperinterval_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function browsebutton_Callback(hObject, eventdata, handles)
  pathname = uigetdir;
  set(handles.edit_superdirectory,'String',pathname);
  if(exist([pathname,'/assayfile']))
    fid = fopen([pathname,'/assayfile']);
    params = fgetl(fid);
    paramc = split(' ',params);
    if(length(paramc) < 7)
      errordlg('arrayfile does not have enough parameters');
      return;
    else
      set(handles.edit_starttime,'String',char(paramc(1)));
      set(handles.edit_treattime,'String',char(paramc(2)));
      set(handles.edit_endtime,'String',char(paramc(3)));
      set(handles.edit_assaytag,'String',char(paramc(4)));
      set(handles.edit_minutesperframe,'String',char(paramc(5)));
      set(handles.edit_framesperinterval,'String',char(paramc(7)));
      set(handles.edit_pixelspermm,'String',char(paramc(6)));
    end
  end
  
  
function dirtype_SelectionChangeFcn(hObject, eventdata)
 
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 

switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
  case 'radio_singlestack'
    handles.analysis_type = 1;
  case 'radio_groupofstacks'
    handles.analysis_type = 2;
  case 'radio_groupofgroups'
    handles.analysis_type = 3;
  otherwise
    handles.analysis_type = 1;
end
%updates the handles structure
guidata(hObject, handles);


function savedir_Callback(hObject, eventdata, handles)


function savedir_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sbrowse_Callback(hObject, eventdata, handles)
  pathname = uigetdir;
  set(handles.savedir,'String',pathname);
