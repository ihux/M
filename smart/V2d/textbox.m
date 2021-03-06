function [leghandle,labelhandles]=textbox(varargin)
%TEXTBOX Graph TEXTBOX.
%   TEXTBOX(string1,string2,string3, ...) puts a textbox on the
%   current plot using the specified strings.
%
%   TEXTBOX(H,string1,string2,string3, ...) puts a TEXTBOX on the
%   plot containing the handles in the vector H using the
%   specified strings as labels for the corresponding handles.
%
%   TEXTBOX(AX,...) puts a TEXTBOX on the axes with handle AX.
%
%   TEXTBOX(M), where M is a string matrix, and TEXTBOX(H,M)
%   where H is a vector of handles to lines and patches
%   also works.
%
%   TEXTBOX OFF removes the TEXTBOX from the current axes.
%
%   TEXTBOX with no arguments refreshes the current TEXTBOX, if
%   there is one.  If there are multiple TEXTBOXs present,
%   TEXTBOX(TEXTBOXhandle) refreshes the specified TEXTBOX.
%
%   TEXTBOX(...,Pos) places the TEXTBOX in the specified
%   location:
%       0 = Automatic "best" placement (least conflict with data)
%       1 = Upper right-hand corner (default)
%       2 = Upper left-hand corner
%       3 = Lower left-hand corner
%       4 = Lower right-hand corner
%      -1 = To the right of the plot
%
%   To move the TEXTBOX, press the left mouse button on the
%   TEXTBOX and drag to the desired location.
%
%   [legh,objh] = TEXTBOX(...) returns a handle legh to the TEXTBOX
%   axes and an nx2 matrix objh containing the line/patch handles
%   and corresponding text handles in the TEXTBOX axes.
%
%   TEXTBOX works on line graphs, bar graphs, pie graphs, ribbon
%   plots, etc.  You can label any solid-colored patch or
%   surface object.
%
%   Examples:
%       x = 0:.2:12;
%       plot(x,bessel(1,x),x,bessel(2,x),x,bessel(3,x));
%       TEXTBOX('First','Second','Third');
%       TEXTBOX('First','Second','Third',-1)
%
%       b = bar(rand(10,5),'stacked'); colormap(summer);
%       hold on
%       x = plot(1:10,5*rand(10,1),'marker','square','markersize',12,...
%                'markeredgecolor','y','markerfacecolor',[.6 0 .6],...
%                'linestyle','-','color','r','linewidth',2);
%       TEXTBOX([b,x],'Carrots','Peas','Peppers','Green Beans',...
%                 'Cucumbers','Eggplant')       
%
%   See also PLOT.

%   D. Thomas 5/6/93
%             9/6/95  
%   Rich Radke 6/17/96 Latest Update
%   Copyright (c) 1984-96 by The MathWorks, Inc.
%   $Revision: 5.15 $  $Date: 1996/11/10 17:47:14 $

%   Obsolete syntax:
%
%   TEXTBOX(linetype1,string1,linetype2,string2, ...) specifies
%   the line types/colors for each label.
%   Linetypes can be any valid PLOT linetype specifying color,
%   marker type, and linestyle, such as 'g:o'.  
%
%   See HELP LSCAN for info on how the automatic placement of the
%   TEXTBOX works.

narg = nargin;
oldposdata = [];

