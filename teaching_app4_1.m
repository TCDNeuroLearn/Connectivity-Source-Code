%%TCD NeuroLearn - Connectivity Teaching App
% 
%     Copyright (C) 2016 Trinity College Dublin
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
% Contact Information: brodermi@tcd.ie

function varargout = teaching_app4_1(varargin)
% TEACHING_APP4_1 MATLAB code for teaching_app4_1.fig
%      TEACHING_APP4_1, by itself, creates a new TEACHING_APP4_1 or raises the existing
%      singleton*.
%
%      H = TEACHING_APP4_1 returns the handle to a new TEACHING_APP4_1 or the handle to
%      the existing singleton*.
%
%      TEACHING_APP4_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEACHING_APP4_1.M with the given input arguments.
%
%      TEACHING_APP4_1('Property','Value',...) creates a new TEACHING_APP4_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before teaching_app4_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to teaching_app4_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%     instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help teaching_app4_1

% Last Modified by GUIDE v2.5 16-Jun-2016 11:30:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @teaching_app4_1_OpeningFcn, ...
    'gui_OutputFcn',  @teaching_app4_1_OutputFcn, ...
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
function teaching_app4_1_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
load('Data.mat');       %Load in connectivity data and set variables
handles.ChanLabels=ChannelLabels;
handles.fs=SampleRate;
handles.p2pvalues=values;
handles.EEG=EEG;%Hello
handles.ChanLocs=ChannelCoordinates*250;
handles.aveEEG=squeeze(mean(EEG,2));

