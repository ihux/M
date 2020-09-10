function h0=guiAnimate(SETUP);

bcolor = SETUP.Colors.Background;

h0=figure('Color'           , bcolor, ...
   'MenuBar'                , 'none', ...
   'NumberTitle'            , 'off', ...
   'Name'                   , 'Modal Vector Animation', ...
   'Position'               , [4,32,800,600], ...
   'Resize'                 , 'on',...
   'ResizeFcn'              , 'command(''resize'');',...
   'Visible'                , 'on',...
   'Tag'                    , 'ANIMATE',...
   'Renderer'               , SETUP.Display.Renderer,...
   'DoubleBuffer'           , 'on',...
   'CloseRequestFcn'        , ['command(''close'',''main'');']);
% set(h0,'Visible','on');

viewStr = {'X','Y','Z','Ortho'};
viewVal = ismember(viewStr,SETUP.View.Axis);
addMenus(h0,SETUP,viewVal);
[iconZoom,iconAnimate,iconRotate]=loadIcons(SETUP);

% Contextmenu
cm=uicontextmenu('Parent',h0    ,'Tag','ContextMenu\Axes');
h(1)=uimenu(cm,'Label','&X'     ,'Tag','ContextMenu\Axes\X');
h(2)=uimenu(cm,'Label','&Y'     ,'Tag','ContextMenu\Axes\Y');
h(3)=uimenu(cm,'Label','&Z'     ,'Tag','ContextMenu\Axes\Z');
h(4)=uimenu(cm,'Label','&Ortho' ,'Tag','ContextMenu\Axes\Ortho','Separator','off');
str ={'off','on'};
set(h(1),'Callback','command(''changeView'',''X'');','Checked',str{viewVal(1)+1});
set(h(2),'Callback','command(''changeView'',''Y'');','Checked',str{viewVal(2)+1});
set(h(3),'Callback','command(''changeView'',''Z'');','Checked',str{viewVal(3)+1});
set(h(4),'Callback','command(''changeView'',''Ortho'');','Checked',str{viewVal(4)+1});
set(h0,    'UIcontextmenu'         ,cm)
% Controls Frame
framePos    = [0 560 642 62];
h1=uicontrol('Parent',h0,...
   'Style'                  , 'Frame',...
   'Tag'                    , 'Frame:Controls',...
   'BackgroundColor'        , [1 1 1]*.8,...
   'Position'               , framePos);

% ANIMATE Toggle
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Toggle',...
   'Backgroundcolor'        , [1 1 1]*.8,...
   'Foregroundcolor'        , [1 1 1]*0,...
   'Value'                  , 0,...
   'CData'                  , iconAnimate,...
   'Position'               , [5 framePos(2)+5,25 25],...
   'Callback'               , 'command(''run_animate'')',...
   'Tag'                    , 'Toggle:Animate',...
   'ToolTipString'          , 'Animation',...
   'Enable'                 , 'off');
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Toggle',...
   'Backgroundcolor'        , [1 1 1]*.8,...
   'Foregroundcolor'        , [1 1 1]*0,...
   'Value'                  , 0,...
   'CData'                  , iconZoom,...
   'Position'               , [35 framePos(2)+5 25 25],...
   'Callback'               , 'command(''zoom'',gcbo);',...
   'Tag'                    , 'Toggle:Zoom',...
   'ToolTipString'          , 'Pan & Zoom',...
   'Enable'                 , 'off');
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Toggle',...
   'Backgroundcolor'        , [1 1 1]*.8,...
   'Foregroundcolor'        , [1 1 1]*0,...
   'Value'                  , 0,...
   'CData'                  , iconRotate,...
   'Position'               , [65 framePos(2)+5 25 25],...
   'Callback'               , 'command(''rotate'',gcbo);',...
   'Tag'                    , 'Toggle:Rotate',...
   'ToolTipString'          , 'Rotate',...
   'Enable'                 , 'off');

% Mode Text/Popup
h1=uicontrol('Parent',h0,...
   'Units'                  ,'pixels',...
   'Style'                  ,'Text',...
   'Position'               ,[105 framePos(2)+20 115 20],...
   'HorizontalAlignment'    ,'center',...
   'Backgroundcolor'        ,[1 1 1]*0.8,...
   'String'                 ,'Mode List');