if narg==0 | (narg == 1 & ...
       ishandle(varargin{1}) & ...
       strcmp(get(varargin{1},'tag'),'TEXTBOX'))
                               % If no input arguments 
     if narg == 0
        oldleg = findobj('Tag','TEXTBOX');   % and no existing TEXTBOXs,
        if nargout > 0
             leghandle = oldleg(1);
             labelhandles = get(leghandle,'children');
             labelhandles = [labelhandles(end-1:-2:1),labelhandles(end:-2:2)];
             return
        end
     else
        oldleg = varargin{1};
     end   
     if isempty(oldleg)                  % return
          return;
     else                                 % Otherwise, update existing
          ud = get(oldleg(1),'userdata'); % TEXTBOX.
          goodhandles = ishandle(ud.handles);
          ud.handles = ud.handles(goodhandles);
          ud.labels = ud.labels(goodhandles);
          if isempty(ud.handles)
               delete(oldleg(1)) 
               return
          end
          varargin{1} = ud.handles;
          varargin = [varargin,ud.labels'];
          oldposdata.pos = get(oldleg(1),'position');
          oldposdata.tmp = ud.posdata;
          delete(oldleg(1))
          narg = length(varargin);
     end
elseif narg==1 & ishandle(varargin{1})
     error('No string supplied for handle!')
     return
end

mode = 1;
Kids = [];

% See if first argument is a handle, if not then use current axis

if (~isstr(varargin{1})),
     if (strcmp(get(varargin{1}(1),'type'),'axes')),
          ha=varargin{1};
          shift=1;
     else,
          ha=get(varargin{1}(1),'Parent');
          if ~strcmp(get(ha,'type'),'axes'),
            error('Handle must be a axes or child of an axes.');
          end
          shift=0;
     end
else
     ha=gca;
     shift=0;
end

% Set the TEXTBOX position

if ~isequal(get(ha,'view'),[0 90])
    TEXTBOXpos = -1;    % To the right of axis is default for 3-D
else
    TEXTBOXpos = 1;   % Upper right is default for 2-D
end

tolflag=0;

if narg>1,
     tmp = varargin{narg};
     if (~isempty(tmp) & ~isstr(tmp)),
          TEXTBOXpos=tmp(1);
          tolflag=1;
     end
end

hf=get(ha,'parent');
hfold = gcf;
haold = gca;                          % Remember starting axes handle
punits=get(hf,'units');
aunits=get(ha,'units');

if strcmp(get(hf,'NextPlot'),'replace'),
     set(hf,'NextPlot','add')
end

% If TEXTBOX off, then don't do all the work

if ~(strcmp('off',lower(varargin{1})) & (narg==1)),

     ud=get(ha,'Tag');
     if strcmp(ud,'TEXTBOX')
          disp('Can''t put a TEXTBOX on a TEXTBOX')
          return
     end
  
     set(ha,'units','normalized');

% Parse other arguments to TEXTBOX

     S = varargin{1+shift};
     
     defaultlinestyle = get(hf,'defaultlinelinestyle');
     defaultlinecolor = get(hf,'defaultlinecolor');
     defaultlinewidth = get(hf,'defaultlinelinewidth');
     defaultlinemarker = get(hf,'defaultlinemarker');
     defaultlinemarkersize = get(hf,'defaultlinemarkersize');
     defaultlinemarkerfacecolor = get(hf,'defaultlinemarkerfacecolor');
     defaultlinemarkeredgecolor = get(hf,'defaultlinemarkeredgecolor');

     defaultpatchfacecolor = get(hf,'defaultpatchfacecolor');
    
     linetype = defaultlinestyle;
     edgecol = {defaultlinecolor};
     facecol = {defaultpatchfacecolor};
     lnwidth = defaultlinewidth;
     marker = defaultlinemarker;
     marksize = defaultlinemarkersize;
     markedge = {defaultlinemarkeredgecolor};
     markface = {defaultlinemarkerfacecolor};

     % These 8 variables are the important ones.  The only ambiguity is
     % edgecol/facecol.  For lines, edgecol is the line color and facecol
     % is unused.  For patches, edgecol/facecol mean the logical thing.

     if ~(isstr(S))         %   Matrix of handles
    
         Kids = reshape(S,prod(size(S)),1); 
                 %  Reshape so that we have a column vector of handles.

         nonhandles = ~ishandle(Kids);
       
         if any(nonhandles)
              warning('Some invalid handles were ignored.')
              Kids(nonhandles) = [];
         end

         badhandles = ~(strcmp(get(Kids,'type'),'patch') | ...
                        strcmp(get(Kids,'type'),'line') | ...
                        strcmp(get(Kids,'type'),'surface'));

         if any(badhandles)
              warning(['Some handles to non-lines and/or non-solid color',...
                       ' objects were ignored.'])
              Kids(badhandles) = [];
         end

         objtype = get(Kids,'type');

         if size(objtype,1) == 1
              objtype = {objtype};
         end

         varargin{1+shift} = Kids;
         [nstack,tmp]=size(Kids);

         nstack = max(nstack,tmp);
         lstrings=varargin{shift+2};
         if size(lstrings,1) ~= size(Kids,1)
              for i = (shift+3):(shift+2+size(Kids,1)-size(lstrings,1)),
                    if (i <= narg),
                          if isstr(varargin{i}),
                               lstrings = str2mat(lstrings,varargin{i});
                          else
                               lstrings = str2mat(lstrings,'');
                          end
                    else
                          lstrings = str2mat(lstrings,'');
                    end
              end
         end     

         for i=1:nstack,
              linetype = str2mat(linetype,get(Kids(i),'LineStyle'));
              if strcmp(objtype(i),'line')
                    edgecol = [edgecol,{get(Kids(i),'Color')}];            
                    facecol = [facecol,{'none'}];
              elseif strcmp(objtype(i),'patch') | strcmp(objtype(i),'surface')
                    [e,f] = patchcol(Kids(i),ha);
                    edgecol = [edgecol,{e}];
                    facecol = [facecol,{f}];
              end
              lnwidth = [lnwidth,get(Kids(i),'LineWidth')];
              marker = str2mat(marker,get(Kids(i),'Marker'));
              marksize = [marksize,get(Kids(i),'MarkerSize')];
              markedge = [markedge,{get(Kids(i),'MarkerEdgeColor')}];
              markface = [markface,{get(Kids(i),'MarkerFaceColor')}];
         end

         [n,tmp]=size(lstrings);
         linetype(1,:)=[];
         edgecol(1)=[];
         facecol(1) = [];
         lnwidth(1)=[];
         marker(1,:)=[];
         marksize(1) = [];
         markedge(1) = [];
         markface(1) = [];

         if n > nstack,     % More strings than handles
              linetype = str2mat(linetype,45*ones(n-nstack,2));
              edgecol(end+1:end+1+n-nstack) = {'none'};
              facecol(end+1:end+1+n-nstack) = {'none'};
              lnwidth = [lnwidth,defaultlinewidth*ones(1,n-nstack)];
              marker = str2mat(marker,45*ones(n-nstack,2));
              marksize = [marksize,defaultlinemarkersize*ones(1,n-nstack)];
              markedge(end+1:end+1+n-nstack) = {'auto'};
              markface(end+1:end+1+n-nstack) = {'auto'};

         elseif n < nstack  % More handles than strings
              lstrings=[lstrings',32*ones(tmp,nstack-n)]';
         end


     else

     
         [nstack,tmp]=size(S);
         if nstack>1,
              lstrings=varargin{shift+1};
              mode=1;
         else
              % See if first argument is a linetype, handle, or label
      
              [L,C,M,msg] = colstyle(S);
              if (isempty(msg) & ~isempty(S)),
                   mode = 2;    %      (LineSpec, Label, LineSpec, Label, ...)
              else
                   mode = 1;    %      (Label, Label, Label, ...)
              end 
         end      

      % Create the label strings matrix
     

         lstrings=varargin{shift+mode};
         for i=(shift+2*mode):mode:(narg-tolflag),
              lstrings=str2mat(lstrings,varargin{i});
         end
 
     nstack=size(lstrings,1);
    
     if mode == 1

          % Note: by default, lines get labeled before patches;
          % patches get labeled before surfaces.

          Kids = flipud([findobj(ha,'type','surface') ;...
                 findobj(ha,'type','patch') ; findobj(ha,'type','line')]);
   
          objtype = get(Kids,'type');

          if size(Kids,1) == 1         % If only 1 child turn into cell array
                objtype = {objtype};
          end      

          nk=length(Kids);
          if nk==0,
                disp('Warning: Plot Empty')
                return
          end

          objtype = objtype(1:min(nstack,length(objtype)));
          Kids = Kids(1:min(nstack,length(Kids)));

          for i=1:min(nk,nstack),

                linetype = str2mat(linetype,get(Kids(i),'LineStyle'));
                if strcmp(objtype(i),'line')
                    edgecol = [edgecol,{get(Kids(i),'Color')}];
                    facecol = [facecol,{'none'}];
                elseif strcmp(objtype(i),'patch') | strcmp(objtype(i),'surface')
                    [e,f] = patchcol(Kids(i),ha);
                    edgecol = [edgecol,{e}];
                    facecol = [facecol,{f}];
                end
                lnwidth = [lnwidth,get(Kids(i),'LineWidth')];
                marker = str2mat(marker,get(Kids(i),'Marker'));
                marksize = [marksize,get(Kids(i),'MarkerSize')];
                markedge = [markedge,{get(Kids(i),'MarkerEdgeColor')}];
                markface = [markface,{get(Kids(i),'MarkerFaceColor')}];
          end
          
          if nk < nstack   % More strings than handles
                objtype(end+1:end+nstack-nk) = {'none'};
                objtype = reshape(objtype,length(objtype),1);
                linetype=str2mat(linetype,setstr(' '*ones(nstack-nk,1)));
                edgecol(end+1:end+nstack-nk) = {'none'};
                facecol(end+1:end+nstack-nk) = {'none'};
                lnwidth=[lnwidth,defaultlinewidth*ones(1,nstack-nk)];
                marker=str2mat(marker,setstr(ones(nstack-nk,1)*'none'));
                marksize = [marksize,defaultlinemarkersize*ones(1,nstack-nk)];
                markedge(end+1:end+nstack-nk) = {'auto'};
                markface(end+1:end+nstack-nk) = {'auto'};
          end
 
          linetype(1,:)=[];
          edgecol(1)=[];
          facecol(1)=[];
          lnwidth(1)=[];
          marker(1,:)=[];
          marksize(1) = [];
          markedge(1) = [];
          markface(1) = [];

     elseif mode == 2,   % Every other argument is a linespec

          warning(sprintf(['The syntax TEXTBOX(linetype1,string1,linetype2,',...
                   'string2, ...) \n is obsolete.  Use TEXTBOX(H,string1,',...
                   'string2, ...) instead, \n where H is a vector of handles ',...
                   'to the objects you wish to label.']))

          % Right now we don't check to see if a corresponding linespec is
          % actually present on the graph, we just draw it anyway as a 
          % simple line with properties color, linestyle, 1-char markertype.
          % No frills like markersize, marker colors, etc.  Exception: if
          % a patch is present with facecolor = 'rybcgkwm' and the syntax
          % TEXTBOX('g','label') is used, a patch shows up in the TEXTBOX
          % instead.  Since this whole functionality is being phased out and
          % you can do better things using handles, the TEXTBOX may not look
          % as nice using this option.

          objtype = {};

          for i=(shift+1):2:(narg+tolflag)        

                lnstr=varargin{i};
                [lnt,lnc,lnm,msg] = colstyle(lnstr);
                if (isempty(msg) & ~isempty(lnstr))

                     if (isempty(lnt))
                          linetype=str2mat(linetype,defaultlinestyle);
                     else
                          linetype=str2mat(linetype,lnt);
                     end
                     if (isempty(lnc))
                          edgecol=[edgecol,{defaultlinecolor}];
                          facecol=[facecol,{defaultpatchfacecolor}];
                     else   
                          colspec = ctorgb(lnc);
                          edgecol=[edgecol,{colspec}];
                          facecol=[facecol,{colspec}];
                          if ~isempty(findobj('type','patch','facecolor',colspec)) | ...
                             ~isempty(findobj('type','surface','facecolor',colspec))
                               objtype = [objtype,{'patch'}];
                          else
                               objtype = [objtype,{'line'}];
                          end
                     end
                     if (isempty(lnm)),
                          marker=str2mat(marker,defaultlinemarker);
                     else
                          marker=str2mat(marker,lnm);
                     end
                     lnwidth = [lnwidth,defaultlinewidth];
                     marksize = [marksize,defaultlinemarkersize];
                     markedge = [markedge,{defaultlinemarkeredgecolor}];
                     markface = [markface,{defaultlinemarkerfacecolor}];
                 

               else
                     linetype=str2mat(linetype,defaultlinestyle);
                     edgecol=[edgecol,{defaultlinecolor}];
                     facecol=[facecol,{defaultpatchfacecolor}];
                     marker=str2mat(marker,defaultlinemarker);
                     lnwidth = [lnwidth,defaultlinewidth];
                     marksize = [marksize,defaultlinemarkersize];
                     markedge = [markedge,{defaultlinemarkeredgecolor}];
                     markface = [markface,{defaultlinemarkerfacecolor}];
               end

          end
     linetype(1,:)=[];
     edgecol(1)=[];
     facecol(1)=[];
     lnwidth(1)=[];
     marker(1,:)=[];
     marksize(1) = [];
     markedge(1) = [];
     markface(1) = [];

     end

    [nstack,tmp]=size(lstrings);

   end

end     %               Jump to here if TEXTBOX off

% Get current axis position, See if current axis has been
% squeezed by a previous TEXTBOX 

cap=get(ha,'position');hlo=-1;
hl = findobj('Tag','TEXTBOX');
for i=1:length(hl),
  ud = get(hl(i),'UserData');
  tmp = ud.posdata;
  if (tmp(2) == ha),
    cap=tmp(1,3:6);
    hlo = hl(i);
  else,
    if (~ishandle(tmp(2))),
      delete(hl);
    end
  end
end
hl = hlo;

tmp = get(ha,'Position');   
squeezed = 0;
if any(tmp ~= cap),
    squeezed = 1;
end
if isempty(cap),
    cap=tmp;    
end
        set(ha,'position',cap); 
if narg==1,
    if isstr(varargin{1}),
        if strcmp(lower(varargin{1}),'off'),
%       set(ha,'position',cap); 
        if hl>0, delete(hl), end;
        return;     
        end
    end
end

% Determine TEXTBOX size

fontn = get(ha,'fontname');
fonts = get(ha,'fontsize');

marksize(marksize' > fonts & strcmp(objtype,'line')) = fonts;  
marksize(marksize' > fonts/2 & strcmp(objtype,'patch')) = fonts/2;  
    % Make sure symbols in TEXTBOX aren't huge

maxp=0;
capc=get(ha,'Position');
h=text(0,0,lstrings,'fontname',fontn,'fontsize',fonts);
set(h,'units','normalized','visible','off');

for i=1:length(h)
    ext = get(h(i),'extent');
    delete(h(i));
    maxp=max(maxp,ext(3));
end

% Size to make TEXTBOX box in figure normalized units
% capc(3) scales from axis normalized units to figure normalized units

%llen=(maxp+.16)*capc(3); 
llen=(maxp+.04)*capc(3); 
lhgt=(ext(4)*1.15)*length(h)*cap(4);
                    

if (llen > cap(3)) | (lhgt > cap(4)),
  disp('Insufficient space to draw TEXTBOX');
  axes(haold)
  set(hf,'units',punits)
  set(ha,'units',aunits)
  return
end
set(ha,'units','normalized','Position',cap);

% Decide where to put the TEXTBOX

stickytol=1; Pos = -1;

if hl > 0, ud=get(hl,'userdata'); tmp = ud.posdata; end

edge = .02;

switch TEXTBOXpos,
  case 0,
    if (length(tmp) == 7) & squeezed & (hl > 0),
      if tmp(7) == 1,
    tmp(7)=0;
    ud.posdata = tmp;
    set(hl,'userdata',ud);
      end
    end     
    Pos=lscan(ha,llen,lhgt,Inf,stickytol,hl);
  case 1,
%    Pos=[cap(1)+cap(3)*.7 cap(2)+cap(4)*.7];
     Pos = [cap(1)+cap(3)-llen-edge cap(2)+cap(4)-lhgt-edge];
  case 2,
%    Pos=[cap(1)+cap(3)*.1 cap(2)+cap(4)*.7];
     Pos = [cap(1)+edge cap(2)+cap(4)-lhgt-edge];
  case 3,
%    Pos=[cap(1)+cap(3)*.1 cap(2)+cap(4)*.1];
     Pos = [cap(1)+edge cap(2)+edge];
  case 4,
%    Pos=[cap(1)+cap(3)*.7 cap(2)+cap(4)*.1];
     Pos = [cap(1)+cap(3)-llen-edge cap(2)+edge];
end

sticky=0;

if hl>0,
  ud=get(hl,'userdata');
  tmp = ud.posdata;
  if length(tmp)>6,
    if tmp(7)==1,sticky=1;end;
  end
  delete(hl);
end



if (Pos ~= -1),
  nap=cap;
  lpos=[Pos(1) Pos(2) llen lhgt];
  %@%lpos=[Pos(1) Pos(2) llen lhgt];
else,
  nap=[cap(1) cap(2) cap(3)-llen-.03 cap(4)];
  lpos=[cap(1)+cap(3)-llen .8*cap(4)+cap(2)-lhgt llen lhgt];
  %@%lpos=[cap(1)+cap(3)-llen .8*cap(4)+cap(2)-lhgt+0.05 llen lhgt];
  if sum(nap<0)+sum(lpos<0),
    disp('Insufficient space to draw TEXTBOX')
    return
  end;
end
%                   Resize Graph

set(ha,'units','normalized','Position',nap);

% Draw TEXTBOX object

if (gcf ~= hf),
    figure(hf);
end
if strcmp(get(ha,'color'),'none')
  acolor = get(hf,'color');
else
  acolor = get(ha,'color');
end

hl=axes('units','normalized','position',lpos,'box','on','drawmode', ...
      'fast','nextplot','add','xtick',[-1],'ytick',[-1], ...
      'xticklabel','','yticklabel','','xlim',[0 1],'ylim',[0 1], ...
      'clipping','on','color',acolor,'tag','TEXTBOX',...
      'climmode',get(ha,'climmode'),'clim',get(ha,'clim'));

if ~isempty(oldposdata)
    set(hl,'position',oldposdata.pos);
end

%Temp hack
set(hl,'view',[0 90]);
if isempty(lnwidth),
    lnwidth = .5*ones(1,nstack);
end

texthandles = [];
objhandles = [];

for i=1:nstack,

% draw text
  
%  t = text('position',[.15*capc(3)/llen,1-i/(nstack+1)],...
%       'string',lstrings(i,:),...
%       'fontname',fontn,...
%       'fontsize',fonts,...
%       'ButtonDownFcn','moveaxis');
    
  t = text('position',[0.02*capc(3)/llen,1-i/(nstack+1)],...
       'string',lstrings(i,:),...
       'fontname',fontn,...
       'fontsize',fonts,...
       'ButtonDownFcn','moveaxis');
    
  texthandles = [texthandles;t];

% draw lines


if(0)  % don't do this
  if strcmp(objtype(i),'line')
     p = line('xdata',[.02 .1]*capc(3)/llen,...
                'ydata',[1-i/(nstack+1) 1-i/(nstack+1)],...
                'linestyle',linetype(i,:),...
                'color',edgecol{i}, ...
                'linewidth',lnwidth(i),...
                'marker',marker(i,:),...
                'markeredgecolor',markedge{i},...
                'markerfacecolor',markface{i},...
                'markersize',marksize(i),...
                'ButtonDownFcn','moveaxis');

  elseif strcmp(objtype(i),'patch')  | strcmp(objtype(i),'surface')
         % draw patches

         % Adjusting ydata to make a thinner box will produce nicer
         % results if you use patches with markers.


     p = patch('xdata',[.02 .1 .1 .02 .02]*capc(3)/llen,...
                'ydata',1 - [2*i-1 2*i-1 2*i+1 2*i+1 2*i-1]/(2*(nstack+1)),...
                'linestyle',linetype(i,:),...
                'edgecolor',edgecol{i}, ...
                'facecolor',facecol{i},...
                'linewidth',lnwidth(i),...
                'marker',marker(i,:),...
                'markeredgecolor',markedge{i},...
                'markerfacecolor',markface{i},...
                'markersize',marksize(i),...
                'ButtonDownFcn','moveaxis');

     if strcmp(facecol{i},'flat') | strcmp(edgecol{i},'flat')
          c = get(Kids(i),'cdata');
          k = find(finite(c));
          set(p,'cdata',c(k(1))*ones(1,5),...
                'cdatamapping',get(Kids(i),'cdatamapping'));
     end
    
  end

  objhandles = [objhandles;p];

end;
end; % don't do this

% Clean up a bit

axes(haold)
hfc = get(hf,'children');
hfc(hfc==hl)=[]; 
hfc = [hl;hfc];
set(hf,'children',hfc);
set(hf,'units',punits)
set(ha,'units',aunits)
if (hfold ~= hf)
    figure(hfold);
end

if ~isempty(oldposdata)
    ud.posdata = oldposdata.tmp;
else
    ud.posdata = [1.1, ha, cap, sticky];    % Position data
end
ud.handles = Kids;                      % Vector of handles to be labeled
ud.labels = cellstr(lstrings);          % Cell array of labels

set(hl,'userdata',ud)
if nargout > 0,
    leghandle=hl;
end
if nargout > 1,
    labelhandles=[objhandles,texthandles];
end

set(hl,'ButtonDownFcn','moveaxis');
%set(hf,'Nextplot','Replace')  % Why would you want this?
set(hf,'Nextplot','add')

%  Make sure the TEXTBOX is on top of its axes

ord = get(hf,'children');
axpos = find(ord==ha);
legpos = find(ord==hl);
if legpos > axpos
    ord(legpos) = [];
    ord = [ord(1:axpos-1);legpos;ord(axpos:end)];
end
set(hf,'children',ord);

% Private function...

function  out=ctorgb(arg)

switch arg
  case 'y', out=[1 1 0];
  case 'm', out=[1 0 1];
  case 'c', out=[0 1 1];
  case 'r', out=[1 0 0];
  case 'g', out=[0 1 0];
  case 'b', out=[0 0 1];
  case 'w', out=[1 1 1];
  otherwise, out=[0 0 0];
end

% ======================================

function  [edgecol,facecol] = patchcol(S,ha)

cdat = get(S,'Cdata');

facecol = get(S,'FaceColor');
if strcmp(facecol,'interp') | strcmp(facecol,'texturemap') 
  if ~all(cdat == cdat(1))
     warning(['TEXTBOX not supported for patches with FaceColor = ''',facecol,''''])
  end
  facecol = 'flat';
end
if strcmp(facecol,'flat')
      if size(cdat,3) == 1                     % Indexed Color
            k = find(finite(cdat));
            if isempty(k)
                facecol = 'none';
            end
      else                                     % RGB values
            facecol = reshape(cdat(1,1,:),1,3);
      end

end

edgecol = get(S,'EdgeColor');
if strcmp(edgecol,'interp')
  if ~all(cdat == cdat(1))
     warning('TEXTBOX not supported for patches with EdgeColor = ''interp''.')
  end  
  edgecol = 'flat';
end
if strcmp(edgecol,'flat')
      if size(cdat,3) == 1                     % Indexed Color
            k = find(finite(cdat));
            if isempty(k)
                 edgecol = 'none';
            end
      else                                     % RGB values
            edgecol = reshape(cdat(1,1,:),1,3);
      end
end