%Compute Frequency Domain Representation of all signals
for i=1:size(EEG,1)
    x1=bsxfun(@times,hilbert(bmeaner(squeeze(EEG(i,:,:)),2).').',hanning(601).');
    handles.EEGf(i,:,:)=fft(x1.').';
end

%Initialise axes
%Topographic Plot
axes(handles.head_plot)
box on;set(gca,'XTick',[],'YTick',[]);
bheadsymbolplot
handles.t=text(handles.ChanLocs(:,1),handles.ChanLocs(:,2), handles.ChanLabels,'FontSize',16,'FontName','Source Sans Pro','FontUnits','Normalized');


%Logo Plot
axes(handles.logo);hold on;
crest=flipud(imread('logo.png'));
image(crest);
box off;set(gca,'XTick',[],'YTick',[]);

%Workspace plot
axes(handles.workspace)
box on;set(gca,'XTick',[],'YTick',[]);
%Workspace2 plot
axes(handles.workspace2);
box on;set(gca,'XTick',[],'YTick',[]);
%Workspace3 plot
axes(handles.workspace3);
box on;set(gca,'XTick',[],'YTick',[]);
%Workspace4 plot
axes(handles.workspace4);
box on;set(gca,'XTick',[],'YTick',[]);
handles.WS4=get(handles.workspace4,'Position');
%Workspace5 plot
axes(handles.workspace5);hold on;
box on;set(gca,'XTick',[],'YTick',[]);
%Workspace6 plot
axes(handles.workspace6);
box on;hold on;set(gca,'XTick',[],'YTick',[]);
%Channel 1 Plot
axes(handles.chan_axis1)
box on;hold on;set(gca,'XTick',[],'YTick',[]);
xlim([-0.5 2.5]);
xlabel('Time (s)','FontSize',12,'FontName','Source Sans Pro','FontUnits','Normalized');ylabel('Voltage (mV)','FontSize',12,'FontName','Source Sans Pro','FontUnits','Normalized')
handles.ax1=get(handles.chan_axis1,'Position');
handles.ax2=get(handles.chan_axis2,'Position');
%Channel 1 Epoch Plot (Visible for Coherence)
axes(handles.epoch1)
box on;hold on;set(gca,'XTick',[],'YTick',[]);
%Channel 1 Frequency Plot (Visible for Coherence)
axes(handles.freq1)
box on;hold on;set(gca,'XTick',[],'YTick',[]);
%Channel 2 Plot
axes(handles.chan_axis2)
box on;hold on;set(gca,'XTick',[],'YTick',[]);
xlim([-0.5 2.5]);
xlabel('Time (s)','FontSize',12,'FontName','Source Sans Pro','FontUnits','Normalized');ylabel('Voltage (mV)','FontSize',12,'FontName','Source Sans Pro','FontUnits','Normalized')
%Channel 2 Epoch Plot (Visible for Coherence)
axes(handles.epoch2)
box on;hold on;set(gca,'XTick',[],'YTick',[]);
%Channel 2 Frequency Plot (Visible for Coherence)
axes(handles.freq2)
box on;hold on;set(gca,'XTick',[],'YTick',[]);
% Update handles structure
guidata(hObject, handles);
function varargout = teaching_app4_1_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;
function ch_select1_Callback(hObject, eventdata, handles)

axes(handles.head_plot);
delete(findobj(gca,'Type','Quiver'));
delete(findobj(gca,'Type','Line','Color',[0.2 0.7 0.2]));

select_chans(hObject,handles,1,1);

if ~(get(handles.ch_select1,'Value')==26 || get(handles.ch_select2,'Value')==26)
    set(handles.push,'Enable','on');
else
    set(handles.push,'Enable','off');
end

if ((get(handles.measure,'Value')==2) && (get(handles.approach,'Value')==2))

            pdc(hObject,handles);
        set(handles.freq_slider,'Visible','on','Value',0);
set(handles.text22,'Visible','on');
set(handles.text23,'Visible','on');
set(handles.text24,'Visible','on');
set(handles.text25,'Visible','on');
    
end
function ch_select1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ch_select2_Callback(hObject, eventdata, handles)
axes(handles.head_plot);
delete(findobj(gca,'Type','Quiver'));
delete(findobj(gca,'Type','Line','Color',[0.2 0.7 0.2]));

select_chans(hObject,handles,2,1);

if ~(get(handles.ch_select1,'Value')==26 || get(handles.ch_select2,'Value')==26)
    set(handles.push,'Enable','on');
else
    set(handles.push,'Enable','off');
end


if ((get(handles.measure,'Value')==2) && (get(handles.approach,'Value')==2))

            pdc(hObject,handles);
        set(handles.freq_slider,'Visible','on','Value',0);
set(handles.text22,'Visible','on');
set(handles.text23,'Visible','on');
set(handles.text24,'Visible','on');
set(handles.text25,'Visible','on');
    
end
function ch_select2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function approach_Callback(hObject, eventdata, handles)
if get(handles.crosscorrcheck,'Value')
   
    set(handles.crosscorrcheck,'Value',0);
   crosscorrcheck_Callback(hObject, eventdata, handles)
    
end
axes(handles.workspace);cla;set(handles.workspace,'Visible','off');
axes(handles.workspace2);cla;set(handles.workspace2,'Visible','off');
axes(handles.workspace3);cla;set(handles.workspace3,'Visible','off');
axes(handles.workspace4);cla;set(handles.workspace4,'Visible','off');
axes(handles.workspace5);cla;set(handles.workspace5,'Visible','off');
axes(handles.workspace6);cla;set(handles.workspace6,'Visible','off');
axes(handles.epoch1);cla;set(handles.epoch1,'Visible','off');
axes(handles.epoch2);cla;set(handles.epoch2,'Visible','off');
axes(handles.freq1);cla;set(handles.freq1,'Visible','off');
axes(handles.freq2);cla;set(handles.freq2,'Visible','off');
axes(handles.head_plot);delete(findobj(gca,'Type','Line','Color',[0.2 0.7 0.2]));
delete(findobj(gca,'Type','Quiver'));

set(handles.crosscorrcheck,'Visible','off');
set(handles.lag,'Visible','off','Value',0);
set(handles.text19,'Visible','off');
set(handles.text18,'Visible','off');
set(handles.text20,'Visible','off');

set(handles.freq_slider,'Visible','off','Value',0);
set(handles.text22,'Visible','off');
set(handles.text23,'Visible','off');
set(handles.text24,'Visible','off');
set(handles.text25,'Visible','off');


axes(handles.chan_axis1);cla;
%xlabel('Time (s)','FontSize',12,'FontName','Source Sans Pro');ylabel('Voltage (mV)','FontSize',12,'FontName','Source Sans Pro')
axes(handles.chan_axis2);cla;
%xlabel('Time (s)','FontSize',12,'FontName','Source Sans Pro');ylabel('Voltage (mV)','FontSize',12,'FontName','Source Sans Pro')
select_chans(hObject,handles,1,0);
select_chans(hObject,handles,2,0);

set(handles.chan_axis1,'Position',handles.ax1);
set(handles.chan_axis2,'Position',handles.ax2);

axes(handles.epoch1);cla;set(handles.epoch1,'Visible','off');
axes(handles.epoch2);cla;set(handles.epoch2,'Visible','off');
axes(handles.freq1);cla;set(handles.freq1,'Visible','off');
axes(handles.freq2);cla;set(handles.freq2,'Visible','off');
function approach_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function push_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function push_Callback(hObject, eventdata, handles)

if (get(handles.approach,'Value')==1)
    
    if (get(handles.measure,'Value')==1)
        pearsons(hObject,handles)
        set(handles.crosscorrcheck,'Visible','on');
        set(handles.lag,'Visible','on');
        set(handles.text19,'Visible','on');
        set(handles.text18,'Visible','on');
        set(handles.text20,'Visible','on');
    else
        
        
        set(handles.chan_axis1,'Position',[handles.ax1(1) handles.ax1(2) handles.ax1(3)/2 handles.ax1(4)/2]);
       
        set(handles.chan_axis2,'Position',[handles.ax2(1) handles.ax2(2) handles.ax2(3)/2 handles.ax2(4)/2]);
                set(handles.epoch1,'Visible','on');
        set(handles.freq1,'Visible','on');
                        set(handles.epoch2,'Visible','on');
        set(handles.freq2,'Visible','on');

                
         coherence(hObject,handles);
        
    end
    
    
else
    
    if (get(handles.measure,'Value')==1)
        
        granger(hObject,handles);
        
    else
        
        pdc(hObject,handles);
        set(handles.freq_slider,'Visible','on','Value',0);
set(handles.text22,'Visible','on');
set(handles.text23,'Visible','on');
set(handles.text24,'Visible','on');
set(handles.text25,'Visible','on');
    
    end
    
    
end
function crosscorrcheck_Callback(hObject, eventdata, handles)

minVal=-16;
maxVal=16;
if get(handles.crosscorrcheck,'Value')
    
    set(handles.push,'Enable','off');
    %Change Workspace 1 to cross correlation plot
    axes(handles.workspace);cla;
    title('Cross Correlation','FontName','Source Sans Pro');%,'FontUnits','Normalized');
    xlabel('Time Lags (ms)','FontName','Source Sans Pro');ylabel('Correlation Coefficient','FontName','Source Sans Pro');
    xlim([-1 1]);ylim([-0.1 1]);set(gca,'Xtick',[-1:0.2:1],'XTickLabel',[-1000:200:1000],'YTick',[0:0.2:1],'YTicklabel',[0:0.2:1]);
    plot([0 0],[-0.1 1],'Color',[0.15 0.15 0.15]);
    
    %Workspace 2 = Pearson's correlation
    set(handles.workspace2,'Visible','on');
    set(handles.lag,'Enable','on');
    
    axes(handles.workspace2);
    hold on;
    title('Pearsons Correlation','FontName','Source Sans Pro');%,'FontUnits','Normalized');
    xlabel('Channel 1 Amplitude (mV)','FontName','Source Sans Pro');ylabel('Channel 2 Amplitude (mV)','FontName','Source Sans Pro');
    xlim([minVal maxVal]);ylim([minVal maxVal]);
    set(gca,'Box','on','XTickMode','auto','YTickMode','auto')
    plot([0 0],[minVal maxVal],'Color',[0.15 0.15 0.15]);
    plot([minVal maxVal],[0 0],'Color',[0.15 0.15 0.15]);
    
    
else
    set(handles.push,'Enable','on');
    %Workspace 1 back to Pearson's
    axes(handles.workspace);
    hold on;
    title('Pearsons Correlation');
    xlabel('Channel 1 Amplitude (mV)','FontName','Source Sans Pro');ylabel('Channel 2 Amplitude (mV)','FontName','Source Sans Pro');
    set(handles.workspace,'Visible','on');
    xlim([minVal maxVal]);ylim([minVal maxVal]);
    set(gca,'Xtick',[-16:2:16],'XTickLabel',[-16:2:16],'YTick',[-16:2:16],'YTicklabel',[-16:2:16]);
    plot([0 0],[minVal maxVal],'Color',[0.15 0.15 0.15]);
    plot([minVal maxVal],[0 0],'Color',[0.15 0.15 0.15]);
    cla;
    set(handles.workspace,'Visible','off');
    
    
    %Workspace 2 Invisible
    axes(handles.workspace2);
    cla;
    set(handles.workspace2,'Visible','off');
    set(handles.lag,'Enable','off');
    %Chan Axis 1 remove points
    axes(handles.chan_axis1);
    delete(findobj(gca,'Type','Scatter'));
    %
    select_chans(hObject, handles,2,0);
    
    set(handles.crosscorrcheck,'Visible','off');
    set(handles.lag,'Visible','off','Value',0);
    set(handles.text19,'Visible','off');
    set(handles.text18,'Visible','off');
    set(handles.text20,'Visible','off');
    
    
    
end
function lag_Callback(hObject, eventdata, handles)

cross_corr(hObject,handles)
function lag_CreateFcn(hObject, eventdata, handles)


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function measure_Callback(hObject, eventdata, handles)

if get(handles.crosscorrcheck,'Value')
   
    set(handles.crosscorrcheck,'Value',0);
   crosscorrcheck_Callback(hObject, eventdata, handles)
    
end

axes(handles.workspace);cla;set(handles.workspace,'Visible','off');
axes(handles.workspace2);cla;set(handles.workspace2,'Visible','off');
axes(handles.workspace3);cla;set(handles.workspace3,'Visible','off');
axes(handles.workspace4);cla;set(handles.workspace4,'Visible','off');
axes(handles.workspace5);cla;set(handles.workspace5,'Visible','off');
axes(handles.workspace6);cla;set(handles.workspace6,'Visible','off');
axes(handles.epoch1);cla;set(handles.epoch1,'Visible','off');
axes(handles.epoch2);cla;set(handles.epoch2,'Visible','off');
axes(handles.freq1);cla;set(handles.freq1,'Visible','off');
axes(handles.freq2);cla;set(handles.freq2,'Visible','off');
axes(handles.head_plot);delete(findobj(gca,'Type','Line','Color',[0.2 0.7 0.2]));
delete(findobj(gca,'Type','Quiver'));

set(handles.crosscorrcheck,'Visible','off');
set(handles.lag,'Visible','off','Value',0);
set(handles.text19,'Visible','off');
set(handles.text18,'Visible','off');
set(handles.text20,'Visible','off');

set(handles.freq_slider,'Visible','off','Value',0);
set(handles.text22,'Visible','off');
set(handles.text23,'Visible','off');
set(handles.text24,'Visible','off');
set(handles.text25,'Visible','off');

axes(handles.chan_axis1);cla;
%xlabel('Time (s)','FontSize',12,'FontName','Source Sans Pro');ylabel('Voltage (mV)','FontSize',12,'FontName','Source Sans Pro')
axes(handles.chan_axis2);cla;
%xlabel('Time (s)','FontSize',12,'FontName','Source Sans Pro');ylabel('Voltage (mV)','FontSize',12,'FontName','Source Sans Pro')
select_chans(hObject,handles,1,0);
select_chans(hObject,handles,2,0);

set(handles.chan_axis1,'Position',handles.ax1);
set(handles.chan_axis2,'Position',handles.ax2);

axes(handles.epoch1);cla;set(handles.epoch1,'Visible','off');
axes(handles.epoch2);cla;set(handles.epoch2,'Visible','off');
axes(handles.freq1);cla;set(handles.freq1,'Visible','off');
axes(handles.freq2);cla;set(handles.freq2,'Visible','off');
function measure_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function freq_slider_Callback(hObject, eventdata, handles)

arrow(hObject,handles);
function freq_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function arrow( hObject, handles)

freq=round(get(handles.freq_slider,'Value')*100);

if freq==0
   freq=1; 
end

axes(handles.workspace6);delete(findobj(gca,'Type','Line','Color',[0.2 0.7 0.2]));delete(findobj(gca,'Type','Text'));
delete(findobj(gca,'Type','Scatter'));
PDCF=findobj(gca,'Type','Line');
a=PDCF.YData(freq)*15;
plot([freq freq],[0 PDCF.YData(freq)],'Color',[0.2 0.7 0.2],'LineStyle','--','LineWidth',1.5);
f_text=text(freq+2,0.1,['f = ' int2str(freq) 'Hz'],'FontName','Source Sans Pro','FontWeight','bold','Color',[0.2 0.7 0.2],'FontUnits','Normalized','FontSize',0.0575);
scatter(freq,PDCF.YData(freq),25,'MarkerFaceColor',[0.2 0.7 0.2],'MarkerEdgeColor',[0.2 0.7 0.2]);

axes(handles.head_plot)
delete(findobj(gca,'Type','Line','Color',[0.2 0.7 0.2]));
quiv=findobj(gca,'Type','Quiver');
start=[quiv.XData quiv.YData];
fin=[(quiv.UData + start(1)), (quiv.VData +start(2))];


if ((quiv.UData<0 && quiv.VData>=0) || (quiv.UData<0 && quiv.VData<=0))
   beta=pi ;
   
else
    beta=0;
   
end
angle=atan(quiv.VData/quiv.UData);
L=sqrt(quiv.VData^2 + quiv.UData^2);
x=(0:1/4:(5/6*L));
n=2*pi/(5/6*L);
p_freq=freq/10;
y=a*sin(p_freq*n*x);

[theta,r]=cart2pol(x,y);
theta=theta+angle+beta;
[x,y]=pol2cart(theta,r);
x=x+quiv.XData; y=y+quiv.YData;
%plot(x(1:5/6*length(x)),y(1:5/6*length(y)),'Color',[0.2 0.7 0.2],'LineWidth',1.5); 
plot(x,y,'Color',[0.2 0.7 0.2],'LineWidth',1.5); 
function coherence(hObject, handles)

set(handles.text3,'String',['Ch 1']);
set(handles.text5,'String',['Ch 2']);
axes(handles.chan_axis1);cla;
    xlim([-0.5 2.5]);ylim([-50 80]);    
    set(gca,'XTick',[-0.5 0 1 2],'XTickLabel',[-0.5 0 1 2],'YTick',[-50 0 50],'YTickLabel',[-50 0 50]);
axes(handles.chan_axis2);cla;
%xlabel('Time (s)','FontSize',6,'FontName','Source Sans Pro');ylabel('Voltage (mV)','FontSize',6,'FontName','Source Sans Pro')
    xlim([-0.5 2.5]);ylim([-50 80]);
        set(gca,'XTick',[-0.5 0 1 2],'XTickLabel',[-0.5 0 1 2],'YTick',[-50 0 50],'YTickLabel',[-50 0 50]);
axes(handles.freq1);cla;
xlabel('Frequency (Hz)','FontSize',6,'FontName','Source Sans Pro');
    xlim([0 100]);ylim([0 2000]);
    set(gca,'XTick',[0:50:100],'XTickLabel',[0:50:100],'YTick',[]);
axes(handles.freq2);cla;
xlabel('Frequency (Hz)','FontSize',6,'FontName','Source Sans Pro');
    xlim([0 100]);ylim([0 2000]);
    set(gca,'XTick',[0:50:100],'XTickLabel',[0:50:100],'YTick',[]);
axes(handles.workspace2);hold on;cla;
axes(handles.workspace3);hold on;cla;
axes(handles.workspace4);cla;hold on;
set(handles.workspace4,'Position',[handles.WS4]);
xlabel('Re');ylabel('Im');set(gca,'XTick',[],'YTick',[],'XTickLabel',[],'YTickLabel',[]);
title('');
axes(handles.workspace6);cla;set(handles.workspace6,'Visible','off');
xlabel('Frequency','FontName','Source Sans Pro');

ch1_tplot=[squeeze(handles.EEG(get(handles.ch_select1,'Value'),1,:));squeeze(handles.EEG(get(handles.ch_select1,'Value'),2,:));squeeze(handles.EEG(get(handles.ch_select1,'Value'),3,:));];
ch2_tplot=[squeeze(handles.EEG(get(handles.ch_select2,'Value'),1,:));squeeze(handles.EEG(get(handles.ch_select2,'Value'),2,:));squeeze(handles.EEG(get(handles.ch_select2,'Value'),3,:));];
e_t=0:1/handles.fs:length(ch1_tplot)/handles.fs;e_t(end)=[];
c=[1 0 0;1 0.5 0.2;0.2 0.7 0.2; 0.6 0.6 0.6];
f_point=63;
lims=0;
%Maximum and minimum Real/Imaginary Points at 20Hz (all trials)
R_max_ch1=max(real(squeeze(handles.EEGf(get(handles.ch_select1,'Value'),1:3,f_point))));
R_min_ch1=min(real(squeeze(handles.EEGf(get(handles.ch_select1,'Value'),1:3,f_point))));
I_max_ch1=max(imag(squeeze(handles.EEGf(get(handles.ch_select1,'Value'),1:3,f_point))));
I_min_ch1=min(imag(squeeze(handles.EEGf(get(handles.ch_select1,'Value'),1:3,f_point))));
ch1_lim=max(abs([R_max_ch1 R_min_ch1 I_max_ch1 I_min_ch1]));
R_max_ch2=max(real(squeeze(handles.EEGf(get(handles.ch_select2,'Value'),1:3,f_point))));
R_min_ch2=min(real(squeeze(handles.EEGf(get(handles.ch_select2,'Value'),1:3,f_point))));
I_max_ch2=max(imag(squeeze(handles.EEGf(get(handles.ch_select2,'Value'),1:3,f_point))));
I_min_ch2=min(imag(squeeze(handles.EEGf(get(handles.ch_select2,'Value'),1:3,f_point))));
ch2_lim=max(abs([R_max_ch2 R_min_ch2 I_max_ch2 I_min_ch2]));


%%Plot Long EEG data

axes(handles.epoch1);
cla;xlim([0 9]);ylim([-50 90]);
set(gca,'XTick',[]);
%xlabel('Time (s)','FontSize',12,'FontName','Source Sans Pro');ylabel('Voltage (mV)','FontSize',12,'FontName','Source Sans Pro')
G1=animatedline('Color',[0.055 0.451 0.7255],'LineWidth',1.5);


axes(handles.epoch2);
cla;xlim([0 9]);ylim([-50 90]);
set(gca,'XTick',[]);
%xlabel('Time (s)','FontSize',12,'FontName','Source Sans Pro');ylabel('Voltage (mV)','FontSize',12,'FontName','Source Sans Pro')

G2=animatedline('Color',[0.055 0.451 0.7255],'LineWidth',1.5);

% plot(epoch_t,ch1_tplot,'Color',[0.055 0.451 0.7255],'LineWidth',1.5,'Parent',handles.chan_axis1);
% plot(epoch_t,ch2_tplot,'Color',[0.055 0.451 0.7255],'LineWidth',1.5,'Parent',handles.chan_axis2);

for i=1:8:length(ch1_tplot)-3
    
    addpoints(G1,e_t(i:i+7),ch1_tplot(i:i+7));
    addpoints(G2,e_t(i:i+7),ch2_tplot(i:i+7));
    pause(0.001);
    
end

for i=1:3
    
    axes(handles.epoch1);
    epoch_t1(i)=text((i-1)*3+0.5,60,['Epoch ' int2str(i)],'FontName','Source Sans Pro','Color',c(i,:),'FontWeight','bold');
    epoch_p1(i)=plot(e_t((i-1)*600+100:(i-1)*600+600),ch1_tplot((i-1)*600+100:(i-1)*600+600),'Color',c(i,:),'LineWidth',1.5);
    
    axes(handles.epoch2);
    epoch_t2(i)=text((i-1)*3+0.5,60,['Epoch ' int2str(i)],'FontName','Source Sans Pro','Color',c(i,:),'FontWeight','bold');
    epoch_p2(i)=plot(e_t((i-1)*600+100:(i-1)*600+600),ch2_tplot((i-1)*600+100:(i-1)*600+600),'Color',c(i,:),'LineWidth',1.5);
    pause(0.75)
end

pause(0.5)



%%

%%Plot single EEG values, FFT Transform, Complex Representation
t=-0.5:1/handles.fs:2.5;
f=(0:(601-1))./(601).*handles.fs;
Nf=floor(length(f)/2)+1;




for i=[1:3]
    
    for j=1:3
        
        epoch_t1(j).Color=[0.055 0.451 0.7255];
        epoch_p1(j).Color=[0.055 0.451 0.7255];
        epoch_t2(j).Color=[0.055 0.451 0.7255];
        epoch_p2(j).Color=[0.055 0.451 0.7255];
        
    end
    
    signal1=squeeze(handles.EEG(get(handles.ch_select1,'Value'),i,:));
    signal2=squeeze(handles.EEG(get(handles.ch_select2,'Value'),i,:));
    
    epoch_t1(i).Color=c(i,:);
    epoch_p1(i).Color=c(i,:);
    epoch_t2(i).Color=c(i,:);
    epoch_p2(i).Color=c(i,:);
    
    axes(handles.freq2);cla;axes(handles.freq1);cla;axes(handles.chan_axis2);cla;
    %Time Series Representation
    axes(handles.chan_axis1);cla;
    pause(0.75);
    t_title1= text(0.75,55,'Time Domain','FontWeight','bold','FontSize',8,'FontName','Source Sans Pro');
    plot(t,signal1,'Color',c(i,:),'LineWidth',1.5)
 
    axes(handles.chan_axis2);
    t_title2= text(0.75,55,'Time Domain','FontWeight','bold','FontSize',8,'FontName','Source Sans Pro');
    plot(t,signal2,'Color',c(i,:),'LineWidth',1.5)
    
    pause(0.75);
    %Frequency Representation
    %Channel 1
    axes(handles.freq1);
    f_title1= text(40,1600,'Frequency Domain','FontWeight','bold','FontSize',8,'FontName','Source Sans Pro');
    plot(f(1:Nf),abs(squeeze(handles.EEGf(get(handles.ch_select1,'Value'),i,1:Nf))),'Color',c(i,:),'LineWidth',1.5,'Parent',handles.freq1)
    
    %Plot Frequency Correlation point

    %Channel 2
    axes(handles.freq2);
    f_title2= text(40,1600,'Frequency Domain','FontWeight','bold','FontSize',8,'FontName','Source Sans Pro');
    plot(f(1:Nf),abs(squeeze(handles.EEGf(get(handles.ch_select2,'Value'),i,1:Nf))),'Color',c(i,:),'LineWidth',1.5,'Parent',handles.freq2)
    
    pause(1)
    
    %Complex Representation of FFT
    set(handles.workspace4,'Visible','on')
    
    
    set(handles.workspace2,'Visible','on','FontSize',0.075)
    axes(handles.workspace2);
    title('Ch1 at 20Hz - Complex Representation','FontName','Source Sans Pro')
    %Ch1_vector Complex number corresponding to the FFT of EEG channel 1
    %data, trial i and frequency 20Hz
    ch1_vector=squeeze(handles.EEGf(get(handles.ch_select1,'Value'),i,f_point));
    xlim([-ch1_lim ch1_lim]); ylim([-ch1_lim ch1_lim]);
    set(gca,'XTick',[],'YTick',[],'XTickLabel',[],'YTickLabel',[]);
    xlabel('Re');ylabel('Im');
    plot([0 0],[-ch1_lim ch1_lim],'Color',[0.15 0.15 0.15]);
    plot([-ch1_lim ch1_lim],[0 0],'Color',[0.15 0.15 0.15]);
    
    
    set(handles.workspace3,'Visible','on','FontSize',0.075)
    axes(handles.workspace3);
    ch2_vector=squeeze(handles.EEGf(get(handles.ch_select2,'Value'),i,f_point));
    title('Ch2 at 20Hz - Complex Representation','FontName','Source Sans Pro')
    xlim([-ch2_lim ch2_lim]); ylim([-ch2_lim ch2_lim]);
    
    set(gca,'XTick',[],'YTick',[],'XTickLabel',[],'YTickLabel',[]);
    xlabel('Re');ylabel('Im');
    plot([0 0],[-ch2_lim ch2_lim],'Color',[0.15 0.15 0.15]);
    plot([-ch2_lim ch2_lim],[0 0],'Color',[0.15 0.15 0.15]);
    
    axes(handles.freq1);
    %Plot the point on the channel axis
    scatter(f(f_point),abs(squeeze(handles.EEGf(get(handles.ch_select1,'Value'),i,f_point))),30,'MarkerFaceColor','k','MarkerEdgeColor','k')
        pause(0.5);
    %Plot the vector
    axes(handles.workspace2);
    quiver(0,0,real(ch1_vector),imag(ch1_vector),'Color',c(i,:),'LineWidth',1.5);
    theta1=atan(imag(ch1_vector)/real(ch1_vector));
    m1=abs(ch1_vector);
       pause(0.5);
    axes(handles.freq2);
    %Plot the point on the frequency axis
    scatter(f(f_point),abs(squeeze(handles.EEGf(get(handles.ch_select2,'Value'),i,f_point))),30,'MarkerFaceColor','k','MarkerEdgeColor','k')
    pause(0.5);
    
    axes(handles.workspace3);
    quiver(0,0,real(ch2_vector),imag(ch2_vector),'Color',c(i,:),'LineWidth',1.5);
    theta2=atan(imag(ch2_vector)/real(ch2_vector));
    pause(0.75);
    m2=abs(ch2_vector);
  
    m=m1*m2;
    theta=theta2-theta1;
    
    v(1)=m*cos(theta);v(2)=m*sin(theta);
    
    axes(handles.workspace4)
    quiver(0,0,v(1),v(2),'Color',c(i,:),'LineWidth',1.5);
    
    if (max(abs(v))>lims)
        lims=max(abs(v));
        xlim([-lims lims]);ylim([-lims lims]);
        plot([0 0],[-lims lims],'Color',[0.15 0.15 0.15]);
        plot([-lims lims],[0 0],'Color',[0.15 0.15 0.15]);
        
    end
    
pause(0.75);
    
 end
%%
clear v


delete(epoch_t1);delete(epoch_t2);delete(epoch_p1);delete(epoch_p2);
ch1_tplot=[squeeze(handles.EEG(get(handles.ch_select1,'Value'),81,:));squeeze(handles.EEG(get(handles.ch_select1,'Value'),82,:));squeeze(handles.EEG(get(handles.ch_select1,'Value'),83,:));];
ch2_tplot=[squeeze(handles.EEG(get(handles.ch_select2,'Value'),81,:));squeeze(handles.EEG(get(handles.ch_select2,'Value'),82,:));squeeze(handles.EEG(get(handles.ch_select2,'Value'),83,:));];
axes(handles.epoch1);cla;axes(handles.epoch2);cla;
plot(e_t,ch1_tplot,'Color',[0.055 0.451 0.7255],'LineWidth',1.5,'Parent',handles.epoch1);
plot(e_t,ch2_tplot,'Color',[0.055 0.451 0.7255],'LineWidth',1.5,'Parent',handles.epoch2);
    axes(handles.epoch1);
    epoch_t1=text((2)*3+0.5,60,['Epoch N'],'FontName','Source Sans Pro','Color',c(4,:),'FontWeight','bold');
    epoch_p1=plot(e_t((2)*600+100:(2)*600+600),ch1_tplot((2)*600+100:(2)*600+600),'Color',c(4,:),'LineWidth',1.5);
    
    axes(handles.epoch2);
    epoch_t2=text((2)*3+0.5,60,['Epoch N'],'FontName','Source Sans Pro','Color',c(4,:),'FontWeight','bold');
    epoch_p2=plot(e_t((2)*600+100:(2)*600+600),ch2_tplot((2)*600+100:(2)*600+600),'Color',c(4,:),'LineWidth',1.5);

        signal1=squeeze(handles.EEG(get(handles.ch_select1,'Value'),83,:));
    signal2=squeeze(handles.EEG(get(handles.ch_select2,'Value'),83,:));
    
axes(handles.chan_axis1);cla;
   t_title1= text(0.75,55,'Time Domain','FontWeight','bold','FontSize',8,'FontName','Source Sans Pro');
    plot(t,signal1,'Color',c(4,:),'LineWidth',1.5)
    
    axes(handles.chan_axis2);cla;
   t_title2= text(0.75,55,'Time Domain','FontWeight','bold','FontSize',8,'FontName','Source Sans Pro');
    plot(t,signal2,'Color',c(4,:),'LineWidth',1.5)
    
axes(handles.freq1);cla;
    f_title1= text(40,1600,'Frequency Domain','FontWeight','bold','FontSize',8,'FontName','Source Sans Pro');
    plot(f(1:Nf),abs(squeeze(handles.EEGf(get(handles.ch_select1,'Value'),83,1:Nf))),'Color',c(4,:),'LineWidth',1.5,'Parent',handles.freq1)


axes(handles.freq2);cla;
    f_title1= text(40,1600,'Frequency Domain','FontWeight','bold','FontSize',8,'FontName','Source Sans Pro');
    plot(f(1:Nf),abs(squeeze(handles.EEGf(get(handles.ch_select2,'Value'),83,1:Nf))),'Color',c(4,:),'LineWidth',1.5,'Parent',handles.freq2)


    pause(1);
    
R_max_ch1=max(real(squeeze(handles.EEGf(get(handles.ch_select1,'Value'),:,f_point))));
R_min_ch1=min(real(squeeze(handles.EEGf(get(handles.ch_select1,'Value'),:,f_point))));
I_max_ch1=max(imag(squeeze(handles.EEGf(get(handles.ch_select1,'Value'),:,f_point))));
I_min_ch1=min(imag(squeeze(handles.EEGf(get(handles.ch_select1,'Value'),:,f_point))));
ch1_lim=max(abs([R_max_ch1 R_min_ch1 I_max_ch1 I_min_ch1]));
R_max_ch2=max(real(squeeze(handles.EEGf(get(handles.ch_select2,'Value'),:,f_point))));
R_min_ch2=min(real(squeeze(handles.EEGf(get(handles.ch_select2,'Value'),:,f_point))));
I_max_ch2=max(imag(squeeze(handles.EEGf(get(handles.ch_select2,'Value'),:,f_point))));
I_min_ch2=min(imag(squeeze(handles.EEGf(get(handles.ch_select2,'Value'),:,f_point))));
ch2_lim=max(abs([R_max_ch2 R_min_ch2 I_max_ch2 I_min_ch2]));



%Show for Epoch N

axes(handles.workspace2);
ch1_vector=handles.EEGf(get(handles.ch_select1,'Value'),4:83,f_point);
plot([0 0],[-ch1_lim ch1_lim],'Color',[0.15 0.15 0.15]);
plot([-ch1_lim ch1_lim],[0 0],'Color',[0.15 0.15 0.15]);
quiver(zeros(1,length(ch1_vector)),zeros(1,length(ch1_vector),1),real(ch1_vector),imag(ch1_vector),'Color',c(4,:),'LineWidth',1);
xlim([-ch1_lim ch1_lim]);ylim([-ch1_lim ch1_lim]);

axes(handles.workspace3);
ch2_vector=handles.EEGf(get(handles.ch_select2,'Value'),4:83,f_point);
plot([0 0],[-ch2_lim ch2_lim],'Color',[0.15 0.15 0.15]);
plot([-ch2_lim ch2_lim],[0 0],'Color',[0.15 0.15 0.15]);
quiver(zeros(1,length(ch2_vector)),zeros(1,length(ch2_vector),1),real(ch2_vector),imag(ch2_vector),'Color',c(4,:),'LineWidth',1);
xlim([-ch2_lim ch2_lim]);ylim([-ch2_lim ch2_lim]);

m1=abs(ch1_vector);
m2=abs(ch2_vector);
m=m1.*m2;

theta1=atan(imag(ch1_vector)./real(ch1_vector));
theta2=atan(imag(ch2_vector)./real(ch2_vector));
theta=theta2-theta1;

v(:,1)=m.*cos(theta);v(:,2)=m.*sin(theta);

axes(handles.workspace4)
quiver(zeros(length(v),1),zeros(length(v),1),v(:,1),v(:,2),'Color',c(4,:),'LineWidth',1);

lims=max(max(abs(v)));
xlim([-lims lims]);ylim([-lims lims]);
plot([0 0],[-lims lims],'Color',[0.15 0.15 0.15]);
plot([-lims lims],[0 0],'Color',[0.15 0.15 0.15]);

pause(1.5)
delete(findobj('Type','Quiver'));
xlim([-1 1]);ylim([-1 1]);
ave_v=sum(v)/sum(m);
coher=norm(ave_v)^2;
q=quiver(zeros(length(v),1),zeros(length(v),1),v(:,1)./lims,v(:,2)./lims,'Color',[0.8 0.8 0.8],'LineWidth',1);
quiver(0,0,ave_v(1),ave_v(2),'Color','k','LineWidth',2);
uistack(q,'bottom');
text(0.1,0.9,['Coherence = ' num2str(coher,2)],'FontWeight','bold','FontSize',12,'FontName','Source Sans Pro','FontUnits','Normalized');
pause(1);

%%Plot Coherence Axis
axes(handles.epoch1);cla;axes(handles.epoch2);cla;
set(handles.workspace4,'Position',[handles.WS4(1) handles.WS4(2)+handles.WS4(4)*1/3 handles.WS4(3) handles.WS4(4)*2/3]);
axes(handles.workspace4);xlabel('');ylabel('');
set(handles.workspace2,'Visible','off');axes(handles.workspace2);cla;
set(handles.workspace3,'Visible','off');axes(handles.workspace3);cla;
set(handles.workspace6,'Visible','on');
axes(handles.workspace6);hold on
title('Coherence','FontName','Source Sans Pro');
xlim([0 100]);ylim([0 1]);
set(gca,'XTick',[0 50 100],'XTickLabel',[0 50 100]);set(gca,'YTick',[0 1],'YTickLabel',[0 1]);

sig1=squeeze(handles.EEGf(get(handles.ch_select1,'Value'),:,:));
sig2=squeeze(handles.EEGf(get(handles.ch_select2,'Value'),:,:));

% sig1=mean(sig1,1);
% sig2=mean(sig2,1);

C=smooth(abs(mean(sig1.*conj(sig2))).^2./((mean(abs(sig1).^2)).*((mean(abs(sig2).^2)))));
scatter(20,C(f_point),20,'MarkerFaceColor','r','MarkerEdgeColor','r');
pause(1);
plot(f(1:Nf),C(1:Nf),'Color','k','LineWidth',1.5);
function cross_corr( hObject, handles )
axes(handles.chan_axis1);
delete(findobj(gca,'Type','Scatter'));
axes(handles.chan_axis2);
delete(findobj(gca,'Type','Line'));
delete(findobj(gca,'Type','Scatter'));
zeroEEG=findobj(gca,'Type','AnimatedLine');
zeroEEG.Color=[0.8 0.8 0.8];
minVal=-16;maxVal=16;

if (get(handles.lag,'Value')-round(get(handles.lag,'Value'),2)<=0)
    lag=round(get(handles.lag,'Value'),2);
else
    lag=round(get(handles.lag,'Value'),2)+0.005;
end

t=-0.5:1/handles.fs:2.5;
%p=-0.5:10/handles.fs:2.5;
plot(t+lag,handles.aveEEG(get(handles.ch_select2,'Value'),:),'Color',[0.055 0.451 0.7255],'LineWidth',1.5);
plot([0 0],[-20 +20],'r--');%plot([-0.5 2.5],[0 0],'k--');

p=0+(lag-0.5)*(lag>0.5):10/handles.fs:2.5+lag*(lag<=0);
i=single(p*handles.fs)+101-lag*200;


ch1_points=handles.aveEEG(get(handles.ch_select1,'Value'),single(p*handles.fs)+101);
ch2_points=handles.aveEEG(get(handles.ch_select2,'Value'),:);
pause(0.5)
 scatter(p,ch1_points,20,'filled','MarkerFaceColor','r','Parent',handles.chan_axis1)
 scatter(p,ch2_points(i),20,'filled','MarkerFaceColor','r','Parent',handles.chan_axis2)
 
 axes(handles.workspace2);
 delete(findobj(gca,'Type','Scatter'));delete(findobj(gca,'Type','Line'));
 plot([0 0],[minVal maxVal],'Color',[0.15 0.15 0.15]);
plot([minVal maxVal],[0 0],'Color',[0.15 0.15 0.15]);
     scatter(ch1_points,ch2_points(i),15,'filled','MarkerFaceColor','r','Parent',handles.workspace2);
lsline;
 rho=corrcoef(ch1_points,ch2_points(i));
 rho=rho(2);
 
 axes(handles.workspace);
 scatter(lag,rho,30,'filled','MarkerFaceColor','k')
function granger( hObject, handles )
set(handles.workspace5,'Visible','on');

axes(handles.workspace5);cla;
delete(findobj(gca,'Type','Text'));
ch_text=text(0.85,0.92,['Ch 1 = X' char(10) 'Ch 2 = Y'],'FontName','Source Sans Pro','FontUnits','Normalized','FontSize',0.0455);
equation3(1:2)=text([1/10 1/10], [2/3 1/3],'','Color','k','FontName','Source Sans Pro','Interpreter', 'latex','FontUnits','Normalized','FontSize',0.052);
title('Granger Prediction','FontName','Source Sans Pro');%,'FontUnits','Normalized');