h1=uicontrol('Parent',h0,...
   'Units'                  ,'pixels',...
   'Style'                  ,'Popup',...
   'Backgroundcolor'        ,[1 1 1]*1,...
   'Foregroundcolor'        ,[1 1 1]*0,...
   'Value'                  ,1,...
   'Position'               ,[105 framePos(2)+5 115 20],...
   'String'                 ,' ',...
   'Callback'               ,'command(''update_mode'');',...
   'Tag'                    ,'popup_modeList');

% Frames Text/Edit/Slider
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Text',...
   'Position'               , [230 framePos(2)+25 40 15],...
   'HorizontalAlignment'    , 'center',...
   'Backgroundcolor'        , [1 1 1]*0.8,...
   'String'                 , 'FPC');
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Edit',...
   'Backgroundcolor'        , [1 1 1]*1,...
   'Foregroundcolor'        , [1 1 1]*0,...
   'Value'                  , 1,...
   'Position'               , [230 framePos(2)+8 40 20],...
   'String'                 , num2str(SETUP.Animation.Frames),...
   'Callback'               , 'command(''set'',''FPC'',''edit'');',...
   'Tag'                    , 'Edit:FPC');
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Slider',...
   'Backgroundcolor'        , [1 1 1]*1,...
   'Foregroundcolor'        , [1 1 1]*0,...
   'Value'                  , SETUP.Animation.Frames,...
   'Min'                    , 3,...
   'Max'                    , 503,...
   'SliderStep'             , [.01 .1],...
   'Position'               , [270 framePos(2)+3 18 30],...
   'Callback'               , 'command(''set'',''FPC'',''slider'');',...
   'Tag'                    , 'Slider:FPC');

% Amplitude Text/Edit/Slider
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Text',...
   'Position'               , [290 framePos(2)+25 40 15],...
   'HorizontalAlignment'    , 'center',...
   'Backgroundcolor'        , [1 1 1]*0.8,...
   'String'                 , 'Amp');
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Edit',...
   'Backgroundcolor'        , [1 1 1]*1,...
   'Foregroundcolor'        , [1 1 1]*0,...
   'Value'                  , 1,...
   'Position'               , [290 framePos(2)+8 40 20],...
   'String'                 , num2str(SETUP.Animation.Amplitude),...
   'Callback'               , 'command(''set'',''amp'',''edit'');',...
   'Tag'                    , 'Edit:Amp');
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Slider',...
   'Backgroundcolor'        , [1 1 1]*1,...
   'Foregroundcolor'        , [1 1 1]*0,...
   'Value'                  , SETUP.Animation.Amplitude,...
   'Min'                    , .01,...
   'Max'                    , 100.01,...
   'SliderStep'             , [.01 .1],...
   'Position'               , [330 framePos(2)+3 18 30],...
   'Callback'               , 'command(''set'',''amp'',''slider'');',...
   'Tag'                    , 'Slider:Amp');

% Amplitude Text/Edit/Slider
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Text',...
   'Position'               , [350 framePos(2)+25 40 15],...
   'HorizontalAlignment'    , 'center',...
   'Backgroundcolor'        , [1 1 1]*0.8,...
   'String'                 , 'Deg.');
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Edit',...
   'Backgroundcolor'        , [1 1 1]*1,...
   'Foregroundcolor'        , [1 1 1]*0,...
   'Value'                  , 1,...
   'Position'               , [350 framePos(2)+8 40 20],...
   'String'                 , num2str(round(SETUP.Animation.Theta)),...
   'Callback'               , 'command(''set'',''deg'',''edit'');',...
   'Tag'                    , 'Edit:Deg');
h1=uicontrol('Parent',h0,...
   'Units'                  , 'pixels',...
   'Style'                  , 'Slider',...
   'Backgroundcolor'        , [1 1 1]*1,...
   'Foregroundcolor'        , [1 1 1]*0,...
   'Value'                  , round(SETUP.Animation.Theta),...
   'Min'                    ,-360,...
   'Max'                    , 360,...
   'SliderStep'             , [0.00694444444444444 0.00694444444444444*2],...
   'Position'               , [390 framePos(2)+3 18 30],...
   'Callback'               , 'command(''set'',''deg'',''slider'');',...
   'Tag'                    , 'Slider:Deg');

