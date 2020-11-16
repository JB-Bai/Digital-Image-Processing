function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 07-May-2020 01:32:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% 启动时即读取图

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global OriginalPic;
global OutputPic;

[filename,pathname]=uigetfile({'*.bmp;*.jpg;*.png;*.jpeg;*.tif'}); 
str=[pathname filename];  %存储文件地址

if isequal(filename,0)||isequal(pathname,0)   
    warndlg('Please select a picture first!','Warning');
    return;
else
    OriginalPic= imread(str); 
    axes1 = findobj(0, 'tag', 'axes1');
    axes(axes1); 
    OutputPic=OriginalPic;
    imshow(OutputPic); 
    
end




% --- Executes on button press in pushbutton5.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global OutputPic;

[FileName,PathName] = uiputfile({'*.jpg','JPEG(*.jpg)';...
                                 '*.bmp','Bitmap(*.bmp)';...
                                 '*.gif','GIF(*.gif)';...
                                 '*.*',  'All Files (*.*)'},...
                                 'Save Picture','Untitled');
if FileName==0
    return;
else
    imwrite(OutputPic,[PathName,FileName]);
end

% --- Executes on button press in pushbutton5.
%复古滤镜
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global OriginalPic;
global OutputPic;

if ndims(OriginalPic)==3
    [rows , cols , colors] = size(OriginalPic); 
    OutputPic = zeros(rows , cols);    
    OutputPic = uint8(OutputPic);   
    for i = 1:rows  
        for j = 1:cols  
            OutputPic(i , j) = OriginalPic(i , j , 1)*0.3+OriginalPic(i , j , 2)*0.59+OriginalPic(i , j , 3)*0.11; 
        end  
    end 
else
    OutputPic=OriginalPic;
end
axes1 = findobj(0, 'tag', 'axes1');
axes(axes1); 
imshow(OutputPic);
guidata(hObject,handles);




function final=task(f,Gauss_D)
    %Gauss_D=60;
    %pic-A
    f=mat2gray(f);
    [x,y]=size(f);
    newf=zeros(2*x,2*y);
    newf(1:x,1:y)=f;
    newff=double(zeros(2*x,2*y));
    %pic-C
    for i = 1 : (x*2)
        for j = 1 : (y*2)
            newff(i,j) = double(newf(i,j))*((-1)^(i+j));
        end
    end
    %pic-D
    ff=fft2(newff);
    %pic-E %TODO
    Hf = zeros(2*x,2*y);
    for u = 1 :2*x
        for v = 1:2*y
            Hf(u,v) = exp((-((u-(x+1.0))^2+(v-(y+1.0))^2))/( 2 * Gauss_D^2));
        end
    end
    %pic-F
    Gf = Hf.*ff;
    %pic-G
    gpf = real(ifft2(Gf)); 
    for i = 1 : x
        for j = 1 : y 
            gpf(i,j) = double(gpf(i,j)*(-1)^(i+j));
        end
    end
    %pic-H
    final=gpf(1:x,1:y);


% --- Executes on slider movement.
%调整去皱纹的强度
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sliderValue;
slider1 = findobj(0, 'tag', 'slider1');
sliderValue = get(slider1,'Value');
%sliderValue=int32(sliderValue);
set(slider1,'Value',sliderValue);
guidata(hObject,handles);





% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton6.
%素描风格-》颜色调节
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global OriginalPic
global OutputPic
global sliderValue3;

rgb = OriginalPic;
[m,n,k] = size(rgb);
hsv = rgb2hsv(rgb); %颜色空间转换 
H = hsv(:,:,1); % 色调 
S = hsv(:,:,2); % 饱和度 
V = hsv(:,:,3); % 亮度


hsv(:,:,2) =hsv(:,:,2)*(0.5+sliderValue3);

OutputPic = hsv2rgb(hsv);
axes1 = findobj(0, 'tag', 'axes1');
axes(axes1); 
imshow(OutputPic) 
guidata(hObject,handles);


% --- Executes on button press in pushbutton7.
%一键美白
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global OriginalPic
global OutputPic
global sliderValue2;

rgb = OriginalPic;
[m,n,k] = size(rgb);
hsv = rgb2hsv(rgb); %颜色空间转换 
H = hsv(:,:,1); % 色调 
S = hsv(:,:,2); % 饱和度 
V = hsv(:,:,3); % 亮度
%hsv(:,:,1) =hsv(:,:,1)*(1+sliderValue2);
hsv(:,:,3) =hsv(:,:,3)*(1+sliderValue2);