axes(handles.chan_axis1);points=findobj(gca,'Type','Scatter');delete(points)
axes(handles.chan_axis2);points=findobj(gca,'Type','Scatter');delete(points)
%Lettering for channels 1 and 2
chan_eq={'X' 'Y'};
labels={[handles.ChanLabels(get(handles.ch_select1,'Value'))] [handles.ChanLabels(get(handles.ch_select2,'Value'))]}; 
t=-0.5:1/handles.fs:2.5;
st_point=300;

data1=squeeze(handles.EEG(get(handles.ch_select1,'Value'),:,:));
data2=squeeze(handles.EEG(get(handles.ch_select2,'Value'),:,:));
%%Calculate Granger Prediction
Ntrial=83;
        p=5;
        AAbag=zeros(2,2*p,Ntrial);%NTrial=83
        Abag=zeros(1,1*p,Ntrial);
        Bbag=zeros(1,1*p,Ntrial);
        SwAbag=zeros(1,Ntrial);
        SwBbag=zeros(1,Ntrial);
        SwAAbag=zeros(2,2,Ntrial);

        for ti=1:Ntrial
            x1=data1(ti,:);
            x2=data2(ti,:);
            [~, A, SwA] = arfit2(x1.', 5, 5, 'sbc', 'zero');
            [~, B, SwB] = arfit2(x2.', 5, 5, 'sbc', 'zero');
            [~, AA, SwAA] = arfit2([x1;x2].', 5, 5, 'sbc', 'zero');
            Abag(:,:,ti)=A;
            Bbag(:,:,ti)=B;
            AAbag(:,:,ti)=AA;
            SwAbag(ti)=SwA;
            SwBbag(ti)=SwB;
            SwAAbag(:,:,ti)=SwAA;
        end
        
       AAest=mean(AAbag,3);
        SwAest=mean(SwAbag);
        SwBest=mean(SwBbag);
        SwAAest=mean(SwAAbag,3);
        G2to1=log(SwAest/SwAAest(1,1));
        G1to2=log(SwBest/SwAAest(2,2));
        
        gTO=[G2to1 G1to2];

%%


for i=1:2
    
    ch=i;
    alt_ch=~(i-1)+1;
    
    ch_axis=eval(['handles.chan_axis' int2str(ch)]);
    alt_ch_axis=eval(['handles.chan_axis' int2str(alt_ch)]);
    ch_pop=eval(['handles.ch_select' int2str(ch)]);
    alt_ch_pop=eval(['handles.ch_select' int2str(alt_ch)]);
    
    ch_signal=handles.aveEEG(get(ch_pop,'Value'),:);
    alt_ch_signal=handles.aveEEG(get(alt_ch_pop,'Value'),:);
    
       equation3(1).Visible=['off'];
              equation3(2).Visible=['off'];
              
    
    %for ARchan=[ch alt_ch]
    
%     %Univariate Equation
        axes(ch_axis);
        scatter(t(st_point),ch_signal(st_point),30,'MarkerFaceColor','r','MarkerEdgeColor','r');
        pause(0.5);
        axes(handles.workspace5);
         uni=text(0.3,0.9,['Univariate Autoregression'],'Color','k','FontName','Source Sans Pro','FontUnits','Normalized','FontSize',0.0455);
        equation1=text(1/20,4/5,[chan_eq{ch} '[n] = '],'Color','r','FontName','Source Sans Pro','FontUnits','Normalized','FontSize',0.0522);
        pause(0.5)
    
        for j=1:5
    
    
            axes(ch_axis);
            scatter(t(st_point-j*10),ch_signal(st_point-j*10),30,'MarkerFaceColor','k','MarkerEdgeColor','k');
    
            equation1.String=[equation1.String '{\color{black}    ' chan_eq{ch} '[n-' int2str(j) '] +}'];
            pause(0.5)
        end
        pause(0.75)
        %Full Equation
        equation1.String=[chan_eq{ch} '[n] = ' '{\color[rgb]{0.055 0.451 0.7255}a_{1}}' '{\color{black}' chan_eq{ch} '[n-1] +}' '{\color[rgb]{0.055 0.451 0.7255}a_{2}}' '{\color{black}' chan_eq{ch} '[n-2] +}' '{\color[rgb]{0.055 0.451 0.7255}a_{3}}' '{\color{black}' chan_eq{ch} '[n-3] +}' '{\color[rgb]{0.055 0.451 0.7255}a_{4}}' '{\color{black}' chan_eq{ch} '[n-4] +}' '{\color[rgb]{0.055 0.451 0.7255}a_{5}}' '{\color{black}' chan_eq{ch} '[n-5] }' char(10) '                   {\color{black}+}' '{\color[rgb]{1 0.4 0.4} \epsilon_{' chan_eq{ch} '}}' ];
        equation1.Position(2)=0.75;
        axes(handles.workspace5)
        note=text(0.3,0.1,['a,b = Weighting Coefficients' char(10) '{\color[rgb]{1 0.4 0.4}\epsilon = Error Values}'],'Color',[0.055 0.451 0.7255],'FontName','Source Sans Pro','FontUnits','Normalized','FontSize',0.039);
        %end
        pause(1);
        
        %Bivariate Equation
        
    axes(ch_axis);delete(findobj(gca,'Type','Scatter'));
    scatter(t(st_point),ch_signal(st_point),30,'MarkerFaceColor','r','MarkerEdgeColor','r');
    
    axes(handles.workspace5);
     bi=text(0.3,0.6,['Bivariate Autoregression'],'Color','k','FontName','Source Sans Pro','FontUnits','Normalized','FontSize',0.0455);

    equation2=text(1/20,1/2,[chan_eq{ch} '[n] = '],'Color','r','FontName','Source Sans Pro','FontUnits','Normalized','FontSize',0.0552);
    pause(1)
    
    for j=1:5
        
        
        axes(ch_axis);
        scatter(t(st_point-j*10),ch_signal(st_point-j*10),30,'MarkerFaceColor','k','MarkerEdgeColor','k');
        
        equation2.String=[equation2.String '{\color{black}    ' chan_eq{ch} '[n-' int2str(j) '] +}'];
        pause(0.5)
    end
    
    equation2.String(end-1:end)='} ';
    equation2.String=[equation2.String char(10) '                 '];
    
    axes(alt_ch_axis);
        scatter(t(st_point),alt_ch_signal(st_point),30,'MarkerFaceColor',[0.2 0.7 0.2],'MarkerEdgeColor',[0.2 0.7 0.2]);

        equation2.String{2}=[equation2.String{2} '{\color[rgb]{0.2 0.7 0.2}+ ' chan_eq{alt_ch} '[n]}'];
    pause(0.5)
    for j=1:5
        
        
        axes(alt_ch_axis);
        scatter(t(st_point-j*10),alt_ch_signal(st_point-j*10),30,'MarkerFaceColor',[0.2 0.7 0.2],'MarkerEdgeColor',[0.2 0.7 0.2]);
        
        equation2.String{2}=[equation2.String{2} '{\color[rgb]{0.2 0.7 0.2}+  ' chan_eq{alt_ch} '[n-' int2str(j) ']}'];
        pause(0.5)
    end
    
   %pause(0.75)
   equation2.String=[equation1.String{1} char(10) '                ' '{\color[rgb]{0.2 0.7 0.2}+}' '{\color[rgb]{0.055 0.451 0.7255}b_{0}}' '{\color[rgb]{0.2 0.7 0.2}' chan_eq{alt_ch} '[n] +}' '{\color[rgb]{0.055 0.451 0.7255}b_{1}}' '{\color[rgb]{0.2 0.7 0.2}' chan_eq{alt_ch} '[n-1] +}' '{\color[rgb]{0.055 0.451 0.7255}b_{2}}' '{\color[rgb]{0.2 0.7 0.2}' chan_eq{alt_ch} '[n-2] +}' '{\color[rgb]{0.055 0.451 0.7255}b_{3}}' '{\color[rgb]{0.2 0.7 0.2}' chan_eq{alt_ch} '[n-3] +}' '{\color[rgb]{0.055 0.451 0.7255}b_{4}}' '{\color[rgb]{0.2 0.7 0.2}' chan_eq{alt_ch} '[n-4]}' char(10) '{\color[rgb]{0.2 0.7 0.2}                  +}' '{\color[rgb]{0.055 0.451 0.7255}b_{5}}' '{\color[rgb]{0.2 0.7 0.2}' chan_eq{alt_ch} '[n-5] + }'  '{\color[rgb]{1 0.4 0.4} \epsilon_{XY}}' ];
   equation2.Position(2)=0.4;
   pause(2)
   
    delete(equation1);delete(equation2);axes(ch_axis);delete(note);delete(uni);delete(bi);
    delete(findobj(gca,'Type','Scatter'));axes(alt_ch_axis);delete(findobj(gca,'Type','Scatter'));
    axes(handles.workspace5)
       equation3(1).Visible=['on'];
              equation3(2).Visible=['on'];
              
   equation3(i).String=[char(labels{alt_ch}) '$$\rightarrow$$' char(labels{ch})  '$$ = ln(\frac{var(\epsilon_{' chan_eq{ch} '})}{var(\epsilon_{XY})}) = $$' num2str(gTO(ch),2)];
   pause(1.5);

   
end
function  pdc( hObject, handles )
%Calculate Partial Directed Coherence Factor
data1=squeeze(handles.EEG(get(handles.ch_select1,'Value'),:,:));
data2=squeeze(handles.EEG(get(handles.ch_select2,'Value'),:,:));
Ntrial=83;
p=5;
AAbag=zeros(2,2*p,Ntrial);%NTrial=83
Abag=zeros(1,1*p,Ntrial);
Bbag=zeros(1,1*p,Ntrial);
SwAbag=zeros(1,Ntrial);
SwBbag=zeros(1,Ntrial);
SwAAbag=zeros(2,2,Ntrial);

for ti=1:Ntrial
    x1=data1(ti,:);
    x2=data2(ti,:);
    [~, A, SwA] = arfit2(x1.', 5, 5, 'sbc', 'zero');
    [~, B, SwB] = arfit2(x2.', 5, 5, 'sbc', 'zero');
    [~, AA, SwAA] = arfit2([x1;x2].', 5, 5, 'sbc', 'zero');
    Abag(:,:,ti)=A;
    Bbag(:,:,ti)=B;
    AAbag(:,:,ti)=AA;
    SwAbag(ti)=SwA;
    SwBbag(ti)=SwB;
    SwAAbag(:,:,ti)=SwAA;
end

AAest=mean(AAbag,3);
SwAest=mean(SwAbag);
SwBest=mean(SwBbag);
SwAAest=mean(SwAAbag,3);

f=(0.01:0.01:1)/2;
nf=1:100;
Nf=100;
AAf=repmat(eye(2),1,1,Nf);
J(1,1,nf)=exp(-1j.*2.*pi.*f);
PDCF=zeros(1,1,Nf);

for pi1=1:p
    AAf=AAf-bsxfun(@times,repmat(AAest(:,2.*(pi1-1)+[1 2]),1,1,Nf),J.^pi1);
end

SwAAest=eye(2);

for fi1=nf
    PDCF(1,fi1)=squeeze(AAf(1,2,fi1))./(sqrt(squeeze(AAf(:,2,fi1))'*inv(SwAAest)*squeeze(AAf(:,2,fi1)))); %#ok<MINV>
end




ch_val1=get(handles.ch_select1,'Value');
ch_val2=get(handles.ch_select2,'Value');
ch_label1=handles.ChanLabels{ch_val1};
ch_label2=handles.ChanLabels{ch_val2};
ch_loc1=handles.ChanLocs(ch_val1,:);
ch_loc2=handles.ChanLocs(ch_val2,:);
%Determine if locations are on the same plane
p=~(abs(ch_loc1-ch_loc2)<11);



x_dir=(ch_loc1(1)-ch_loc2(1))/abs(ch_loc1(1)-ch_loc2(1))*p(1);
y_dir=(ch_loc1(1,2)-ch_loc2(1,2))/abs(ch_loc1(1,2)-ch_loc2(1,2))*p(2);
x_dir(isnan(x_dir))=0;
y_dir(isnan(y_dir))=0;

start= [(ch_loc2(1)+6 + x_dir*7), (ch_loc2(2) +y_dir*6)];
fin=[(ch_loc1(1)+6 - x_dir), (ch_loc1(2) - y_dir)];
%
% start= [(ch_loc2(1)),(ch_loc2(2))];
% fin=[(ch_loc1(1) ), (ch_loc1(2))];

bracket1=[0.32 0.95; 0.28 0.95; 0.28 0.55;0.32 0.55];
bracket2=[0.72 0.95; 0.76 0.95; 0.76 0.55;0.72 0.55];



set(handles.workspace5,'Visible','on');
set(handles.workspace6,'Visible','on');

axes(handles.workspace5);hold on;
xlim([0 1]);ylim([0 1]);
delete(findobj(gca,'Type','Line'));
title('Partial Directed Coherence','FontName','Source Sans Pro')
%Coefficient Matrix
coeffs=text(0.3,0.75,['A_{11}     A_{12}     A_{13}     .     .     .     A_{1N}' char(10) '{\color{red}A_{21}     }' 'A_{22}     A_{23}     .     .     .     A_{2N}' char(10) '   .          .          .         .     .     .      .' char(10) '   .          .          .         .     .     .      .' char(10) '   .          .          .         .     .     .      .' char(10) 'A_{N1}     A_{N2}     A_{N3}     .     .     .     A_{NN}'],'FontName','Source Sans Pro','FontUnits','Normalized','FontSize',0.0455);
b1=plot(bracket1(:,1),bracket1(:,2),'k','LineWidth',1);
b2=plot(bracket2(:,1),bracket2(:,2),'k','LineWidth',1);

axes(handles.workspace6);cla;
title('')
xlabel('Frequency','FontName','Source Sans Pro');ylabel(['A_{' ch_label2 '\rightarrow' ch_label1   '}'],'FontName','Source Sans Pro');
plot(nf,abs(squeeze(PDCF(1:Nf))),'LineWidth',1.5,'Color','r');
set(gca,'XTick',0:20:100,'XTickLabel',0:20:100,'YTick',0:0.2:1,'YTickLabel',0:0.2:1);
ylim([0 1]);

axes(handles.head_plot);
delete(findobj(gca,'Type','Quiver'));
quiver(start(1),start(2),fin(1)-start(1),fin(2)-start(2),'Color','r','LineWidth',1.5);
function pearsons( hObject, handles)

%Clear Previous Axes
axes(handles.workspace);delete(findobj(gca,'Type','Scatter'));delete(findobj(gca,'Type','Line'));delete(findobj(gca,'Type','Text'));
axes(handles.chan_axis1);points=findobj(gca,'Type','Scatter');delete(points)
axes(handles.chan_axis2);points=findobj(gca,'Type','Scatter');delete(points)

%Initialize Variables
points_ch1=handles.aveEEG(get(handles.ch_select1,'Value'),100:10:601);
points_ch2=handles.aveEEG(get(handles.ch_select2,'Value'),100:10:601);
t=0:10/handles.fs:2.5;
l=length(t);
%ch1_scat=scatter(nan(1,l),nan(1,l));
%ch2_scat=scatter(nan(1,l),nan(1,l));
%pearson_scat=scatter(nan(1,l),nan(1,l));
tick=scatter(nan(1,2),nan(1,2));
guide(1:2)=line(nan,nan);
minVal=-16;%min(min(min(handles.aveEEG)));
maxVal=16;%max(max(max(handles.aveEEG)));

%Set axis properties
axes(handles.workspace);
hold on;
title('Pearsons Correlation','FontName','Source Sans Pro');%,'FontUnits','Normalized');
xlabel('Channel 1 Amplitude (mV)','FontName','Source Sans Pro');ylabel('Channel 2 Amplitude (mV)','FontName','Source Sans Pro');
set(handles.workspace,'Visible','on');
xlim([minVal maxVal]);ylim([minVal maxVal]);
set(gca,'Box','on','XTick',[-16:4:16],'XTickLabel',[-16:4:16],'YTick',[-16:4:16],'YTickLabel',[-16:4:16])
plot([0 0],[minVal maxVal],'Color',[0.15 0.15 0.15]);
plot([minVal maxVal],[0 0],'Color',[0.15 0.15 0.15]);

% 
for i=1:3
    %Plot Points on Channel 1
    S=scatter(t(i),points_ch1(i),20,'filled','MarkerFaceColor','r','Parent',handles.chan_axis1);
    %Corresponding Pearson Point Plot
    tick(1)=scatter(points_ch1(i),0,100,'r+','LineWidth',1,'Parent',handles.workspace);pause(0.5);
    %Plot points on Channel 2
    scatter(t(i),points_ch2(i),20,'filled','MarkerFaceColor','r','Parent',handles.chan_axis2);
    %Corresponding Pearson point plot
    tick(2)=scatter(0,points_ch2(i),100,'r+','LineWidth',1,'Parent',handles.workspace);pause(0.5);
    guide(1)=plot([points_ch1(i) points_ch1(i)],[0 points_ch2(i)],'r--','Parent',handles.workspace);
    guide(2)=plot([0 points_ch1(i)],[points_ch2(i) points_ch2(i)],'r--','Parent',handles.workspace);
    delete(tick);pause(0.5);
    scatter(points_ch1(i),points_ch2(i),40,'filled','MarkerFaceColor','r','Parent',handles.workspace); pause(0.5);
    delete(guide);pause(0.5);
 
end

clear guide tick

for i=4:8
   scatter(t(i),points_ch1(i),20,'filled','MarkerFaceColor','r','Parent',handles.chan_axis1);
    scatter(t(i),points_ch2(i),20,'filled','MarkerFaceColor','r','Parent',handles.chan_axis2);
        scatter(points_ch1(i),points_ch2(i),40,'filled','MarkerFaceColor','r','Parent',handles.workspace); pause(0.75);
    
    
end
delete(findobj(gca,'Type','Scatter'))

   scatter(t(1:l),points_ch1(1:l),20,'filled','MarkerFaceColor','r','Parent',handles.chan_axis1);
    scatter(t(1:l),points_ch2(1:l),20,'filled','MarkerFaceColor','r','Parent',handles.chan_axis2);
    scatter(points_ch1(1:l),points_ch2(1:l),40,'filled','MarkerFaceColor','r','Parent',handles.workspace); pause(0.5);

    rho=corrcoef(points_ch1,points_ch2);
    H=lsline;
    H.Color='k';H.LineWidth=1.5;
    xlim([minVal maxVal]);ylim([minVal maxVal]);
    text(-10,10,['\rho = ' num2str(rho(1,2),2)],'FontSize',14,'FontName','Source Sans Pro','FontWeight','bold','FontUnits','Normalized');      
function select_chans( hObject, handles, ch, demo )
%Set Pop up menu and channel axis being used
pop=eval(['handles.ch_select' int2str(ch)]);
axis=eval(['handles.chan_axis' int2str(ch)]);
other_pop=eval(['handles.ch_select' int2str(~(ch-1)+1)]);
axes(axis);cla;delete(findobj(gca,'Type','AnimatedLine'));
axes(handles.head_plot)


set(handles.t,'FontUnits','Points');
prev_font=(handles.t(1).FontSize+handles.t(2).FontSize+handles.t(3).FontSize+handles.t(4).FontSize+handles.t(5).FontSize)/5;
set(handles.t,'Color','black','FontSize',prev_font,'FontWeight','normal','FontName','Source Sans Pro');
if ~(get(other_pop,'Value')==26)
set(handles.t(get(other_pop,'Value')),'Color',[0.055 0.451 0.7255],'FontSize',prev_font*1.1875,'FontWeight','bold','FontName','Source Sans Pro');
end
%If no channel is selected
if (get(pop,'Value')==26)
    
    return
    
end
%If selected channel is the same as the other, reset the channel to nothing
if (get(pop,'Value')==get(other_pop,'Value'))
    
    set(pop,'Value',26);
    return
    
end

set(handles.t(get(pop,'Value')),'Color',[0.055 0.451 0.7255],'FontSize',prev_font*1.1875,'FontWeight','bold','FontName','Source Sans Pro');

axes(axis);
G=animatedline('Color',[0.055 0.451 0.7255],'LineWidth',1.5);
signal=handles.aveEEG(get(pop,'Value'),:);
ylim([min(signal)-1 max(signal)+1])
t=-0.5:1/handles.fs:2.5;

if demo
for i=1:3:length(signal)-1
    addpoints(G,t(i:i+2),signal(i:i+2));
    pause(0.00001)
end
else
plot(t,signal,'Color',[0.055 0.451 0.7255],'LineWidth',1.5)
end

plot([0 0],[min(signal) max(signal)],'r--');%plot([-0.5 2.5],[0 0],'k--');
set(gca,'XTick',[-0.5 0 1 2],'XTickLabel',[-0.5 0 1 2],'YTick',[round(min(signal)) 0 round(max(signal))],'YTickLabel',[round(min(signal)) 0 round(max(signal))])

xlim([-0.5 2.5]);

set(handles.t,'FontUnits','Normalized');    
function Y = bmeaner(X,n)
%Subtracts the means of X (along n'th dimension) from X
Y=bsxfun(@minus,X,mean(X,n));
function [w, MAR, C, sbc, fpe, th] = arfit2(Y, pmin, pmax, selector, no_const)
% ARFIT2 estimates multivariate autoregressive parameters
% of the MVAR process Y
%
%   Y(t,:)' = w' + A1*Y(t-1,:)' + ... + Ap*Y(t-p,:)' + x(t,:)'
%
% ARFIT2 uses the Nutall-Strand method (multivariate Burg algorithm) 
% which provides better estimates the ARFIT [1], and uses the 
% same arguments. Moreover, ARFIT2 is faster and can deal with 
% missing values encoded as NaNs. 
%
% [w, A, C, sbc, fpe] = arfit2(v, pmin, pmax, selector, no_const)
%
% INPUT: 
%  v		data - each channel in a column
%  pmin, pmax 	minimum and maximum model order
%  selector	'fpe' or 'sbc' [default] 
%  no_const	'zero' indicates no bias/offset need to be estimated 
%		in this case is w = [0, 0, ..., 0]'; 
%
% OUTPUT: 
%  w		mean of innovation noise
%  A		[A1,A2,...,Ap] MVAR estimates	
%  C		covariance matrix of innovation noise
%  sbc, fpe	criteria for model order selection 
%
% see also: ARFIT, MVAR
%
% REFERENCES:
%  [1] A. Schloegl, 2006, Comparison of Multivariate Autoregressive Estimators.
%       Signal processing, p. 2426-9.
%  [2] T. Schneider and A. Neumaier, 2001. 
%	Algorithm 808: ARFIT-a Matlab package for the estimation of parameters and eigenmodes 
%	of multivariate autoregressive models. ACM-Transactions on Mathematical Software. 27, (Mar.), 58-65.

%       $Id: arfit2.m 11693 2013-03-04 06:40:14Z schloegl $
%	Copyright (C) 1996-2005,2008,2012 by Alois Schloegl <alois.schloegl@ist.ac.at>	
%       This is part of the TSA-toolbox. See also 
%       http://pub.ist.ac.at/~schloegl/matlab/tsa/
%       http://octave.sourceforge.net/
%       http://biosig.sourceforge.net/

%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.


%%%%% checking of the input arguments was done the same way as ARFIT
if (pmin ~= round(pmin) || pmax ~= round(pmax))
        error('Order must be integer.');
end
if (pmax < pmin)
        error('PMAX must be greater than or equal to PMIN.')
end

% set defaults and check for optional arguments
if (nargin == 3)              	% no optional arguments => set default values
        mcor       = 1;         % fit intercept vector
        selector   = 'sbc';	% use SBC as order selection criterion
elseif (nargin == 4)          	% one optional argument
        if strcmp(selector, 'zero')
                mcor     = 0;   % no intercept vector to be fitted
                selector = 'sbc';	% default order selection 
        else
                mcor     = 1;	% fit intercept vector
        end
elseif (nargin == 5)		% two optional arguments
        if strcmp(no_const, 'zero')
                mcor     = 0;   	% no intercept vector to be fitted
        else
                error(['Bad argument. Usage: ', '[w,A,C,SBC,FPE,th]=AR(v,pmin,pmax,SELECTOR,''zero'')'])
        end
end



%%%%% Implementation of the MVAR estimation 
[N,M]=size(Y);
    
if mcor,
        [m,N] = sumskipnan(Y,1);                    % calculate mean 
        m = m./N;
	Y = Y - repmat(m,size(Y)./size(m));    % remove mean    
end;

[MAR,RCF,PE] = mvar(Y, pmax, 2);   % estimate MVAR(pmax) model

N = min(N);

%if 1;nargout>3;
ne = N-mcor-(pmin:pmax);
for p=pmin:pmax, 
        % Get downdated logarithm of determinant
        logdp(p-pmin+1) = log(det(PE(:,p*M+(1:M))*(N-p-mcor))); 
end;

% Schwarz's Bayesian Criterion
sbc = logdp/M - log(ne) .* (1-(M*(pmin:pmax)+mcor)./ne);

% logarithm of Akaike's Final Prediction Error
fpe = logdp/M - log(ne.*(ne-M*(pmin:pmax)-mcor)./(ne+M*(pmin:pmax)+mcor));

% Modified Schwarz criterion (MSC):
% msc(i) = logdp(i)/m - (log(ne) - 2.5) * (1 - 2.5*np(i)/(ne-np(i)));

% get index iopt of order that minimizes the order selection 
% criterion specified by the variable selector
if strcmpi(selector,'fpe'); 
    [val, iopt]  = min(fpe); 
else %if strcmpi(selector,'sbc'); 
    [val, iopt]  = min(sbc); 
end; 

% select order of model
popt = pmin + iopt-1; % estimated optimum order 

if popt<pmax, 
        [MAR, RCF, PE] = mvar(Y, popt, 2);
end;
%end

C = PE(:,size(PE,2)+(1-M:0));

if mcor,
        I = eye(M);        
        for k = 1:popt,
                I = I - MAR(:,k*M+(1-M:0));
        end;
        w = -I*m';
else
        w = zeros(M,1);
end;

if nargout>5,	th=[];	fprintf(2,'Warning ARFIT2: output TH not defined\n'); end;
function [CC,NN] = covm(X,Y,Mode,W)
% COVM generates covariance matrix
% X and Y can contain missing values encoded with NaN.
% NaN's are skipped, NaN do not result in a NaN output. 
% The output gives NaN only if there are insufficient input data
%
% COVM(X,Mode);
%      calculates the (auto-)correlation matrix of X
% COVM(X,Y,Mode);
%      calculates the crosscorrelation between X and Y
% COVM(...,W);
%	weighted crosscorrelation 
%
% Mode = 'M' minimum or standard mode [default]
% 	C = X'*X; or X'*Y correlation matrix
%
% Mode = 'E' extended mode
% 	C = [1 X]'*[1 X]; % l is a matching column of 1's
% 	C is additive, i.e. it can be applied to subsequent blocks and summed up afterwards
% 	the mean (or sum) is stored on the 1st row and column of C
%
% Mode = 'D' or 'D0' detrended mode
%	the mean of X (and Y) is removed. If combined with extended mode (Mode='DE'), 
% 	the mean (or sum) is stored in the 1st row and column of C. 
% 	The default scaling is factor (N-1). 
% Mode = 'D1' is the same as 'D' but uses N for scaling. 
%
% C = covm(...); 
% 	C is the scaled by N in Mode M and by (N-1) in mode D.
% [C,N] = covm(...);
%	C is not scaled, provides the scaling factor N  
%	C./N gives the scaled version. 
%
% see also: DECOVM, XCOVF

%	$Id: covm.m 9032 2011-11-08 20:25:36Z schloegl $
%	Copyright (C) 2000-2005,2009 by Alois Schloegl <alois.schloegl@gmail.com>	
%       This function is part of the NaN-toolbox
%       http://pub.ist.ac.at/~schloegl/matlab/NaN/

%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; If not, see <http://www.gnu.org/licenses/>.


global FLAG_NANS_OCCURED;

if nargin<3,
	W = []; 
        if nargin==2,
		if isnumeric(Y),
			Mode='M';
		else
			Mode=Y;
			Y=[];
		end;
        elseif nargin==1,
                Mode = 'M';
                Y = [];
        elseif nargin==0,
                error('Missing argument(s)');
        end;

elseif (nargin==3) && isnumeric(Y) && ~isnumeric(Mode);
	W = [];

elseif (nargin==3) && ~isnumeric(Y) && isnumeric(Mode);
	W = Mode; 
	Mode = Y;
	Y = [];

elseif (nargin==4) && ~isnumeric(Mode) && isnumeric(Y);
	; %% ok 
else 
	error('invalid input arguments');
end;

Mode = upper(Mode);

[r1,c1]=size(X);
if ~isempty(Y)
        [r2,c2]=size(Y);
        if r1~=r2,
                error('X and Y must have the same number of observations (rows).');
        end;
else
        [r2,c2]=size(X);
end;

persistent mexFLAG2; 
persistent mexFLAG; 
if isempty(mexFLAG2) 
	mexFLAG2 = exist('covm_mex','file');	
end; 
if isempty(mexFLAG) 
	mexFLAG = exist('sumskipnan_mex','file');	
end; 


if ~isempty(W)
	W = W(:);
	if (r1~=numel(W))
		error('Error COVM: size of weight vector does not fit number of rows');
	end;
	%w = spdiags(W(:),0,numel(W),numel(W));
	%nn = sum(W(:)); 
	nn = sum(W);
else
	nn = r1;
end; 


if mexFLAG2 && mexFLAG && ~isempty(W),
	%%the mex-functions here are much slower than the m-scripts below 
	%%however, the mex-functions support weighting of samples. 
	if isempty(FLAG_NANS_OCCURED),
		%%mex-files require that FLAG_NANS_OCCURED is not empty, 
		%%otherwise, the status of NAN occurence can not be returned. 
		FLAG_NANS_OCCURED = logical(0);  % default value 
	end;

	if any(Mode=='D') || any(Mode=='E'),
		[S1,N1] = sumskipnan(X,1,W);
		if ~isempty(Y)
	               	[S2,N2] = sumskipnan(Y,1,W);
	        else
	        	S2 = S1; N2 = N1;
		end;
                if any(Mode=='D'), % detrending mode
       			X  = X - ones(r1,1)*(S1./N1);
                        if ~isempty(Y)
                                Y  = Y - ones(r1,1)*(S2./N2);
                        end;
                end;
	end;

	[CC,NN] = covm_mex(real(X), real(Y), FLAG_NANS_OCCURED, W);
	%%complex matrices 
	if ~isreal(X) && ~isreal(Y)
		[iCC,inn] = covm_mex(imag(X), imag(Y), FLAG_NANS_OCCURED, W);
		CC = CC + iCC;
	end; 
	if isempty(Y) Y = X; end;
	if ~isreal(X)
		[iCC,inn] = covm_mex(imag(X), real(Y), FLAG_NANS_OCCURED, W);
		CC = CC - i*iCC;
	end;
	if ~isreal(Y)
		[iCC,inn] = covm_mex(real(X), imag(Y), FLAG_NANS_OCCURED, W);
		CC = CC + i*iCC;
	end;
	
        if any(Mode=='D') && ~any(Mode=='1'),  %  'D1'
                NN = max(NN-1,0);
        end;
        if any(Mode=='E'), % extended mode
                NN = [nn, N2; N1', NN];
                CC = [nn, S2; S1', CC];
        end;


elseif ~isempty(W),

	error('Error COVM: weighted COVM requires sumskipnan_mex and covm_mex but it is not available');

	%%weighted covm without mex-file support
	%%this part is not working.

elseif ~isempty(Y),
	if (~any(Mode=='D') && ~any(Mode=='E')), % if Mode == M
        	NN = real(X==X)'*real(Y==Y);
		FLAG_NANS_OCCURED = any(NN(:)<nn);
	        X(X~=X) = 0; % skip NaN's
	        Y(Y~=Y) = 0; % skip NaN's
        	CC = X'*Y;

        else  % if any(Mode=='D') | any(Mode=='E'), 
        	[S1,N1] = sumskipnan(X,1);
               	[S2,N2] = sumskipnan(Y,1);
               	NN = real(X==X)'*real(Y==Y);

                if any(Mode=='D'), % detrending mode
			X  = X - ones(r1,1)*(S1./N1);
			Y  = Y - ones(r1,1)*(S2./N2);
			if any(Mode=='1'),  %  'D1'
				NN = NN;
			else	%  'D0'       
				NN = max(NN-1,0);
			end;
                end;
		X(X~=X) = 0; % skip NaN's
		Y(Y~=Y) = 0; % skip NaN's
               	CC = X'*Y;

                if any(Mode=='E'), % extended mode
                        NN = [nn, N2; N1', NN];
                        CC = [nn, S2; S1', CC];
                end;
	end;

else
	if (~any(Mode=='D') && ~any(Mode=='E')), % if Mode == M
		tmp = real(X==X);
		NN  = tmp'*tmp;
		X(X~=X) = 0; % skip NaN's
	        CC = X'*X;
		FLAG_NANS_OCCURED = any(NN(:)<nn);

        else  % if any(Mode=='D') | any(Mode=='E'), 
	        [S,N] = sumskipnan(X,1);
       		tmp = real(X==X);
               	NN  = tmp'*tmp;
       	        if any(Mode=='D'), % detrending mode
        	        X  = X - ones(r1,1)*(S./N);
                       	if any(Mode=='1'),  %  'D1'
                               	NN = NN;
                        else  %  'D0'      
       	                        NN = max(NN-1,0);
               	        end;
                end;
                
       	        X(X~=X) = 0; % skip NaN's
		CC = X'*X;
                if any(Mode=='E'), % extended mode
                        NN = [nn, N; N', NN];
                        CC = [nn, S; S', CC];
                end;
	end

end;


if nargout<2
        CC = CC./NN; % unbiased
end;
function [ARF,RCF,PE,DC,varargout] = mvar(Y, Pmax, Mode);
% MVAR estimates parameters of the Multi-Variate AutoRegressive model 
%
%    Y(t) = Y(t-1) * A1 + ... + Y(t-p) * Ap + X(t);  
% whereas
%    Y(t) is a row vecter with M elements Y(t) = y(t,1:M) 
%
% Several estimation algorithms are implemented, all estimators 
% can handle data with missing values encoded as NaNs.  
%
% 	[AR,RC,PE] = mvar(Y, p);
% 	[AR,RC,PE] = mvar(Y, p, Mode);
% 
% with 
%       AR = [A1, ..., Ap];
%
% INPUT:
%  Y	 Multivariate data series 
%  p     Model order
%  Mode	 determines estimation algorithm 
%
% OUTPUT:
%  AR    multivariate autoregressive model parameter
%  RC    reflection coefficients (= -PARCOR coefficients)
%  PE    remaining error variances for increasing model order
%	   PE(:,p*M+[1:M]) is the residual variance for model order p
%
% All input and output parameters are organized in columns, one column 
% corresponds to the parameters of one channel.
%
% Mode determines estimation algorithm. 
%  1:  Correlation Function Estimation method using biased correlation function estimation method
%   		also called the 'multichannel Yule-Walker' [1,2] 
%  6:  Correlation Function Estimation method using unbiased correlation function estimation method
%
%  2:  Partial Correlation Estimation: Vieira-Morf [2] using unbiased covariance estimates.
%               In [1] this mode was used and (incorrectly) denominated as Nutall-Strand. 
%		Its the DEFAULT mode; according to [1] it provides the most accurate estimates.
%  5:  Partial Correlation Estimation: Vieira-Morf [2] using biased covariance estimates.
%		Yields similar results than Mode=2;
%
%  3:  buggy: Partial Correlation Estimation: Nutall-Strand [2] (biased correlation function)
%  9:  Partial Correlation Estimation: Nutall-Strand [2] (biased correlation function)
%  7:  Partial Correlation Estimation: Nutall-Strand [2] (unbiased correlation function)
%  8:  Least Squares w/o nans in Y(t):Y(t-p)
% 10:  ARFIT [3] 
% 11:  BURGV [4] 
% 13:  modified BURGV -  
% 14:  modified BURGV [4] 
% 15:  Least Squares based on correlation matrix
% 22: Modified Partial Correlation Estimation: Vieira-Morf [2,5] using unbiased covariance estimates.
% 25: Modified Partial Correlation Estimation: Vieira-Morf [2,5] using biased covariance estimates.
%
% 90,91,96: Experimental versions 
%
%    Imputation methods:
%  100+Mode: 
%  200+Mode: forward, past missing values are assumed zero
%  300+Mode: backward, past missing values are assumed zero
%  400+Mode: forward+backward, past missing values are assumed zero
% 1200+Mode: forward, past missing values are replaced with predicted value
% 1300+Mode: backward, 'past' missing values are replaced with predicted value
% 1400+Mode: forward+backward, 'past' missing values are replaced with predicted value
% 2200+Mode: forward, past missing values are replaced with predicted value + noise to prevent decaying
% 2300+Mode: backward, past missing values are replaced with predicted value + noise to prevent decaying
% 2400+Mode: forward+backward, past missing values are replaced with predicted value + noise to prevent decaying
%
%
%

% REFERENCES:
%  [1] A. Schloegl, Comparison of Multivariate Autoregressive Estimators.
%       Signal processing, Elsevier B.V. (in press). 
%       available at http://dx.doi.org/doi:10.1016/j.sigpro.2005.11.007
%  [2] S.L. Marple 'Digital Spectral Analysis with Applications' Prentice Hall, 1987.
%  [3] Schneider and Neumaier)
%  [4] Stijn de Waele, 2003
%  [5]  M. Morf, et al. Recursive Multichannel Maximum Entropy Spectral Estimation, 
%      IEEE trans. GeoSci. Elec., 1978, Vol.GE-16, No.2, pp85-94.
%
%
% A multivariate inverse filter can be realized with 
%   [AR,RC,PE] = mvar(Y,P);
%   e = mvfilter([eye(size(AR,1)),-AR],eye(size(AR,1)),Y);
%  
% see also: MVFILTER, MVFREQZ, COVM, SUMSKIPNAN, ARFIT2

%	$Id: mvar.m 11693 2013-03-04 06:40:14Z schloegl $
%	Copyright (C) 1996-2006,2011,2012 by Alois Schloegl <alois.schloegl@ist.ac.at>	
%       This is part of the TSA-toolbox. See also 
%       http://pub.ist.ac.at/~schloegl/matlab/tsa/
%       http://octave.sourceforge.net/
%       http://biosig.sourceforge.net/
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.


% Inititialization
[N,M] = size(Y);

if nargin<2, 
        Pmax=max([N,M])-1;
end;

if iscell(Y)
        Pmax = min(max(N ,M ),Pmax);
        C    = Y;
end;
if nargin<3,
        % according to [1], and other internal validations this is in many cases the best algorithm 
        Mode=2;
end;

[C(:,1:M),n] = covm(Y,'M');
PE(:,1:M)  = C(:,1:M)./n;
if 0,
elseif Mode==0;  % this method is broken
        fprintf('Warning MVAR: Mode=0 is broken.\n')        
        C(:,1:M) = C(:,1:M)/N;
        F = Y;
        B = Y;
        PEF = C(:,1:M);  %?% PEF = PE(:,1:M);
        PEB = C(:,1:M);
        for K=1:Pmax,
                [D,n] = covm(Y(K+1:N,:),Y(1:N-K,:),'M');
	        D = D/N;
                ARF(:,K*M+(1-M:0)) = D/PEB;	
                ARB(:,K*M+(1-M:0)) = D'/PEF;	
                
                tmp        = F(K+1:N,:) - B(1:N-K,:)*ARF(:,K*M+(1-M:0))';
                B(1:N-K,:) = B(1:N-K,:) - F(K+1:N,:)*ARB(:,K*M+(1-M:0))';
                F(K+1:N,:) = tmp;
                
                for L = 1:K-1,
                        tmp      = ARF(:,L*M+(1-M:0))   - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))   = tmp;
                end;
                
                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
                RCB(:,K*M+(1-M:0)) = ARB(:,K*M+(1-M:0));
                
                PEF = [eye(M) - ARF(:,K*M+(1-M:0))*ARB(:,K*M+(1-M:0))]*PEF;
                PEB = [eye(M) - ARB(:,K*M+(1-M:0))*ARF(:,K*M+(1-M:0))]*PEB;
                PE(:,K*M+(1:M)) = PEF;        
        end;

        
elseif Mode==1, %%%%%Levinson-Wiggens-Robinson (LWR) algorithm using biased correlation function
	% ===== In [1,2] this algorithm is denoted 'Multichannel Yule-Walker' ===== %
        C(:,1:M) = C(:,1:M)/N;
        PEF = C(:,1:M);  
        PEB = C(:,1:M);
        
        for K=1:Pmax,
                [C(:,K*M+(1:M)),n] = covm(Y(K+1:N,:),Y(1:N-K,:),'M');
                C(:,K*M+(1:M)) = C(:,K*M+(1:M))/N;

                D = C(:,K*M+(1:M));
                for L = 1:K-1,
                        D = D - ARF(:,L*M+(1-M:0))*C(:,(K-L)*M+(1:M));
                end;
                ARF(:,K*M+(1-M:0)) = D / PEB;	
                ARB(:,K*M+(1-M:0)) = D'/ PEF;	
                for L = 1:K-1,
                        tmp                    = ARF(:,L*M+(1-M:0)) - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))     = tmp;
                end;
                
                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
                RCB(:,K*M+(1-M:0)) = ARB(:,K*M+(1-M:0));
                
                PEF = [eye(M) - ARF(:,K*M+(1-M:0))*ARB(:,K*M+(1-M:0))]*PEF;
                PEB = [eye(M) - ARB(:,K*M+(1-M:0))*ARF(:,K*M+(1-M:0))]*PEB;
                PE(:,K*M+(1:M)) = PEF;        
        end;

        
elseif Mode==6, %%%%% Levinson-Wiggens-Robinson (LWR) algorithm using unbiased correlation function
        C(:,1:M) = C(:,1:M)/N;
        PEF = C(:,1:M);  %?% PEF = PE(:,1:M);
        PEB = C(:,1:M);
        
        for K = 1:Pmax,
                [C(:,K*M+(1:M)),n] = covm(Y(K+1:N,:),Y(1:N-K,:),'M');
                C(:,K*M+(1:M)) = C(:,K*M+(1:M))./n;
		%C{K+1} = C{K+1}/N;

                D = C(:,K*M+(1:M));
                for L = 1:K-1,
                        D = D - ARF(:,L*M+(1-M:0))*C(:,(K-L)*M+(1:M));
                end;
                ARF(:,K*M+(1-M:0)) = D / PEB;	
                ARB(:,K*M+(1-M:0)) = D'/ PEF;	
                for L = 1:K-1,
                        tmp      = ARF(:,L*M+(1-M:0))   - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))   = tmp;
                end;
                
                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
                RCB(:,K*M+(1-M:0)) = ARB(:,K*M+(1-M:0));
                
                PEF = [eye(M) - ARF(:,K*M+(1-M:0))*ARB(:,K*M+(1-M:0))]*PEF;
                PEB = [eye(M) - ARB(:,K*M+(1-M:0))*ARF(:,K*M+(1-M:0))]*PEB;
                PE(:,K*M+(1:M)) = PEF;        
        end;
        

elseif Mode==2 %%%%% Partial Correlation Estimation: Vieira-Morf Method [2] with unbiased covariance estimation
	%===== In [1] this algorithm is denoted 'Nutall-Strand with unbiased covariance' =====%
        %C(:,1:M) = C(:,1:M)/N;
        F = Y;
        B = Y;
        %PEF = C(:,1:M);
        %PEB = C(:,1:M);
        PEF = PE(:,1:M);
        PEB = PE(:,1:M);
        for K = 1:Pmax,
                [D,n] = covm(F(K+1:N,:),B(1:N-K,:),'M');
                D = D./n;

		ARF(:,K*M+(1-M:0)) = D / PEB;	
                ARB(:,K*M+(1-M:0)) = D'/ PEF;	
                
                tmp        = F(K+1:N,:) - B(1:N-K,:)*ARF(:,K*M+(1-M:0)).';
                B(1:N-K,:) = B(1:N-K,:) - F(K+1:N,:)*ARB(:,K*M+(1-M:0)).';
                F(K+1:N,:) = tmp;
                
                for L = 1:K-1,
                        tmp      = ARF(:,L*M+(1-M:0))   - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))   = tmp;
                end;
                
                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
                RCB(:,K*M+(1-M:0)) = ARB(:,K*M+(1-M:0));
                
                [PEF,n] = covm(F(K+1:N,:),F(K+1:N,:),'M');
                PEF = PEF./n;

		[PEB,n] = covm(B(1:N-K,:),B(1:N-K,:),'M');
                PEB = PEB./n;

                PE(:,K*M+(1:M)) = PEF;        
        end;
        

elseif Mode==5 %%%%% Partial Correlation Estimation: Vieira-Morf Method [2] with biased covariance estimation
	%===== In [1] this algorithm is denoted 'Nutall-Strand with biased covariance' ===== %

        F = Y;
        B = Y;
        PEF = C(:,1:M);
        PEB = C(:,1:M);
        for K=1:Pmax,
                [D,n]  = covm(F(K+1:N,:),B(1:N-K,:),'M');
                %D=D/N;

                ARF(:,K*M+(1-M:0)) = D / PEB;	
                ARB(:,K*M+(1-M:0)) = D'/ PEF;	
                
                tmp        = F(K+1:N,:) - B(1:N-K,:)*ARF(:,K*M+(1-M:0)).';
                B(1:N-K,:) = B(1:N-K,:) - F(K+1:N,:)*ARB(:,K*M+(1-M:0)).';
                F(K+1:N,:) = tmp;
                
                for L = 1:K-1,
                        tmp = ARF(:,L*M+(1-M:0)) - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))   = tmp;
                end;
                
                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
                RCB(:,K*M+(1-M:0)) = ARB(:,K*M+(1-M:0));
                
                [PEB,n] = covm(B(1:N-K,:),B(1:N-K,:),'M');
                %PEB = D/N;

                [PEF,n] = covm(F(K+1:N,:),F(K+1:N,:),'M');
                %PEF = D/N;

                %PE(:,K*M+(1:M)) = PEF; 
                PE(:,K*M+(1:M)) = PEF./n;
        end;
        
      
elseif 0, Mode==3 %%%%% Partial Correlation Estimation: Nutall-Strand Method [2] with biased covariance estimation
        %%% OBSOLETE because its buggy, use Mode=9 instead.  
        % C(:,1:M) = C(:,1:M)/N; 
        F = Y;
        B = Y;
        PEF = C(:,1:M);
        PEB = C(:,1:M);
        for K=1:Pmax,
                [D, n]  = covm(F(K+1:N,:),B(1:N-K,:),'M');
                D = D./N;

                ARF(:,K*M+(1-M:0)) = 2*D / (PEB+PEF);	
                ARB(:,K*M+(1-M:0)) = 2*D'/ (PEF+PEB);	
                
                tmp        = F(K+1:N,:) - B(1:N-K,:)*ARF(:,K*M+(1-M:0)).';
                B(1:N-K,:) = B(1:N-K,:) - F(K+1:N,:)*ARB(:,K*M+(1-M:0)).';
                F(K+1:N,:) = tmp;
                
                for L = 1:K-1,
                        tmp      = ARF(:,L*M+(1-M:0))   - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))   = tmp;
                end;
                
                %RCF{K} = ARF{K};
                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
                
                [PEF,n] = covm(F(K+1:N,:),F(K+1:N,:),'M');
                PEF = PEF./N;

		[PEB,n] = covm(B(1:N-K,:),B(1:N-K,:),'M');
                PEB = PEB./N;

                %PE(:,K*M+(1:M)) = PEF;        
                PE(:,K*M+(1:M)) = PEF./n;
        end;

        
elseif Mode==7 %%%%% Partial Correlation Estimation: Nutall-Strand Method [2] with unbiased covariance estimation 

        F = Y;
        B = Y;
        PEF = PE(:,1:M);
        PEB = PE(:,1:M);
        for K = 1:Pmax,
                [D]  = covm(F(K+1:N,:),B(1:N-K,:),'M');
                %D = D./n;

                ARF(:,K*M+(1-M:0)) = 2*D / (PEB+PEF);	
                ARB(:,K*M+(1-M:0)) = 2*D'/ (PEF+PEB);	
                
                tmp        = F(K+1:N,:) - B(1:N-K,:)*ARF(:,K*M+(1-M:0)).';
                B(1:N-K,:) = B(1:N-K,:) - F(K+1:N,:)*ARB(:,K*M+(1-M:0)).';
                F(K+1:N,:) = tmp;
                
                for L = 1:K-1,
                        tmp      = ARF(:,L*M+(1-M:0))   - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))   = tmp;
                end;
                
                %RCF{K} = ARF{K};
                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
                
                [PEF] = covm(F(K+1:N,:),F(K+1:N,:),'M');
                %PEF = PEF./n;

                [PEB] = covm(B(1:N-K,:),B(1:N-K,:),'M');
                %PEB = PEB./n;

                %PE{K+1} = PEF;        
                PE(:,K*M+(1:M)) = PEF;        
        end;