% Annotate Text box
str={'off','on'};
h1=uicontrol('Parent',h0,...
   'Units'                  ,'pixels',...
   'Style'                  ,'Text',...
   'Backgroundcolor'        ,bcolor,...
   'Foregroundcolor'        ,[1 1 1]*0,...
   'HorizontalAlignment'    ,'left',...
   'Max'                    ,2,...
   'Visible'                ,str{SETUP.Display.Annotate+1},...
   'Position'               ,[10 520 250 40],...
   'Fontsize'               ,7,...
   'Fontname'               ,'Arial',...
   'String'                 ,' ',...
   'Tag'                    ,'Text:Annotate');



% Axes
str     = {'+X','+Y','+Z'};
vector  = eye(3);
val     = find(ismember(str,SETUP.View.UpVector));
% MATLAB evolution: 2017-04-04
% 'DrawMode'              , 'fast',...
% was replaced by 
%     'SortMethod'            , 'depth',...

h1=axes('Parent',h0,...
    'Units'                 , 'pixels',...
    'CameraUpVector'        , [0 1 0], ...
    'Position'              , [20 20 760 465],...
    'Color'                 , bcolor,...
    'Clipping'              , 'On',...
    'SortMethod'            , 'depth',...
    'XTickLabelMode'        , 'manual',...
    'XTickMode'             , 'manual',...
    'XTickLabel'            , '',...
    'YTickLabelMode'        , 'manual',...
    'YTickMode'             , 'manual',...
    'YTickLabel'            , '',...
    'ZTickLabelMode'        , 'manual',...
    'ZTickMode'             , 'manual',...
    'ZTickLabel'            , '',...
    'Tag'                   , 'Axes:Single',...
    'Xcolor'                , bcolor,...
    'Ycolor'                , bcolor,...
    'Zcolor'                , bcolor,...
    'UIcontextmenu'         , cm,...
    'Visible'               , 'off');
view([135 35]);
set(h1,'CameraUpVector',vector(val,:));

function addMenus(uiFig,SETUP,viewVal)
h1 = uimenu('Parent',uiFig, ...
	'Label','&File', ...
	'Tag','file');

%Load sublist
h2 = uimenu('Parent', h1, ...
	'Label'         , 'Load', ...
	'Separator'     , 'on');
h3 = uimenu('Parent', h2, ...
	'Callback'      , 'command(''Load'',''Matlab'');', ...
	'Label'         , '&Matlab');
h3 = uimenu('Parent', h2, ...
	'Callback'      , 'command(''Load'',''UFF'');', ...
	'Label'         , '&Universal File');

%Save sublist
h2 = uimenu('Parent', h1, ...
	'Label'         , 'Save', ...
	'Separator'     , 'off', ...
    'Tag'           , 'Menu:File:Save',...
    'Enable'        , 'off');
h3 = uimenu('Parent', h2, ...
	'Callback'      , 'command(''Save'',''Matlab'');', ...
	'Label'         , '&Matlab');
h3 = uimenu('Parent', h2, ...
	'Callback'      , 'command(''Save'',''UFF'');', ...
	'Label'         , '&Universal File');
h3 = uimenu('Parent', h2, ...
	'Callback'      , 'command(''Save'',''Snapshot'');', ...
	'Label'         , '&Snapshot',...
    'Tag'           , 'Menu:File:Snapshot');
h3 = uimenu('Parent', h2, ...
	'Callback'      , 'command(''Save'',''AVI'');', ...
	'Label'         , '&AVI Movie',...
    'Tag'           , 'Menu:File:Avi');

h2 = uimenu('Parent'    , h1, ...
    'Separator'         , 'on',...
	'Label'             , 'Preferences', ...
    'Callback'          , 'command(''preferences'',''init'');');

str ={'on','off'};
[p,f,e] = fileparts(SETUP.RecentFiles.File1);
h2 = uimenu('Parent'    , h1, ...
    'Separator'         , 'on',...
	'Label'             , [f,e], ...
    'Visible'           , str{isempty(SETUP.RecentFiles.File1)+1},...
    'Callback'          , 'command(''recentFile'',''1'');',...
    'Tag'               , 'Menu:File:File1');