OutputPic = hsv2rgb(hsv);
axes1 = findobj(0, 'tag', 'axes1');
axes(axes1); 
imshow(OutputPic) 
guidata(hObject,handles);

% --- Executes on button press in pushbutton10.
%主题匹配 必须均为RGB图
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global B
global OriginalPic
global OutputPic

[filename,pathname]=uigetfile({'*.bmp;*.jpg;*.png;*.jpeg;*.tif'}); 
str=[pathname filename];

if isequal(filename,0)||isequal(pathname,0)   
    warndlg('Please select a picture first!','Warning');
    return;
else
    B= imread(str); 
    C=func(OriginalPic,B);
    axes1 = findobj(0, 'tag', 'axes1');
    axes(axes1); 
    OutputPic=C;
    imshow(OutputPic); 
    
end
guidata(hObject,handles);

function [c]=func(a,b)
    aR = a(:,:,1);%提取原始图像R通道
    aG = a(:,:,2);%提取原始图像G通道
    aB = a(:,:,3);%提取原始图像B通道
    bR = b(:,:,1);%提取模版图像R通道
    bG = b(:,:,2);%提取模版图像G通道
    bB = b(:,:,3);%提取模版图像B通道
    [ax,ay]=size(aR);%计算像素点规模
    [bx,by]=size(bR);
    aR_hist=imhist(aR)/(ax*ay);%imshit函数返回各灰度出现次数
    aG_hist=imhist(aG)/(ax*ay);%除以总像素得各灰度概率密度函数PDF
    aB_hist=imhist(aB)/(ax*ay);
    bR_hist=imhist(bR)/(bx*by);
    bG_hist=imhist(bG)/(bx*by);
    bB_hist=imhist(bB)/(bx*by);
    aR_cumsum = cumsum(aR_hist);%计算累计分布函数CDF
    aG_cumsum = cumsum(aG_hist);
    aB_cumsum = cumsum(aB_hist);
    bR_cumsum = cumsum(bR_hist);
    bG_cumsum = cumsum(bG_hist);
    bB_cumsum = cumsum(bB_hist);
    for i=1:256 %Matlab的数组从1开始，代表i-1的灰度
    %对于原始图像某一灰度，找到模版图像的对应灰度使得其累积分布最接近原始图像累积分布
    %[value,index] = min(x) 返回最小值及其对应的下标
    %index的下标代表原始图像的灰度-1，值代表模版图像的灰度-1
        [~, R_index(i)]=min(abs(bR_cumsum-aR_cumsum(i)));
        [~, G_index(i)]=min(abs(bG_cumsum-aG_cumsum(i)));
        [~, B_index(i)]=min(abs(bB_cumsum-aB_cumsum(i)));
    end
    cR=zeros(ax,ay);
    cG=zeros(ax,ay);
    cB=zeros(ax,ay);
    for i=1:ax%进行映射
        for j=1:ay
            %index的下标代表原始图像的灰度-1，值代表模版图像的灰度-1
            cR(i,j)=R_index(aR(i,j)+1)-1;
            cG(i,j)=G_index(aG(i,j)+1)-1;
            cB(i,j)=B_index(aB(i,j)+1)-1;
        end
    end
    c=cat(3, cR, cG, cB);%拼接三通道
    c=uint8(c);%取整


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sliderValue2;
slider2 = findobj(0, 'tag', 'slider2');
sliderValue2 = get(slider2,'Value');
%set(slider2,'Value',sliderValue2);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sliderValue3;
slider3 = findobj(0, 'tag', 'slider3');
sliderValue3 = get(slider3,'Value');
%set(slider3,'Value',sliderValue3);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global OriginalPic;
global OutputPic;
global sliderValue;%range from 0-1
if ndims(OriginalPic)==3
    tmp=zeros(size(OriginalPic));
    [rows , cols , colors] = size(OriginalPic); 
    %OutputPic = zeros(rows , cols, colors); 
    for i =1:colors
        tmp(:,:,i)=task(OriginalPic(:,:,i),sliderValue*100+50);
    end
else
    tmp=zeros(size(OriginalPic));
    tmp=task(OriginalPic,sliderValue*100+50);
end
OutputPic=tmp;
axes1 = findobj(0, 'tag', 'axes1');
axes(axes1); 
imshow(OutputPic,[]);
guidata(hObject,handles);