elseif any(Mode==[3,9]) %%%%% Partial Correlation Estimation: Nutall-Strand Method [2] with biased covariance estimation
	%same as 3 but with fixed normalization
        F = Y;
        B = Y;
        PEF = C(:,1:M);
        PEB = C(:,1:M);
        for K=1:Pmax,
                [D, n]  = covm(F(K+1:N,:),B(1:N-K,:),'M');

                ARF(:,K*M+(1-M:0)) = 2*D / (PEB+PEF);	
                ARB(:,K*M+(1-M:0)) = 2*D'/ (PEF+PEB);	
                
                tmp        = F(K+1:N,:) - B(1:N-K,:)*ARF(:,K*M+(1-M:0)).';
                B(1:N-K,:) = B(1:N-K,:) - F(K+1:N,:)*ARB(:,K*M+(1-M:0)).';
                F(K+1:N,:) = tmp;
                
                for L = 1:K-1,
                        tmp      = ARF(:,L*M+(1-M:0))   - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))   = tmp;
                end;
                
                %RCF{K} = ARF{K};
                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
                
                [PEF,nf] = covm(F(K+1:N,:),F(K+1:N,:),'M');
		[PEB,nb] = covm(B(1:N-K,:),B(1:N-K,:),'M');

                %PE(:,K*M+(1:M)) = PEF;        
                PE(:,K*M+(1:M)) = PEF./nf;
        end;
        
        