[p,f,e] = fileparts(SETUP.RecentFiles.File2);
h2 = uimenu('Parent'    , h1, ...
	'Label'             , [f,e], ...
    'Visible'           , str{isempty(SETUP.RecentFiles.File2)+1},...
    'Callback'          , 'command(''recentFile'',''2'');',...
    'Tag'               , 'Menu:File:File2');
[p,f,e] = fileparts(SETUP.RecentFiles.File3);
h2 = uimenu('Parent'    , h1, ...
	'Label'             , [f,e], ...
    'Visible'           , str{isempty(SETUP.RecentFiles.File3)+1},...
    'Callback'          , 'command(''recentFile'',''3'');',...
    'Tag'               , 'Menu:File:File3');
[p,f,e] = fileparts(SETUP.RecentFiles.File4);
h2 = uimenu('Parent'    , h1, ...
	'Label'             , [f,e], ...
    'Visible'           , str{isempty(SETUP.RecentFiles.File4)+1},...
    'Callback'          , 'command(''recentFile'',''4'');',...
    'Tag'               , 'Menu:File:File4');


% =================================================================
% ----------   Display   ------------------------------------------
h1 = uimenu('Parent'    , uiFig, ...
	'Label'             , '&Display', ...
	'Tag'               , 'Menu:Display',...
    'Enable'            , 'off');
str={'off' ,'on'};
h2 = uimenu('Parent'    , h1, ...
	'Label'             , 'Annotate', ...
    'Tag'               , 'Menu:Display:Annotate',...
    'Callback'          , 'command(''Change'',''Annotate'');',...
    'checked'           , str{SETUP.Display.Annotate+1});
h2 = uimenu('Parent'    , h1, ...
	'Label'             , 'Static', ...
    'Tag'               , 'Menu:Display:Static',...
    'Callback'          , 'command(''Change'',''Static'');',...
    'checked'           , str{SETUP.Display.Static+1});
h2 = uimenu('Parent'    , h1, ...
	'Label'             , 'Markers', ...
    'Tag'               , 'Menu:Display:Markers',...
    'Callback'          , 'command(''Change'',''Markers'');',...
    'checked'           , str{SETUP.Display.Markers+1});
h2 = uimenu('Parent'    , h1, ...
	'Label'             , 'Labels', ...
    'Tag'               , 'Menu:Display:Labels',...
    'Callback'          , 'command(''Change'',''Labels'');',...
    'checked'           , str{SETUP.Display.Labels+1});
h2 = uimenu('Parent'    , h1, ...
	'Label'             , 'UCS', ...
    'Tag'               , 'Menu:Display:UCS',...
    'Callback'          , 'command(''Change'',''UCS'');',...
    'checked'           , str{SETUP.Display.UCS+1});
h2 = uimenu('Parent'    , h1, ...
	'Label'             , 'Spin', ...
    'Tag'               , 'Menu:Display:Spin',...
    'Callback'          , 'command(''Change'',''Spin'');',...
    'checked'           , str{SETUP.Display.Spin+1});
h2 = uimenu('Parent'    , h1, ...
    'Separator'         , 'on',...
	'Label'             , 'Max Deflection', ...
    'Tag'               , 'Menu:Display:MaxDeflection',...
    'Callback'          , 'command(''MaxDeflection'');',...
    'checked'           , 'off');
% Component List
h2 = uimenu('Parent'    , h1, ...
	'Label'             , 'Components', ...
    'Tag'               , 'Menu:Display:Components',...
    'checked'           , str{SETUP.Component.Open+1},...
    'Callback'          , 'command(''components'',''init'');',...
	'Separator'         , 'on');

% View Menu
h1 = uimenu('Parent'    , uiFig, ...
	'Label'             , '&View', ...
	'Tag'               , 'Menu:View',...
    'Enable'            , 'off');
onOff   = strcmp({'+X','+Y','+Z'},SETUP.View.UpVector);
% Display Type
h2 = uimenu('Parent'    , h1, ...
	'Separator'         , 'off', ...
	'Label'             , 'Display Type');
h3 = uimenu('Parent'    , h2, ...
	'Label'             , 'Single', ...
    'Tag'               , 'Menu:View:Single',...
    'Callback'          , 'command(''viewType'',''Single'');',...
    'checked'           , 'on');
h3 = uimenu('Parent'    , h2, ...
	'Label'             , 'Quad', ...
    'Tag'               , 'Menu:View:Quad',...
    'Callback'          , 'command(''viewType'',''Quad'');',...
    'checked'           , 'off');
h3 = uimenu('Parent'    , h2, ...
	'Label'             , 'Cross-eyed', ...
    'Tag'               , 'Menu:View:Crosseyed',...
    'Callback'          , 'command(''viewType'',''Cross-eyed'');',...
    'checked'           , 'off');
h3 = uimenu('Parent'    , h2, ...
	'Label'             , 'Red/Blue Glasses', ...
    'Tag'               , 'Menu:View:RedBlue',...
    'Callback'          , 'command(''viewType'',''Red/Blue Glasses'');',...
    'checked'           , 'off');
% View
h2 = uimenu('Parent'    , h1, ...
	'Separator'         , 'off', ...
	'Label'             , 'View');
h3 = uimenu('Parent'    , h2, ...
	'Label'             , 'X', ...
    'Tag'               , 'Menu:View:X',...
    'Callback'          , 'command(''changeView'',''X'');',...
    'checked'           , str{viewVal(1)+1});
h3 = uimenu('Parent'    , h2, ...
	'Label'             , 'Y', ...
    'Tag'               , 'Menu:View:Y',...
    'Callback'          , 'command(''changeView'',''Y'');',...
    'checked'           , str{viewVal(2)+1});
h3 = uimenu('Parent'    , h2, ...
	'Label'             , 'Z', ...
    'Tag'               , 'Menu:View:Z',...
    'Callback'          , 'command(''changeView'',''Z'');',...
    'checked'           , str{viewVal(3)+1});
h3 = uimenu('Parent'    , h2, ...
	'Label'             , 'Ortho', ...
    'Tag'               , 'Menu:View:Ortho',...
    'Callback'          , 'command(''changeView'',''Ortho'');',...
    'checked'           , str{viewVal(4)+1});
% Up Vector
h2 = uimenu('Parent'    , h1, ...
	'Separator'         , 'off', ...
	'Label'             , 'Up Vector');
h3 = uimenu('Parent'    , h2, ...
	'Label'             , '+X', ...
    'Tag'               , 'Menu:View:+X',...
    'Callback'          , 'command(''MultipleChange'',''+X'');',...
    'checked'           , str{onOff(1)+1});
h3 = uimenu('Parent'    , h2, ...
	'Label'             , '+Y', ...
    'Tag'               , 'Menu:View:+Y',...
    'Callback'          , 'command(''MultipleChange'',''+Y'');',...
    'checked'           , str{onOff(2)+1});
h3 = uimenu('Parent'    , h2, ...
	'Label'             , '+Z', ...
    'Tag'               , 'Menu:View:+Z',...
    'Callback'          , 'command(''MultipleChange'',''+Z'');',...
    'checked'           , str{onOff(3)+1});
% Vector Type
onOff   = strcmp({'Real', 'Imaginary','Complex'},SETUP.View.VectorType);
h2 = uimenu('Parent'    , h1, ...
	'Label'             , 'Vector Type', ...
	'Separator'         , 'off');
h3 = uimenu('Parent'    , h2, ...
	'Label'             , 'Real', ...
    'Tag'               , 'Menu:Display:Real',...
    'Callback'          , 'command(''MultipleChange'',''Real'');',...
    'checked'           , str{onOff(1)+1});
h3 = uimenu('Parent'    , h2, ...
	'Label'             , 'Imaginary', ...
    'Tag'               , 'Menu:Display:Imaginary',...
    'Callback'          , 'command(''MultipleChange'',''Imaginary'');',...
    'checked'           , str{onOff(2)+1});
h3 = uimenu('Parent'    , h2, ...
	'Label'             , 'Complex', ...
    'Tag'               , 'Menu:Display:Complex',...
    'Callback'          , 'command(''MultipleChange'',''Complex'');',...
    'checked'           , str{onOff(3)+1});

% Help Type
h1 = uimenu('Parent'    , uiFig, ...
	'Label'             , '&Help');