elseif Mode==4,  %%%%% Kay, not fixed yet. 
        fprintf('Warning MVAR: Mode=4 is broken.\n')        
        
        C(:,1:M) = C(:,1:M)/N;
        K = 1;
        [C(:,M+(1:M)),n] = covm(Y(2:N,:),Y(1:N-1,:));
        C(:,M+(1:M)) = C(:,M+(1:M))/N;  % biased estimate

        D = C(:,M+(1:M));
        ARF(:,1:M) = C(:,1:M)\D;
        ARB(:,1:M) = C(:,1:M)\D';
        RCF(:,1:M) = ARF(:,1:M);
        RCB(:,1:M) = ARB(:,1:M);
        PEF = C(:,1:M)*[eye(M) - ARB(:,1:M)*ARF(:,1:M)];
        PEB = C(:,1:M)*[eye(M) - ARF(:,1:M)*ARB(:,1:M)];
        
        for K=2:Pmax,
                [C(:,K*M+(1:M)),n] = covm(Y(K+1:N,:),Y(1:N-K,:),'M');
                C(:,K*M+(1:M)) = C(:,K*M+(1:M)) / N; % biased estimate

                D = C(:,K*M+(1:M));
                for L = 1:K-1,
                        D = D - C(:,(K-L)*M+(1:M))*ARF(:,L*M+(1-M:0));
                end;
                
                ARF(:,K*M+(1-M:0)) = PEB \ D;	
                ARB(:,K*M+(1-M:0)) = PEF \ D';	
                for L = 1:K-1,
                        tmp = ARF(:,L*M+(1-M:0)) - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0)) = tmp;
                end;
                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0)) ;
                RCB(:,K*M+(1-M:0)) = ARB(:,K*M+(1-M:0)) ;
                
                PEF = PEF*[eye(M) - ARB(:,K*M+(1-M:0)) *ARF(:,K*M+(1-M:0)) ];
                PEB = PEB*[eye(M) - ARF(:,K*M+(1-M:0)) *ARB(:,K*M+(1-M:0)) ];
                PE(:,K*M+(1:M))  = PEF;        
        end;


elseif Mode==8,  %%%%% Least Squares
	ix  = Pmax+1:N;
	y   = repmat(NaN,N-Pmax,M*Pmax);
	for k = 1:Pmax,
		y(:,k*M+[1-M:0]) = Y(ix-k,:);
	end;
	ix2 = ~any(isnan([Y(ix,:),y]),2);	
	ARF = Y(ix(ix2),:)'/y(ix2,:)';
	PE  = covm(Y(ix,:) - y*ARF');
	RCF = zeros(M,M*Pmax);


elseif Mode==10,  %%%%% ARFIT
	try
		RCF = [];
		[w, ARF, PE] = arfit(Y, Pmax, Pmax, 'sbc', 'zero');
	catch
		ARF = zeros(M,M*Pmax); 
		RCF = ARF;
	end; 


elseif Mode==11,  %%%%% de Waele 2003
	%%% OBSOLETE 
	warning('MVAR: mode=11 is obsolete use Mode 13 or 14!'); 
	[pc,R0] = burgv(reshape(Y',[M,1,N]),Pmax);
        try,
                [ARF,ARB,Pf,Pb,RCF,RCB] = pc2parv(pc,R0);
        catch
                [RCF,RCB,Pf,Pb] = pc2rcv(pc,R0);
                [ARF,ARB,Pf,Pb] = pc2parv(pc,R0);
        end;
        ARF = -reshape(ARF(:,:,2:end),[M,M*Pmax]);
	RCF = -reshape(RCF(:,:,2:end),[M,M*Pmax]);
	PE = reshape(Pf,[M,M*(Pmax+1)]);


elseif Mode==12, 
	%%% OBSOLETE 
	warning('MVAR: mode=12 is obsolete use Mode 13 or 14!'); 
        % this is equivalent to Mode==11        
	[pc,R0] = burgv(reshape(Y',[M,1,N]),Pmax);
        [rcf,rcb,Pf,Pb] = pc2rcv(pc,R0);

        %%%%% Convert reflection coefficients RC to autoregressive parameters
        ARF = zeros(M,M*Pmax); 
        ARB = zeros(M,M*Pmax); 
        for K = 1:Pmax,
                ARF(:,K*M+(1-M:0)) = -rcf(:,:,K+1);	
                ARB(:,K*M+(1-M:0)) = -rcb(:,:,K+1);	
                for L = 1:K-1,
                        tmp                    = ARF(:,L*M+(1-M:0)) - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))     = tmp;
                end;
        end;        
        RCF = -reshape(rcf(:,:,2:end),[M,M*Pmax]);
	PE  = reshape(Pf,[M,M*(Pmax+1)]);


elseif Mode==13, 
        % this is equivalent to Mode==11 but can deal with missing values         
	%%%%%%%%%%% [pc,R0] = burgv_nan(reshape(Y',[M,1,N]),Pmax,1);
	% Copyright S. de Waele, March 2003 - modified Alois Schloegl, 2009
	I = eye(M);
	
	sz = [M,M,Pmax+1]; 
	pc= zeros(sz); pc(:,:,1) =I;
	K = zeros(sz); K(:,:,1)  =I;
	Kb= zeros(sz); Kb(:,:,1) =I;
	P = zeros(sz);
	Pb= zeros(sz);

	%[P(:,:,1)]= covm(Y);	
	[P(:,:,1)]= PE(:,1:M);	% normalized 
	Pb(:,:,1)= P(:,:,1);
	f = Y;
	b = Y;

	%the recursive algorithm
	for i = 1:Pmax,
		v = f(2:end,:);
		w = b(1:end-1,:);
   
		%%normalized, unbiased
		Rvv = covm(v); %Pfhat
		Rww = covm(w); %Pbhat
		Rvw = covm(v,w); %Pfbhat
		Rwv = covm(w,v); % = Rvw', written out for symmetry
		delta = lyap(Rvv*inv(P(:,:,i)),inv(Pb(:,:,i))*Rww,-2*Rvw);
   
		TsqrtS = chol( P(:,:,i))'; %square root M defined by: M=Tsqrt(M)*Tsqrt(M)'
		TsqrtSb= chol(Pb(:,:,i))'; 
		pc(:,:,i+1) = inv(TsqrtS)*delta*inv(TsqrtSb)';
   
		%The forward and backward reflection coefficient
		K(:,:,i+1) = -TsqrtS *pc(:,:,i+1) *inv(TsqrtSb);
		Kb(:,:,i+1)= -TsqrtSb*pc(:,:,i+1)'*inv(TsqrtS);
   
		%filtering the reflection coefficient out:
		f = (v'+ K(:,:,i+1)*w')';
		b = (w'+Kb(:,:,i+1)*v')';
   
		%The new R and Rb:
		%residual matrices
		P(:,:,i+1)  = (I-TsqrtS *pc(:,:,i+1) *pc(:,:,i+1)'*inv(TsqrtS ))*P(:,:,i); 
		Pb(:,:,i+1) = (I-TsqrtSb*pc(:,:,i+1)'*pc(:,:,i+1) *inv(TsqrtSb))*Pb(:,:,i); 
	end %for i = 1:Pmax,
	R0 = PE(:,1:M); 

        %%[rcf,rcb,Pf,Pb] = pc2rcv(pc,R0);
	rcf  = zeros(sz); rcf(:,:,1)  = I; 
	Pf   = zeros(sz); Pf(:,:,1)   = R0;
	rcb  = zeros(sz); rcb(:,:,1) = I; 
	Pb   = zeros(sz); Pb(:,:,1)  = R0;

	for p = 1:Pmax,
		TsqrtPf = chol( Pf(:,:,p))'; %square root M defined by: M=Tsqrt(M)*Tsqrt(M)'
		TsqrtPb= chol(Pb(:,:,p))'; 
		%reflection coefficients
		rcf(:,:,p+1) = -TsqrtPf *pc(:,:,p+1) *inv(TsqrtPb);
		rcb(:,:,p+1)= -TsqrtPb*pc(:,:,p+1)'*inv(TsqrtPf );
		%residual matrices
		Pf(:,:,p+1)  = (I-TsqrtPf *pc(:,:,p+1) *pc(:,:,p+1)'*inv(TsqrtPf ))*Pf(:,:,p); 
		Pb(:,:,p+1) = (I-TsqrtPb*pc(:,:,p+1)'*pc(:,:,p+1) *inv(TsqrtPb))*Pb(:,:,p); 
	end %for p = 2:order,
	%%%%%%%%%%%%%% end %%%%%%


        %%%%% Convert reflection coefficients RC to autoregressive parameters
        ARF = zeros(M,M*Pmax); 
        ARB = zeros(M,M*Pmax); 
        for K = 1:Pmax,
                ARF(:,K*M+(1-M:0)) = -rcf(:,:,K+1);
                ARB(:,K*M+(1-M:0)) = -rcb(:,:,K+1);
                for L = 1:K-1,
                        tmp                    = ARF(:,L*M+(1-M:0)) - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))     = tmp;
                end;
        end;
        RCF = -reshape(rcf(:,:,2:end),[M,M*Pmax]);
	PE  = reshape(Pf,[M,M*(Pmax+1)]);


elseif Mode==14,
        % this is equivalent to Mode==11 but can deal with missing values
	%%%%%%%%%%%%%% [pc,R0] = burgv_nan(reshape(Y',[M,1,N]),Pmax,2);
	% Copyright S. de Waele, March 2003 - modified Alois Schloegl, 2009
	I = eye(M);
	
	sz = [M,M,Pmax+1]; 
	pc= zeros(sz); pc(:,:,1) =I;
	K = zeros(sz); K(:,:,1)  =I;
	Kb= zeros(sz); Kb(:,:,1) =I;
	P = zeros(sz);
	Pb= zeros(sz);

	%[P(:,:,1),nn]= covm(Y);
	[P(:,:,1)]= C(:,1:M);	%% no normalization 
	Pb(:,:,1)= P(:,:,1);
	f = Y;
	b = Y;

	%the recursive algorithm
	for i = 1:Pmax,
		v = f(2:end,:);
		w = b(1:end-1,:);

		%%no normalization 
		[Rvv,nn] = covm(v); %Pfhat
		[Rww,nn] = covm(w); %Pbhat
		[Rvw,nn] = covm(v,w); %Pfbhat
		[Rwv,nn] = covm(w,v); % = Rvw', written out for symmetry
		delta = lyap(Rvv*inv(P(:,:,i)),inv(Pb(:,:,i))*Rww,-2*Rvw);

		TsqrtS = chol( P(:,:,i))'; %square root M defined by: M=Tsqrt(M)*Tsqrt(M)'
		TsqrtSb= chol(Pb(:,:,i))'; 
		pc(:,:,i+1) = inv(TsqrtS)*delta*inv(TsqrtSb)';

		%The forward and backward reflection coefficient
		K(:,:,i+1) = -TsqrtS *pc(:,:,i+1) *inv(TsqrtSb);
		Kb(:,:,i+1)= -TsqrtSb*pc(:,:,i+1)'*inv(TsqrtS);

		%filtering the reflection coefficient out:
		f = (v'+ K(:,:,i+1)*w')';
		b = (w'+Kb(:,:,i+1)*v')';

		%The new R and Rb:
		%residual matrices
		P(:,:,i+1)  = (I-TsqrtS *pc(:,:,i+1) *pc(:,:,i+1)'*inv(TsqrtS ))*P(:,:,i); 
		Pb(:,:,i+1) = (I-TsqrtSb*pc(:,:,i+1)'*pc(:,:,i+1) *inv(TsqrtSb))*Pb(:,:,i); 
	end %for i = 1:Pmax,
	R0 = PE(:,1:M); 

        %%%%%%%%%% [rcf,rcb,Pf,Pb] = pc2rcv(pc,R0);
	sz = [M,M,Pmax+1]; 
	rcf  = zeros(sz); rcf(:,:,1)  = I; 
	Pf   = zeros(sz); Pf(:,:,1)   = R0;
	rcb  = zeros(sz); rcb(:,:,1) = I; 
	Pb   = zeros(sz); Pb(:,:,1)  = R0;
	for p = 1:Pmax,
		TsqrtPf = chol( Pf(:,:,p))'; %square root M defined by: M=Tsqrt(M)*Tsqrt(M)'
		TsqrtPb = chol(Pb(:,:,p))'; 
		%reflection coefficients
		rcf(:,:,p+1)= -TsqrtPf *pc(:,:,p+1) *inv(TsqrtPb);	
		rcb(:,:,p+1)= -TsqrtPb *pc(:,:,p+1)'*inv(TsqrtPf );   
		%residual matrices
		Pf(:,:,p+1) = (I-TsqrtPf *pc(:,:,p+1) *pc(:,:,p+1)'*inv(TsqrtPf))*Pf(:,:,p); 
		Pb(:,:,p+1) = (I-TsqrtPb *pc(:,:,p+1)'*pc(:,:,p+1) *inv(TsqrtPb))*Pb(:,:,p); 
	end %for p = 2:order,
	%%%%%%%%%%%%%% end %%%%%%

        %%%%% Convert reflection coefficients RC to autoregressive parameters
        ARF = zeros(M,M*Pmax); 
        ARB = zeros(M,M*Pmax); 
        for K = 1:Pmax,
                ARF(:,K*M+(1-M:0)) = -rcf(:,:,K+1);	
                ARB(:,K*M+(1-M:0)) = -rcb(:,:,K+1);	
                for L = 1:K-1,
                        tmp                    = ARF(:,L*M+(1-M:0)) - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))     = tmp;
                end;
        end;        
        RCF = -reshape(rcf(:,:,2:end),[M,M*Pmax]);
	PE  = reshape(Pf,[M,M*(Pmax+1)]);


elseif Mode==15,  %%%%% Least Squares
	%%FIXME
        for K=1:Pmax,
                [C(:,K*M+(1:M)),n] = covm(Y(K+1:N,:),Y(1:N-K,:),'M');
%                C(K*M+(1:M),:) = C(K*M+(1:M),:)/N;
	end; 
	ARF = C(:,1:M)'/C(:,M+1:end)';
	PE  = covm(C(:,1:M)' - ARF * C(:,M+1:end)');
	RCF = zeros(M, M*Pmax);


elseif 0, 
	%%%%% ARFIT and handling missing values 
	% compute QR factorization for model of order pmax
	[R, scale]   = arqr(Y, Pmax, 0);
	 % select order of model
  	popt         = Pmax; % estimated optimum order 
  	np           = M*Pmax; % number of parameter vectors of length m
  	% decompose R for the optimal model order popt according to 
  	%
  	%   | R11  R12 |
  	% R=|          |
  	%   | 0    R22 |
  	%
  	R11   = R(1:np, 1:np);
  	R12   = R(1:np, Pmax+1:Pmax+M);    
  	R22   = R(M*Pmax+1:Pmax+M, Pmax+1:Pmax+M);
	A     = (R11\R12)';
  	% return covariance matrix
  	dof   = N-Pmax-M*Pmax;                % number of block degrees of freedom
  	PE    = R22'*R22./dof;        % bias-corrected estimate of covariance matrix

	try
		RCF = [];
		[w, ARF, PE] = arfit(Y, Pmax, Pmax, 'sbc', 'zero');
	catch
		ARF = zeros(M,M*Pmax); 
		RCF = ARF;
	end; 


elseif Mode==22 %%%%% Modified Partial Correlation Estimation: Vieira-Morf [2,5] using unbiased covariance estimates.
        %--------Initialization----------
        F = Y;
        B = Y;
        [PEF, n] = covm(Y(2:N,:),'M');
        PEF = PEF./n;
        [PEB, n] = covm(Y(1:N-1,:),'M');
        PEB = PEB./n;
        %---------------------------------
        for K = 1:Pmax,
            %---Update the estimated error covariances(15.89) in [2]---
            [PEFhat,n] = covm(F(K+1:N,:),'M');
            PEFhat = PEFhat./n;
                
            [PEBhat,n] = covm(B(1:N-K,:),'M');
            PEBhat = PEBhat./n;
        
            [PEFBhat,n] = covm(F(K+1:N,:),B(1:N-K,:),'M');
            PEFBhat = PEFBhat./n;
            
            %---Compute estimated normalized partial correlation matrix(15.88)in [2]---
            Rho = inv(chol(PEFhat)')*PEFBhat*inv(chol(PEBhat));
            
            %---Update forward and backward reflection coefficients (15.82) and (15.83) in [2]---
            ARF(:,K*M+(1-M:0)) = chol(PEF)'*Rho*inv(chol(PEB)');
            ARB(:,K*M+(1-M:0)) = chol(PEB)'*Rho'*inv(chol(PEF)');
            
            %---------------------------------
            tmp        = F(K+1:N,:) - B(1:N-K,:)*ARF(:,K*M+(1-M:0)).';
            B(1:N-K,:) = B(1:N-K,:) - F(K+1:N,:)*ARB(:,K*M+(1-M:0)).';
            F(K+1:N,:) = tmp;

            for L = 1:K-1,
                    tmp      = ARF(:,L*M+(1-M:0))   - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                    ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                    ARF(:,L*M+(1-M:0))   = tmp;
            end;

            RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
            RCB(:,K*M+(1-M:0)) = ARB(:,K*M+(1-M:0));
            
            %---Update forward and backward error covariances (15.75) and (15.76) in [2]---
            PEF = (eye(M)-ARF(:,K*M+(1-M:0))*ARB(:,K*M+(1-M:0)))*PEF;
            PEB = (eye(M)-ARB(:,K*M+(1-M:0))*ARF(:,K*M+(1-M:0)))*PEB;
            
            PE(:,K*M+(1:M)) = PEF;
        end
        

elseif Mode==25 %%%%Modified Partial Correlation Estimation: Vieira-Morf [2,5] using biased covariance estimates.
        %--------Initialization----------
        F = Y;
        B = Y;
        [PEF, n] = covm(Y(2:N,:),'M');
        PEF = PEF./N;
        [PEB, n] = covm(Y(1:N-1,:),'M');
        PEB = PEB./N;
        %---------------------------------
        for K = 1:Pmax,
            %---Update the estimated error covariances(15.89) in [2]---
            [PEFhat,n] = covm(F(K+1:N,:),'M');
            PEFhat = PEFhat./N;
                
            [PEBhat,n] = covm(B(1:N-K,:),'M');
            PEBhat = PEBhat./N;
        
            [PEFBhat,n] = covm(F(K+1:N,:),B(1:N-K,:),'M');
            PEFBhat = PEFBhat./N;
            
            %---Compute estimated normalized partial correlation matrix(15.88)in [2]---
            Rho = inv(chol(PEFhat)')*PEFBhat*inv(chol(PEBhat));
            
            %---Update forward and backward reflection coefficients (15.82) and (15.83) in [2]---
            ARF(:,K*M+(1-M:0)) = chol(PEF)'*Rho*inv(chol(PEB)');
            ARB(:,K*M+(1-M:0)) = chol(PEB)'*Rho'*inv(chol(PEF)');
            
            %---------------------------------
            tmp        = F(K+1:N,:) - B(1:N-K,:)*ARF(:,K*M+(1-M:0)).';
            B(1:N-K,:) = B(1:N-K,:) - F(K+1:N,:)*ARB(:,K*M+(1-M:0)).';
            F(K+1:N,:) = tmp;

            for L = 1:K-1,
                    tmp      = ARF(:,L*M+(1-M:0))   - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                    ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                    ARF(:,L*M+(1-M:0))   = tmp;
            end;

            RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
            RCB(:,K*M+(1-M:0)) = ARB(:,K*M+(1-M:0));
            
            %---Update forward and backward error covariances (15.75) and (15.76) in [2]---
            PEF = (eye(M)-ARF(:,K*M+(1-M:0))*ARB(:,K*M+(1-M:0)))*PEF;
            PEB = (eye(M)-ARB(:,K*M+(1-M:0))*ARF(:,K*M+(1-M:0)))*PEB;
            
            PE(:,K*M+(1:M)) = PEF;
        end



        
%%%%% EXPERIMENTAL VERSIONS %%%%%

elseif Mode==90;  
	% similar to MODE=0
	%%not recommended
        C(:,1:M) = C(:,1:M)/N;
        F = Y;
        B = Y;
        PEF = PE(:,1:M);	%CHANGED%
        PEB = PE(:,1:M);	%CHANGED%
        for K=1:Pmax,
                [D,n] = covm(Y(K+1:N,:),Y(1:N-K,:),'M');
	        D = D/N;
                ARF(:,K*M+(1-M:0)) = D/PEB;
                ARB(:,K*M+(1-M:0)) = D'/PEF;

                tmp        = F(K+1:N,:) - B(1:N-K,:)*ARF(:,K*M+(1-M:0))';
                B(1:N-K,:) = B(1:N-K,:) - F(K+1:N,:)*ARB(:,K*M+(1-M:0))';
                F(K+1:N,:) = tmp;

                for L = 1:K-1,
                        tmp      = ARF(:,L*M+(1-M:0))   - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))   = tmp;
                end;

                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
                RCB(:,K*M+(1-M:0)) = ARB(:,K*M+(1-M:0));

                PEF = [eye(M) - ARF(:,K*M+(1-M:0))*ARB(:,K*M+(1-M:0))]*PEF;
                PEB = [eye(M) - ARB(:,K*M+(1-M:0))*ARF(:,K*M+(1-M:0))]*PEB;
                PE(:,K*M+(1:M)) = PEF;        
        end;

        
elseif Mode==91, %%%%% Levinson-Wiggens-Robinson (LWR) algorithm using biased correlation function
	% ===== In [1,2] this algorithm is denoted 'Multichannel Yule-Walker' ===== %
	% similar to MODE=1
	%%not recommended
        C(:,1:M) = C(:,1:M)/N;
        PEF = PE(:,1:M);	%CHANGED%
        PEB = PE(:,1:M);	%CHANGED%

        for K=1:Pmax,
                [C(:,K*M+(1:M)),n] = covm(Y(K+1:N,:),Y(1:N-K,:),'M');
                C(:,K*M+(1:M)) = C(:,K*M+(1:M))/N;

                D = C(:,K*M+(1:M));
                for L = 1:K-1,
                        D = D - ARF(:,L*M+(1-M:0))*C(:,(K-L)*M+(1:M));
                end;
                ARF(:,K*M+(1-M:0)) = D / PEB;	
                ARB(:,K*M+(1-M:0)) = D'/ PEF;	
                for L = 1:K-1,
                        tmp                    = ARF(:,L*M+(1-M:0)) - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))     = tmp;
                end;

                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
                RCB(:,K*M+(1-M:0)) = ARB(:,K*M+(1-M:0));

                PEF = [eye(M) - ARF(:,K*M+(1-M:0))*ARB(:,K*M+(1-M:0))]*PEF;
                PEB = [eye(M) - ARB(:,K*M+(1-M:0))*ARF(:,K*M+(1-M:0))]*PEB;
                PE(:,K*M+(1:M)) = PEF;
        end;


elseif Mode==96, %%%%% Levinson-Wiggens-Robinson (LWR) algorithm using unbiased correlation function
	% similar to MODE=6
	%%not recommended
        C(:,1:M) = C(:,1:M)/N;
        PEF = PE(:,1:M);	%CHANGED%
        PEB = PE(:,1:M);	%CHANGED%

        for K = 1:Pmax,
                [C(:,K*M+(1:M)),n] = covm(Y(K+1:N,:),Y(1:N-K,:),'M');
                C(:,K*M+(1:M)) = C(:,K*M+(1:M))./n;

                D = C(:,K*M+(1:M));
                for L = 1:K-1,
                        D = D - ARF(:,L*M+(1-M:0))*C(:,(K-L)*M+(1:M));
                end;
                ARF(:,K*M+(1-M:0)) = D / PEB;	
                ARB(:,K*M+(1-M:0)) = D'/ PEF;	
                for L = 1:K-1,
                        tmp      = ARF(:,L*M+(1-M:0))   - ARF(:,K*M+(1-M:0))*ARB(:,(K-L)*M+(1-M:0));
                        ARB(:,(K-L)*M+(1-M:0)) = ARB(:,(K-L)*M+(1-M:0)) - ARB(:,K*M+(1-M:0))*ARF(:,L*M+(1-M:0));
                        ARF(:,L*M+(1-M:0))   = tmp;
                end;

                RCF(:,K*M+(1-M:0)) = ARF(:,K*M+(1-M:0));
                RCB(:,K*M+(1-M:0)) = ARB(:,K*M+(1-M:0));

                PEF = [eye(M) - ARF(:,K*M+(1-M:0))*ARB(:,K*M+(1-M:0))]*PEF;
                PEB = [eye(M) - ARB(:,K*M+(1-M:0))*ARF(:,K*M+(1-M:0))]*PEB;
                PE(:,K*M+(1:M)) = PEF;
        end;

elseif Mode<100,
       fprintf('Warning MVAR: Mode=%i not supported\n',Mode);

%%%%% IMPUTATION METHODS %%%%%
else

	Mode0 = rem(Mode,100); 	
	if ((Mode0 >= 10) && (Mode0 < 20)), 
		Mode0 = 1; 
	end;

if 0, 


elseif Mode>=2400,  % forward and backward
% assuming that past missing values are already IMPUTED with the prediction value + innovation process
% no decaying 

 	[ARF,RCF,PE2] = mvar(Y, Pmax, Mode0);	
 	c = chol( PE2 (:, M*Pmax+(1:M)));

	Y1 = Y; 
	Y1(1,isnan(Y1(1,:))) = 0; 
	z  = [];
	for k = 2:size(Y,1)
		[z1,z] = mvfilter(ARF,eye(M),Y1(k-1,:)',z);
		ix = isnan(Y1(k,:)); 
		z1 = z1 + (randn(1,M)*c)'; 
		Y1(k,ix) = z1(ix); 
	end; 

	Y2 = flipud(Y); 
 	[ARB,RCF,PE] = mvar(Y2, Pmax, Mode0);	
	Y2(1,isnan(Y2(1,:))) = 0; 
	z  = [];
	for k = 2:size(Y2,1)
		[z2,z] = mvfilter(ARB,eye(M),Y2(k-1,:)',z);
		ix = isnan(Y(size(Y,1)-k+1,:)); 
		z2 = z2 + (randn(1,M)*c)'; 
		Y2(k,ix) = (z2(ix)' + Y2(k,ix))/2; 
	end; 
	Y2 = flipud(Y2); 
	
	Z = (Y2+Y1)/2;
	Y(isnan(Y)) = Z(isnan(Y));
	
 	[ARF,RCF,PE] = mvar(Y, Pmax, rem(Mode,100));	


elseif Mode>=2300,  % backward prediction
% assuming that past missing values are already IMPUTED with the prediction value + innovation process
% no decaying 

	Y  = flipud(Y);
 	[ARB,RCF,PE] = mvar(Y, Pmax, Mode0);	
 	c = chol(PE(:,M*Pmax+(1:M))); 
	Y1 = Y; 
	Y1(1,isnan(Y1(1,:))) = 0; 
	z  = [];
	for k = 2:size(Y,1)
		[z1,z] = mvfilter(ARB,eye(M),Y1(k-1,:)',z);
		ix = isnan(Y1(k,:)); 
		z1 = z1 + (randn(1,M)*c)'; 
		Y1(k,ix) = z1(ix); 
	end; 	
	Y1 = flipud(Y1);
 	[ARF,RCF,PE] = mvar(Y1, Pmax, rem(Mode,100));	


elseif Mode>=2200,  % forward predictions, 
% assuming that past missing values are already IMPUTED with the prediction value + innovation process
% no decaying 
 	[ARF,RCF,PE] = mvar(Y, Pmax, Mode0);	
 	c = chol(PE(:,M*Pmax+(1:M))); 
	Y1 = Y; 
	Y1(1,isnan(Y1(1,:))) = 0; 
	z  = [];
	for k = 2:size(Y,1)
		[z1,z] = mvfilter(ARF,eye(M),Y1(k-1,:)',z);
		ix = isnan(Y1(k,:)); 
		z1 = z1 + (randn(1,M)*c)'; 
		Y1(k,ix) = z1(ix); 
	end; 	
 	[ARF,RCF,PE] = mvar(Y1, Pmax, rem(Mode,100));	


elseif Mode>=1400,  % forward and backward
%assuming that past missing values are already IMPUTED with the prediction value
 	[ARF,RCF,PE] = mvar(Y, Pmax, Mode0);	
	Y1 = Y; 
	Y1(1,isnan(Y1(1,:))) = 0; 
	z  = [];
	for k = 2:size(Y,1)
		[z1,z] = mvfilter(ARF,eye(M),Y1(k-1,:)',z);
		ix = isnan(Y1(k,:)); 
		Y1(k,ix) = z1(ix); 
	end; 

	Y2 = flipud(Y); 
 	[ARB,RCF,PE] = mvar(Y2, Pmax, Mode0);	
	Y2(1,isnan(Y2(1,:))) = 0; 
	z  = [];
	for k = 2:size(Y2,1)
		[z2,z] = mvfilter(ARB,eye(M),Y2(k-1,:)',z);
		ix = isnan(Y2(k,:)); 
		Y2(k,ix) = z2(ix)'; 
	end; 
	Y2 = flipud(Y2); 
	
	Z = (Y2+Y1)/2;
	Y(isnan(Y)) = Z(isnan(Y));
	
 	[ARF,RCF,PE] = mvar(Y, Pmax, rem(Mode,100));	


elseif Mode>=1300,  % backward prediction
	Y  = flipud(Y);
 	[ARB,RCF,PE] = mvar(Y, Pmax, Mode0);	
	Y2 = Y; 
	Y2(1,isnan(Y2(1,:))) = 0; 
	z  = [];
	for k = 2:size(Y,1)
		[z2,z] = mvfilter(ARB,eye(M),Y2(k-1,:)',z);
		ix = isnan(Y2(k,:)); 
		Y2(k,ix) = z2(ix); 
	end; 	
	Y2 = flipud(Y2);
 	[ARF,RCF,PE] = mvar(Y2, Pmax, rem(Mode,100));	


elseif Mode>=1200,  % forward predictions, 
%assuming that past missing values are already IMPUTED with the prediction value
 	[ARF,RCF,PE] = mvar(Y, Pmax, Mode0);	
	Y1 = Y; 
	Y1(1,isnan(Y1(1,:))) = 0; 
	z  = [];
	for k = 2:size(Y,1)
		[z1,z] = mvfilter(ARF,eye(M),Y1(k-1,:)',z);
		ix = isnan(Y1(k,:)); 
		Y1(k,ix) = z1(ix); 
	end; 	
 	[ARF,RCF,PE] = mvar(Y1, Pmax, rem(Mode,100));	


elseif Mode>=400,  % forward and backward
% assuming that 'past' missing values are ZERO
 	[ARF,RCF,PE] = mvar(Y, Pmax, Mode0);	
	Y1 = Y; 
	Y1(isnan(Y)) = 0; 
	Z1 = mvfilter([zeros(M),ARF],eye(M),Y1')';
	Y1(isnan(Y)) = Z1(isnan(Y));

	Y  = flipud(Y);
 	[ARB,RCF,PE] = mvar(Y, Pmax, Mode0);	
	Y2 = Y; 
	Y2(isnan(Y)) = 0; 
	Z2 = mvfilter([zeros(M),ARB],eye(M),Y2')';
	Y2(isnan(Y)) = Z2(isnan(Y));
	Y2 = flipud(Y2);

 	[ARF,RCF,PE] = mvar((Y1+Y2)/2, Pmax, rem(Mode,100));	


elseif Mode>=300,  % backward prediction
% assuming that 'past' missing values are ZERO
	Y  = flipud(Y);
 	[ARB,RCF,PE] = mvar(Y, Pmax, Mode0);	
	Y2 = Y; 
	Y2(isnan(Y)) = 0; 
	Z2 = mvfilter([zeros(M),ARB],eye(M),Y2')';
	Y2(isnan(Y)) = Z2(isnan(Y));
	Y2 = flipud(Y2);

 	[ARF,RCF,PE] = mvar(Y2, Pmax, rem(Mode,100));	


elseif Mode>=200,  
% forward predictions, assuming that past missing values are ZERO
 	[ARF,RCF,PE] = mvar(Y, Pmax, Mode0);	
	Y1 = Y; 
	Y1(isnan(Y)) = 0; 
	Z1 = mvfilter([zeros(M),ARF],eye(M),Y1')';
	Y1(isnan(Y)) = Z1(isnan(Y));

 	[ARF,RCF,PE] = mvar(Y1, Pmax, rem(Mode,100));	


elseif Mode>=100,  
 	[ARF,RCF,PE] = mvar(Y, Pmax, Mode0);	
	Z1 = mvfilter(ARF,eye(M),Y')';
	Z1 = [zeros(1,M); Z1(1:end-1,:)];
	Y(isnan(Y)) = Z1(isnan(Y)); 
 	[ARF,RCF,PE] = mvar(Y, Pmax, rem(Mode,100));	


end;
end;


if any(ARF(:)==inf),
% Test for matrix division bug. 
% This bug was observed in LNX86-ML5.3, 6.1 and 6.5, but not in SGI-ML6.5, LNX86-ML6.5, Octave 2.1.35-40; Other platforms unknown.
p = 3;
FLAG_MATRIX_DIVISION_ERROR = ~all(all(isnan(repmat(0,p)/repmat(0,p)))) | ~all(all(isnan(repmat(nan,p)/repmat(nan,p))));

if FLAG_MATRIX_DIVISION_ERROR, 
	%fprintf(2,'%%% Warning MVAR: Bug in Matrix-Division 0/0 and NaN/NaN yields INF instead of NAN.  Workaround is applied.\n');
	warning('MVAR: bug in Matrix-Division 0/0 and NaN/NaN yields INF instead of NAN.  Workaround is applied.');

	%%%%% Workaround 
	ARF(ARF==inf)=NaN;
	RCF(RCF==inf)=NaN;
end;
end;	

%MAR   = zeros(M,M*Pmax);
DC     = zeros(M);
for K  = 1:Pmax,
%       VAR{K+1} = -ARF(:,K*M+(1-M:0))';
        DC  = DC + ARF(:,K*M+(1-M:0))'.^2; %DC meausure [3]
end;