h2 = uimenu('Parent'    , h1, ...
	'Label'             , '&Animation Help',...
    'Callback'          , 'command(''help'',''help'');');
h2 = uimenu('Parent'    , h1, ...
	'Label'             , '&About',...
    'Callback'          , 'command(''help'',''about'');');

function [iconZoom,iconAnimate,iconRotate]=loadIcons(SETUP);
iconZoom =uint8([    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204    0    0    0    0    0    0    0    0    0    0    0    0  204  204  204  204  204  204  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255  255  255  255    0    0  204  204  204  204  204  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255  255  255  255    0  229    0  204  204  204  204  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255  255  255  255    0  153  229    0  204  204  204  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255  255  255  255    0    0    0    0    0  204  204  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255  255  255  255  255  255  255  255    0  204  204  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255  255  255  255    0    0    0  255    0  204  204  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255  255    0    0  229  229  229    0    0  204  204  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255    0  162  162  229  229  229  229   76    0  204  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255    0  162  162  229  229  229  229  229   76  229    0  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255    0  229  229  229  229  229  229  229   76  229    0  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255    0  229  229  229  229  229  229  229   76  229    0  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255    0  229  229  229  229  229  229  162   51  153    0  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255    0  229  229  229  229  229  162   76    0  204  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255  255    0    0  229  229  229    0    0    0  204  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255  255  255  255    0    0    0  255    0    0    0  204  204  204    0;...
    0  204  204    0  255  255  255  255  255  255  255  255  255  255  255  255  255  255    0    0    0  204  204  204    0;...
    0  204  204    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  204    0    0    0  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0    0  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0]);
iconZoom(:,:,2)    = iconZoom;
iconZoom(:,:,3)    = iconZoom(:,:,1);
iconRotate=uint8([0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204    0    0    0    0    0  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204    0    0  187  187  187  187  187    0    0  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204    0    0  187  187  187  204  204  204  204  187  187  187  204  204  204  204  204  204  204    0;...
    0  204  204  204    0    0  187  187  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204    0  187  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204    0  187  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204    0  187  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0  204  204  204  204    0;...
    0  204    0  187  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0    0    0  204  204  204    0;...
    0  204    0  187  204  204  204  204  204  204  204  204  204  204  204  204  204    0    0    0    0    0  204  204    0;...
    0  204    0  187  204  204  204  204  204  204  204  204  204  204  204  204    0    0    0    0    0    0    0  204    0;...
    0  204    0  187  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0    0  187  187  204    0;...
    0  204    0  187  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0    0  187  204  204    0;...
    0  204  204    0  187  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0  187  204  204  204    0;...
    0  204  204    0  187  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0  187  204  204  204    0;...
    0  204  204  204    0  204  204  204  204  204  204  204  204  204  204  204  204  204    0  187  204  204  204  204    0;...
    0  204  204  204    0    0  204  204  204  204  204  204  204  204  204  204  204    0    0  187  204  204  204  204    0;...
    0  204  204  204  204    0    0  204  204  204  204  204  204  204  204  204    0    0  187  204  204  204  204  204    0;...
    0  204  204  204  204  204  187    0    0  204  204  204  204  204    0    0  187  187  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  187  187    0    0    0    0    0  187  187  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  187  187  187  187  187  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0]);
iconRotate(:,:,2)   = iconRotate;
iconRotate(:,:,3)   = iconRotate(:,:,1);

iconAnimate=uint8([0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204   16  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204   16  205   16  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204   16   16  204  204    0;...
    0  204  204  204  204  204  204  204   16   16   16   16  204  204  204  204  204  204  204   16  205   16  204  204    0;...
    0  204  204  204  204  204   16   16  205   16   16   16   16   16  204  204  204   16   16  205   16  204  204  204    0;...
    0  204  204  204  204   16  205   16   16  204  204  204  204   16   16   16   16  205   16   16  204  204  204  204    0;...
    0  204  204  204  204   16   16  204  204  204  204  204  204  204  204   16   16   16  204  204  204  204  204  204    0;...
    0  204  204  204   16  205   16  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204   16  205   16  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204   16  205   16  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204   16  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204  204    0;...
    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0]);
iconAnimate(:,:,2)  = iconAnimate;
iconAnimate(:,:,3)  = iconAnimate(:,:,1);