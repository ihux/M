function oo = plot(o,varargin)         % CUTE Plot Method              
%
% PLOT   CUTE plot method
%
%           plot(o)                    % default plot method
%           plot(o,'Plot')             % default plot method
%
%           plot(o,'PlotX')            % stream plot X
%           plot(o,'PlotY')            % stream plot Y
%           plot(o,'PlotXY')           % scatter plot
%
%        See also: CUTE, SHELL
%
   [gamma,oo] = manage(o,varargin,@Plot,@About,@Menu,...
                       @WithCuo,@WithSho,@WithBasket,...
                       @OvwMagnitude,@Process,...
                       @Metrics,@CuttingEvolution,@KapplEvolution,...
                       @Cockpit,@Kappl,@Magnitude,@Orbit,@Evolution);
   oo = gamma(oo);
end

%==========================================================================
% Plot Menu
%==========================================================================

function oo = Menu(o)                  % Setup Plot Menu               
   oo = current(o);
   switch oo.type                      % dispatch menu buildup on type
      case 'shell'
         oo = MenuShell(o);
      case 'article'
         oo = MenuArt(o);
      case 'pkg'
         oo = MenuPkg(o);
      case 'cut'
         oo = MenuCut(o);
      otherwise
         oo = o;
         return
   end
end
function oo = MenuShell(o)             % Setup Plot Menu for SHELL Type
   oo = mitem(o,'About',{@WithCuo,'About'});
   oo = mitem(o,'-');
   oo = mitem(o,'Metrics',{@WithSho,'Metrics'});
end
function oo = MenuArt(o)               % Setup Plot Menu for ART Type  
   oo = mitem(o,'About',{@WithCuo,'About'});
end
function oo = MenuPkg(o)               % Setup Plot Menu for PKG Type  
   oo = mitem(o,'About',{@WithCuo,'About'});
   oo = mitem(o,'-');
   oo = mitem(o,'Metrics',{@WithSho,'Metrics'});
end
function oo = MenuCut(o)               % Setup Plot Menu for CUL Type  
%
% MENU  Setup plot menu. Note that plot functions are best invoked via
%       Callback or Basket functions, which do some common tasks
%
   oo = mitem(o,'About',{@WithCuo,'About'});
   %oo = mitem(o,'Overview',{@WithCuo,'Process'},'AO');
   oo = mitem(o,'Metrics',{@WithCuo,'Metrics'});

   oo = mitem(o,'-');

   oo = mitem(o,'Cockpit',{@WithCuo,'Cockpit'});
   
   oo = mitem(o,'-');

   oo = mitem(o,'Process');
   %ooo = mitem(oo,'Acceleration Overview',{@WithCuo,'Process','A'});
   ooo = mitem(oo,'Acceleration Overview',{@WithCuo,'Process','AO'});
   ooo = mitem(oo,'Acceleration Magnitude',{@WithCuo,'Process'},'AM');
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Acceleration 1 (Cut)',{@WithCuo,'Process'},'A1');
   ooo = mitem(oo,'Acceleration 2 (Cross)',{@WithCuo,'Process'},'A2');
   ooo = mitem(oo,'Acceleration 3 (Normal)',{@WithCuo,'Process'},'A3');
   
   
   oo = mitem(o,'Kappl');
   ooo = mitem(oo,'Acceleration Overview',{@WithCuo,'Kappl'},'AO');
   ooo = mitem(oo,'Acceleration Magnitude',{@WithCuo,'Kappl'},'AM');
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Acceleration X',{@WithCuo,'Kappl'},'Ax');
   ooo = mitem(oo,'Acceleration Y',{@WithCuo,'Kappl'},'Ay');
   ooo = mitem(oo,'Acceleration Z',{@WithCuo,'Kappl'},'Az');
   
   oo = mitem(o,'Kolben');
   ooo = mitem(oo,'Acceleration Overview',{@WithCuo,'Kappl'},'BO');
   ooo = mitem(oo,'Acceleration Magnitude',{@WithCuo,'Kappl'},'BM');
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'X-Acceleration',{@WithCuo,'Kappl'},'Bx');
   ooo = mitem(oo,'Y-Acceleration',{@WithCuo,'Kappl'},'By');
   ooo = mitem(oo,'Z-Acceleration',{@WithCuo,'Kappl'},'Bz');
   
      % Magnitude
      
   oo = mitem(o,'Magnitude');
   ooo = mitem(oo,'Acceleration',{@WithCuo,'Magnitude'},'A');
   ooo = mitem(oo,'Velocity',{@WithCuo,'Magnitude'},'V');
   ooo = mitem(oo,'Elongation',{@WithCuo,'Magnitude'},'S');
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Kappl/Kolben',{@WithCuo,'Magnitude'},'C');

      % Separator
      
   ooo = mitem(oo,'-');

      % Orbit
   
   oo = mitem(o,'Orbit');
   ooo = mitem(oo,'Orbit Overview',{@WithCuo,'Orbit'},'O');
   
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Acceleration',{@WithCuo,'Orbit'},'A');
   ooo = mitem(oo,'Velocity',{@WithCuo,'Orbit'},'V');
   %enable(ooo,0);
   ooo = mitem(oo,'Elongation',{@WithCuo,'Orbit'},'S');
   %enable(ooo,0);

      % Evolution
      
   oo = mitem(o,'Evolution');
   ooo = mitem(oo,'Acceleration 1-2',{@WithCuo,'Evolution'},'A12');
   ooo = mitem(oo,'Acceleration 1-3',{@WithCuo,'Evolution'},'A13');
   ooo = mitem(oo,'Acceleration 2-3',{@WithCuo,'Evolution'},'A23');
   
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Velocity 1-2',{@WithCuo,'Evolution'},'V12');
   ooo = mitem(oo,'Velocity 1-3',{@WithCuo,'Evolution'},'V13');
   ooo = mitem(oo,'Velocity 2-3',{@WithCuo,'Evolution'},'V23');

   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Elongation 1-2',{@WithCuo,'Evolution'},'S12');
   ooo = mitem(oo,'Elongation 1-3',{@WithCuo,'Evolution'},'S13');
   ooo = mitem(oo,'Elongation 2-3',{@WithCuo,'Evolution'},'S23');
end
function oo = Filter(o)                % Add Filter Menu Items         
   setting(o,{'filter.mode'},'raw');   % filter mode off
   setting(o,{'filter.type'},'LowPass2');
   setting(o,{'filter.bandwidth'},5);
   setting(o,{'filter.zeta'},0.6);
   setting(o,{'filter.method'},1);

   oo = mseek(o,{'#','Select'});
   ooo = mitem(oo,'-');

   ooo = mitem(oo,'Filter');
   oooo = mitem(ooo,'Mode','','filter.mode');
   choice(oooo,{{'Raw Signal','raw'},{'Filtered Signal','filter'},...
                {'Raw & Filtered','both'},{'Signal Noise','noise'}},'');
   oooo = mitem(ooo,'-');
   oooo = mitem(ooo,'Type',{},'filter.type');
   choice(oooo,{{'Order 2 Low Pass','LowPass2'},...
                {'Order 2 High Pass','HighPass2'},...
                {'Order 4 Low Pass','LowPass4'},...
                {'Order 4 High Pass','HighPass4'}},{});
   oooo = mitem(ooo,'Bandwidth',{},'filter.bandwidth');
   charm(oooo,{});
   oooo = mitem(ooo,'Zeta',{},'filter.zeta');
   charm(oooo,{});
   oooo = mitem(ooo,'Method',{},'filter.method');
   choice(oooo,{{'Forward',0},{'Fore/Back',1},{'Advanced',2}},{});
end

%==========================================================================
% Launch Functions for Local Callback Functions
%==========================================================================

function oo = WithSho(o)               % 'With Shell Object' Callback  
%
% Sho    General callback for operation on shell object
%        with refresh function redefinition, screen
%        clearing, current object pulling and forwarding to executing
%        local function, reporting of irregularities, dark mode support
%
   refresh(o,o);                       % remember to refresh here
   cls(o);                             % clear screen
  
   gamma = eval(['@',mfilename]);
   oo = gamma(o);                      % forward to executing method

   if isempty(oo)                      % irregulars happened?
      oo = set(o,'comment',...
                 {'No idea how to plot object!',get(o,{'title',''})});
      message(oo);                     % report irregular
   end
   dark(o);                            % do dark mode actions
end
function oo = WithCuo(o)               % 'With Current Object' Callback
%
% CALLBACK   A general callback with refresh function redefinition, screen
%            clearing, current object pulling and forwarding to executing
%            local function, reporting of irregularities, dark mode support
%
   refresh(o,o);                       % remember to refresh here
   cls(o);                             % clear screen
  
   oo = current(o);                    % get current object
   
   if type(oo,{'article','cut','shell','pkg'})
      oo = opt(oo,'verbose',1);        % set verbose option
      gamma = eval(['@',mfilename]);
      oo = gamma(oo);                  % forward to executing method
   else
      oo = [];
   end

   if isempty(oo)                      % irregulars happened?
      oo = set(o,'comment',...
                 {'No idea how to plot object!',get(o,{'title',''})});
   end
   dark(o);                            % do dark mode actions
end
function oo = WithBasket(o)            % Acting on the Basket          
%
% BASKET  Plot basket, or perform actions on the basket, screen clearing, 
%         current object pulling and forwarding to executing local func-
%         tion, reporting of irregularities and dark mode support
%
   refresh(o,o);                       % use this callback for refresh
   cls(o);                             % clear screen

   gamma = eval(['@',mfilename]);
   oo = basket(o,gamma);               % perform operation gamma on basket
  
   if ~isempty(oo)                     % irregulars happened?
      message(oo);                     % report irregular
   end
   dark(o);                            % do dark mode actions
end
function oo = Current(o)                                               
   oo = current(o);
   switch type(oo)
      case 'cut'
         'OK';
      case 'pkg'
         menu(oo,'About');
         oo = [];
         return
      otherwise
         oo = [];
         return
   end
   
      % look for non-empty cache! If empty then brew and refresh
      % current object
      
   [oo,bag,rfr] = cache(oo,oo,'brew'); % hard refresh of brew cache segment
end

%==========================================================================
% Default Plot Functions
%==========================================================================

function oo = Plot(o)                  % Default Plot                  
%
% PLOT The default Plot function shows how to deal with different object
%      types. Depending on type a different local plot function is invoked
%
   oo = plot(corazon,o);               % if arg list is for corazon/plot
   if ~isempty(oo)                     % is oo an array of graph handles?
      oo = []; return                  % in such case we are done - bye!
   end
   
      % continue dispatching on type

   cls(o);                             % clear screen
   switch o.type
      case 'cut'
         oo = Cockpit(o);
      case 'pkg'
         oo = About(o);
      otherwise
         oo = [];  return              % no idea how to plot
   end
end

%==========================================================================
% Plot About Object
%==========================================================================

function oo = About(o)                 % About Object                  
   if type(o,{'shell'})
      oo = menu(corazon(o),'About');
      refresh(oo,oo);                  % here to refresh!
      return
   end
   
   comment = get(o,{'comment',{}});    % get actual comment
   comment = PropertyList(o);
   oo = set(o,'comment',comment);
   message(oo);
   
   function list = PropertyList(o)     % Construct Property List       
      switch o.type
         case 'pkg'
            list = PkgProperties(o);
         case 'cut'
            list = CutProperties(o);            
         case 'article'
            list = ArtProperties(o);            
         otherwise
            list = {};
      end
      
      list{end+1} = '  ';
      
      list = Add(o,list,'file','');
      list = Add(o,list,'dir','');
   end
   function list = PkgProperties(o)    % Get Package Property List     
      list = get(o,{'comment',{}});

      list{end+1} = '  ';
      
      list{end+1} = ['Type: package object (',o.type,')'];
      list = Add(o,list,'package','');
      list = Add(o,list,'project','');
      list = Add(o,list,'machine','');
      list = AddStringRow(o,list,'article');

      list{end+1} = '  ';

      list = AddStringRow(o,list,'station');
      list = AddStringRow(o,list,'apparatus');
      list = AddStringRow(o,list,'damping');
      
      damping = list{end};
      list(end) = [];
      
      list = AddStringRow(o,list,'kappl');
      
      kappl = list{end};
      list{end} = [damping,',  ',kappl];
      
      
      list = AddNumberRow(o,list,'vcut');
      list = AddNumberRow(o,list,'vseek');
      list = AddNumberRow(o,list,'lage');
   end
   function list = CutProperties(o)    % Get Cut Property List         
      list = {['Type: package object (',o.type,')']};
      list = Add(o,list,'package','');
      list = Add(o,list,'project','');
      list = Add(o,list,'machine','');

      list{end+1} = '  ';

      list = Add(o,list,'station','');
      list = Add(o,list,'apparatus','');
      list = Add(o,list,'damping','');
      damping = list{end};
      list(end) = [];
      list = Add(o,list,'kappl','');
      list{end} = [damping,',  ',list{end}];
      
      list = Add(o,list,'vcut',nan);
      list = Add(o,list,'vseek',nan);
      list = Add(o,list,'lage',0);
      lage = list{end};
      list(end) = [];
      list = Add(o,list,'theta',0);
      list{end} = [lage,',  ',list{end}];
      
      list{end+1} = sprintf('facettes: %g',cluster(o,inf)); 
   end
   function list = ArtProperties(o)    % Get Article Property List     
      list = {'Type: article object (article)'};
      list = Add(o,list,'glass','');
      list = AddRow(o,list,'par.facette5');
      list = AddRow(o,list,'par.facette6');
      list = AddRow(o,list,'par.facette7');
      list = AddRow(o,list,'data.lage');
      list = AddRow(o,list,'data.angle');
   end
   function list = Add(o,list,tag,def) % Add Property List Item        
      value = get(o,{tag,def});
      
      if isa(value,'double')
         txt = sprintf('%s: %g',tag,value);
      elseif ischar(value)
         txt = sprintf('%s: %s',tag,value);
      else
         txt = '';
      end
      
      if ~isempty(txt)
         list{end+1} = txt;
      end
   end
   function list = AddRow(o,list,tag)  % Add a Row                     
      name = tag;
      idx = find(name=='.');
      name(1:idx(1)) = '';
      
      txt = [name,': ['];
      value = prop(o,tag);
      sep = '';
      for (i=1:length(value))
         txt = [txt,sep,sprintf('%g',value(i))];  sep = ' ';
      end
      txt = [txt,']'];
      list{end+1} = txt;
   end
   function list = AddNumberRow(o,list,tag)  % Add Row With Numbers    
      name = tag;
      idx = find(name=='.');
      if o.is(idx)
         name(1:idx(1)) = '';
      end
      
      values = UniqueNumbers(o,get(o,tag));
      
      if (length(values) == 1)
         txt = sprintf('%s: %g',name,values);
      else
         txt = [name,': '];
         sep = '';  mind = {};
         for (i=1:length(values))
            txt = [txt,sep,sprintf('%g',values(i))];  sep = ', ';
         end
      end
      
      list{end+1} = txt;
   end
   function list = AddStringRow(o,list,tag)  % Add Row With Strings    
      name = tag;
      idx = find(name=='.');
      if o.is(idx)
         name(1:idx(1)) = '';
      end
      
      values = get(o,tag);
      values = UniqueStrings(o,values);
      
      if (length(values) == 1 && ischar(values))
         txt = sprintf('%s: %s',name,values);
      elseif (length(values) == 1 && iscell(values))
         txt = sprintf('%s: %s',name,values{1});
      else
         txt = [name,': '];
         sep = '';  mind = {};
         for (i=1:length(values))
            txt = [txt,sep,sprintf('%s',values{i})];  sep = ', ';
         end
         txt = [txt,''];
      end
      
      list{end+1} = txt;
   end
   function out = UniqueNumbers(o,values)                              
      assert(isa(values,'double'));
      
      if (length(values) <= 1)
         out = values;
         return
      end
      
      values = values(:);  out = [];  mind = {};
      
      for (i=1:length(values))
         val = values(i);
         sval = sprintf('%g',val);
         if ~o.is(sval,mind)
            out(1,end+1) = val;
            mind{end+1} = sval;
         end
      end
      
      out = sort(out);
   end
   function out = UniqueStrings(o,values)                              
      if (length(values) <= 1)
         out = values;
         return
      end
      
      assert(isa(values,'char')||iscell(values));

      values = values(:);  out = [];  mind = {};
      
      for (i=1:length(values))
         val = values{i};
         if ~o.is(val,mind)
            out{1,end+1} = val;
            mind{end+1} = val;
         end
      end
      
      out = sort(out);
   end
end

%==========================================================================
% Cockpit, Raw & Orbit
%==========================================================================

function oo = Cockpit(o)               % plot velocity and elongation  
   if ~type(o,{'cut'})
      oo = plot(o,'About');
      return
   end
   
   uscore = util(o,'uscore');
   mode = arg(o,1);
   
   oo = Current(o);
   
   t  = cook(oo,'t');
   a1 = cook(oo,'a1');
   a2 = cook(oo,'a2');
   a3 = cook(oo,'a3');
   v1 = cook(oo,'v1');
   v2 = cook(oo,'v2');
   v3 = cook(oo,'v3');
   s1 = cook(oo,'s1');
   s2 = cook(oo,'s2');
   s3 = cook(oo,'s3');

      % index 1 plots

   diagram(oo,'A1',t,a1,[3 4 1]);
   diagram(oo,'V1',t,v1,[3 4 5]);
   diagram(oo,'S1',t,s1,[3 4 9]);
   xlabel('time [s]');
   
      % index 2 plots

   diagram(oo,'A2',t,a2,[3 4 2]);
   diagram(oo,'V2',t,v2,[3 4 6]);
   diagram(oo,'S2',t,s2,[3 4 10]);
   xlabel('time [s]');
   
      % index 3 plots

   diagram(oo,'A3',t,a3,[3 4 3]);
   diagram(oo,'V3',t,v3,[3 4 7]);
   diagram(oo,'S3',t,s3,[3 4 11]);
   xlabel('time [s]');
   
      % x/y plots

   diagram(oo,'A12',a1,a2,[3 4 4]);
   if isequal(opt(o,'analyse.select.scaling'),'same');
      maxi = max(max(abs(ax)),max(abs(ay)));
      %set(gca,'xlim',[-maxi maxi],'ylim',[-maxi maxi]);
   end
   
   diagram(oo,'V12',v1,v2,[3 4 8]);
   if isequal(opt(o,'analyse.select.scaling'),'same');
      maxi = max(max(abs(vx)),max(abs(vy)));
      %set(gca,'xlim',[-maxi maxi],'ylim',[-maxi maxi]);
   end
   
   diagram(oo,'S12',s1,s2,[3 4 12]);
   if isequal(opt(o,'analyse.select.scaling'),'same');
      maxi = max(max(abs(sx)),max(abs(sy)));
      %set(gca,'xlim',[-maxi maxi],'ylim',[-maxi maxi]);
   end
   
   closeup(o);
   menu(oo,'Heading');
end
function oo = Process(o)               % Plot 1-2-3 Data               
   if ~type(o,{'cut'})
      oo = plot(o,'About');
      return
   end
   
   uscore = util(o,'uscore');
   mode = arg(o,1);
   
   oo = Current(o);
   
   switch mode
      case 'A'         
         t = cook(oo,':','stream');
         a1 = cook(oo,'a1','stream'); % fetch cutting acceleration 1
         a2 = cook(oo,'a2','stream'); % fetch cutting acceleration 2
         a3 = cook(oo,'a3','stream'); % fetch cutting acceleration 3
         
         diagram(oo,'A1',t,a1,[3 3 1]);
         diagram(oo,'A2',t,a2,[3 3 4]);
         diagram(oo,'A3',t,a3,[3 3 7]);

         diagram(oo,'A13',a1,a3,[3 6 3]);  Orbit(o,'','','a3 (a1)');
         diagram(oo,'A12',a1,a2,[3 6 9]);  Orbit(o,'','','a2 (a1)');
         diagram(oo,'A23',a2,a3,[3 6 15]); Orbit(o,'','','a3 (a2)');
         
         oo = opt(oo,'spec.mode',0);
         
         diagram(oo,'A13',a1,a3,[3 6 4]);  Orbit(o,'','','a3 (a1)');
         diagram(oo,'A12',a1,a2,[3 6 10]); Orbit(o,'','','a2 (a1)');
         diagram(oo,'A23',a2,a3,[3 6 16]); Orbit(o,'','','a3 (a2)');
         
         diagram(oo,'A1',t,a1,[3 3 3]);
         diagram(oo,'A2',t,a2,[3 3 6]);
         diagram(oo,'A3',t,a3,[3 3 9]);
         
      case 'AO'         
         t = cook(oo,':','stream');
         a1 = cook(oo,'a1','stream'); % fetch cutting acceleration 1
         a2 = cook(oo,'a2','stream'); % fetch cutting acceleration 2
         a3 = cook(oo,'a3','stream'); % fetch cutting acceleration 3
         a = cook(oo,'a');
         
         diagram(oo,'A1',t,a1,[4 2 1]);
         diagram(oo,'A2',t,a2,[4 2 3]);
         diagram(oo,'A3',t,a3,[4 2 5]);
         diagram(oo,'A', t,a, [4 2 7]);   

         diagram(oo,'A13',a1,a3,[2 2 2]);  Stretch(o);
         diagram(oo,'A12',a1,a2,[2 2 4]);  Stretch(o);

      case 'AM'
         t = cook(oo,':','stream');
         a = cook(oo,'a');
         %diagram(oo,'Ar',t,ar,[2 1 1]);   
         diagram(oo,'A',t,a,[2 1 1]);   
         oo = opt(oo,'spec.mode',0);
         %diagram(oo,'Ar',t,ar,[2 1 2]);   
         diagram(oo,'A',t,a,[2 1 2]);   

      case 'A1'         
         t = cook(oo,':','stream');
         a1 = cook(oo,'a1','stream'); % fetch cutting acceleration 1         
         diagram(oo,'A1',t,a1,[1 1 1]);
      case 'A2'         
         t = cook(oo,':','stream');
         a2 = cook(oo,'a2','stream'); % fetch cutting acceleration 2         
         diagram(oo,'A2',t,a2,[1 1 1]);
      case 'A3'         
         t = cook(oo,':','stream');
         a3 = cook(oo,'a3','stream'); % fetch cutting acceleration 3         
         diagram(oo,'A3',t,a3,[1 1 1]);

      case 'B'
         assert(0);
         t = cook(oo,':','stream');
         bx = cook(oo,'bx#','stream'); % fetch raw kappl acceleration x
         by = cook(oo,'by#','stream'); % fetch raw kappl acceleration y
         bz = cook(oo,'bz#','stream'); % fetch raw kappl acceleration z
         
         diagram(oo,'Bx',t,bx,[3 1 1]);
         diagram(oo,'By',t,by,[3 1 2]);
         diagram(oo,'Bz',t,bz,[3 1 3]);
      case 'B1'         
         assert(0);
         t = cook(oo,':','stream');
         bx = cook(oo,'bx#','stream'); % fetch raw kolben acceleration x         
         diagram(oo,'Bx',t,bx,[1 1 1]);
      case 'B2'         
         assert(0);
         t = cook(oo,':','stream');
         by = cook(oo,'by#','stream'); % fetch raw kolben acceleration y         
         diagram(oo,'By',t,by,[1 1 1]);
      case 'B3'         
         assert(0);
         t = cook(oo,':','stream');
         bz = cook(oo,'bz#','stream'); % fetch raw kolben acceleration z         
         diagram(oo,'Bz',t,bz,[1 1 1]);

      otherwise
         message(o);
   end
   
   closeup(oo,'Setup');
   menu(oo,'Heading');
   
   function Orbit(o,xlab,ylab,tit)     % Re-label Orbit Plots          
      xlabel(xlab);
      ylabel(ylab);
      title(tit);
      shelf(o,gca,'closeup',0);        % prevent from closeup control
   end
end
function oo = Kappl(o)                 % plot raw data                 
   if ~type(o,{'cut'})
      oo = plot(o,'About');
      return
   end
   
   uscore = util(o,'uscore');
   mode = arg(o,1);
   
   oo = Current(o);
   
   switch mode
      case 'A'         
         t = cook(oo,':','stream');
         ax = cook(oo,'ax#','stream'); % fetch raw kappl acceleration x
         ay = cook(oo,'ay#','stream'); % fetch raw kappl acceleration y
         az = cook(oo,'az#','stream'); % fetch raw kappl acceleration z
         
         diagram(oo,'Ax',t,ax,[3 1 1]);
         diagram(oo,'Ay',t,ay,[3 1 2]);
         diagram(oo,'Az',t,az,[3 1 3]);
      case 'AM'
         t = cook(oo,':','stream');
         ar = cook(oo,'ar');
         diagram(oo,'Ar',t,ar,[2 1 1]);   
         oo = opt(oo,'spec.mode',0);
         diagram(oo,'Ar',t,ar,[2 1 2]);   
      case 'AO'         
         t = cook(oo,':','stream');
         ax = cook(oo,'ax','stream'); % fetch cutting acceleration 1
         ay = cook(oo,'ay','stream'); % fetch cutting acceleration 2
         az = cook(oo,'az','stream'); % fetch cutting acceleration 3
         ar = cook(oo,'ar');
         
         diagram(oo,'Ay',t,ax,[4 2 1]);
         diagram(oo,'Ay',t,ay,[4 2 3]);
         diagram(oo,'Az',t,az,[4 2 5]);
         diagram(oo,'Ar',t,ar,[4 2 7]);   

         diagram(oo,'Axz',ax,az,[2 2 2]);  Stretch(o);
         diagram(oo,'Axy',ax,ay,[2 2 4]);  Stretch(o);
      case 'Ax'         
         t = cook(oo,':','stream');
         ax = cook(oo,'ax','stream'); % fetch raw kappl acceleration x         
         diagram(oo,'Ax',t,ax,[1 1 1]);
      case 'Ay'         
         t = cook(oo,':','stream');
         ay = cook(oo,'ay','stream'); % fetch raw kappl acceleration y         
         diagram(oo,'Ay',t,ay,[1 1 1]);
      case 'Az'         
         t = cook(oo,':','stream');
         az = cook(oo,'az','stream'); % fetch raw kappl acceleration z         
         diagram(oo,'Az',t,az,[1 1 1]);

      case 'B'         
         t = cook(oo,':','stream');
         bx = cook(oo,'bx#','stream'); % fetch raw kappl acceleration x
         by = cook(oo,'by#','stream'); % fetch raw kappl acceleration y
         bz = cook(oo,'bz#','stream'); % fetch raw kappl acceleration z
         
         diagram(oo,'Bx',t,bx,[3 1 1]);
         diagram(oo,'By',t,by,[3 1 2]);
         diagram(oo,'Bz',t,bz,[3 1 3]);
      case 'BM'
         t = cook(oo,':','stream');
         br = cook(oo,'br#');
         diagram(oo,'Br',t,br,[2 1 1]);   
         oo = opt(oo,'spec.mode',0);
         diagram(oo,'Br',t,br,[2 1 2]);   
      case 'BO'         
         t = cook(oo,':','stream');
         bx = cook(oo,'bx#','stream'); % fetch kolben acceleration x
         by = cook(oo,'by#','stream'); % fetch kolben acceleration y
         bz = cook(oo,'bz#','stream'); % fetch kolben acceleration z
         br = cook(oo,'br#');
         
         diagram(oo,'By',t,bx,[4 2 1]);
         diagram(oo,'By',t,by,[4 2 3]);
         diagram(oo,'Bz',t,bz,[4 2 5]);
         diagram(oo,'Br',t,br,[4 2 7]);   

         diagram(oo,'Bxz',bx,bz,[2 2 2]);  Stretch(o);
         diagram(oo,'Bxy',bx,by,[2 2 4]);  Stretch(o);
      case 'Bx'         
         t = cook(oo,':','stream');
         bx = cook(oo,'bx#','stream'); % fetch raw kolben acceleration x         
         diagram(oo,'Bx',t,bx,[1 1 1]);
      case 'By'         
         t = cook(oo,':','stream');
         by = cook(oo,'by#','stream'); % fetch raw kolben acceleration y         
         diagram(oo,'By',t,by,[1 1 1]);
      case 'Bz'         
         t = cook(oo,':','stream');
         bz = cook(oo,'bz#','stream'); % fetch raw kolben acceleration z         
         diagram(oo,'Bz',t,bz,[1 1 1]);

      otherwise
         message(o);
   end
   
   closeup(oo,'Setup');
   menu(oo,'Heading');
   
   function Orbit(o,xlab,ylab,tit)     % Re-label Orbit Plots          
      xlabel(xlab);
      ylabel(ylab);
      title(tit);
      shelf(o,gca,'closeup',0);        % prevent from closeup control
   end
   function Stretch(o)                 % Stretch Orbit Plot            
      ylim = get(gca,'Ylim');
      set(gca,'Xlim',ylim*1.5);
      shelf(o,gca,'closeup',0);        % prevent from closeup control
   end
end
function oo = Magnitude(o)             % X/Y Stream Plot of Magnitude  
   if ~type(o,{'cut'})
      oo = plot(o,'About');
      return
   end
   
   mode = arg(o,1);
   oo = Current(o);

   t = cook(oo,':','stream');
%  cls(o);
      
      % x/y plots

   switch mode
      case 'A'
         ar = cook(oo,'ar');
         diagram(oo,'Ar',t,ar,[1 1 1]);   
         
      case 'V'
         vr = cook(oo,'vr');
         diagram(oo,'Vr',t,vr,[1 1 1]);
         
      case 'S'
         sr = cook(oo,'sr');
         diagram(oo,'Sr',t,sr,[1 1 1]);
         
      case 'C'
         ar = cook(oo,'ar');
         diagram(oo,'Ar',t,ar,[3 1 1]);

         br = cook(oo,'br');
         diagram(oo,'Br',t,br,[3 1 2]);

         cr = ar.*br;
         diagram(oo,'Cr',t,cr,[3 1 3]);
         c = cov(ar/std(ar),br/std(br));
         xlabel(sprintf('Cross Correlation: %g%%',round(1000*c(1,2))/10));
         plot(get(gca,'xlim'),+500*[1 1],'k-.');
         plot(get(gca,'xlim'),-500*[1 1],'k-.');
   end
end

function oo = OrbitRaw(o)              % X/Y Orbit Plot                
   if ~type(o,{'cut'})
      oo = plot(o,'About');
      return
   end
   
   mode = arg(o,1);
   oo = Current(o);
      
      % x/y plots

   switch mode
      case 'A'
         OrbitA(o);
   
      case 'V'
         vx = cook(oo,'vx','stream');
         vy = cook(oo,'vy','stream');
         diagram(oo,'Vxy',vx,vy,[1 1 1]);
   
      case 'S'
         sx = cook(oo,'sx','stream');
         sy = cook(oo,'sy','stream');
         diagram(oo,'Sxy',sx,sy,[1 1 1]);

      case 'AV'
         OrbitAV(o)
   end
   
   menu(oo,'Heading');
   
   function OrbitA(o)                  % Acceleration
      ax = cook(oo,'ax','stream');
      ay = cook(oo,'ay','stream');
      az = cook(oo,'az','stream');
 
      O{1} = diagram(oo,'Axy',ax,ay,[1 3 1]);
      O{2} = diagram(oo,'Axz',ax,az,[1 3 3]);
      O{3} = diagram(oo,'Azy',az,ay,[1 3 2]);

      Equalize(O);
   end
   function OrbitAV(o)                 % Acceleration/Velocity Orbits  
      ax = cook(oo,'ax','stream');
      ay = cook(oo,'ay','stream');
      az = cook(oo,'az','stream');

      O{1} = diagram(oo,'Axy',ax,ay,[2 3 1]);
      O{2} = diagram(oo,'Axz',ax,az,[2 3 4]);
      O{3} = diagram(oo,'Azy',az,ay,[2 3 2]);
      
      Equalize(O);

      vx = cook(oo,'vx','stream');
      vy = cook(oo,'vy','stream');
      vz = cook(oo,'vz','stream');

      O{1} = diagram(oo,'Vxy',vx,vy,[2 3 6]);
      O{2} = diagram(oo,'Vxz',vx,vz,[2 3 3]);
      O{3} = diagram(oo,'Vzy',vz,vy,[2 3 5]);
      
      Equalize(O);
   end
   function Equalize(O)                % Equalize Axes Limits          
      lim = 0;
      for (i=1:length(O))
         hax = var(O{i},'hax');
         maxi = max(max(abs(get(hax,'xlim'))),max(abs(get(hax,'ylim'))));
         lim = max(lim,maxi);
      end
      for (i=1:length(O))
         hax = var(O{i},'hax');
         set(hax,'xlim',lim*[-1 1],'ylim',lim*[-1 1]);
      end
   end
end
function oo = Orbit(o)                 % 1-2-3 Orbit Plot              
   if ~type(o,{'cut'})
      oo = plot(o,'About');
      return
   end
   
   mode = arg(o,1);
   oo = Current(o);
      
      % x/y plots

   switch mode
      case 'A'
         OrbitA(o);
   
      case 'V'
         OrbitV(o);
         %v1 = cook(oo,'v1','stream');
         %v2 = cook(oo,'v2','stream');
         %diagram(oo,'V12',v1,v2,[1 1 1]);
   
      case 'S'
         OrbitS(o);
         %s1 = cook(oo,'s1','stream');
         %s2 = cook(oo,'s2','stream');
         %diagram(oo,'S12',s1,s2,[1 1 1]);

      case 'AV'
         OrbitAV(o)

      case 'O'                         % orbit overview
         OrbitO(o)
   end
   
   menu(oo,'Heading');
   
   function OrbitA(o)                  % Acceleration
      a1 = cook(oo,'a1');
      a2 = cook(oo,'a2');
      a3 = cook(oo,'a3');
 
      O{1} = diagram(oo,'A12',a1,a2,[1 3 1]);
      O{2} = diagram(oo,'A13',a1,a3,[1 3 3]);
      O{3} = diagram(oo,'A32',a3,a2,[1 3 2]);

      Equalize(O);
   end
   function OrbitV(o)                  % Velocity
      v1 = cook(oo,'v1');
      v2 = cook(oo,'v2');
      v3 = cook(oo,'v3');
 
      O{1} = diagram(oo,'V12',v1,v2,[1 3 1]);
      O{2} = diagram(oo,'V13',v1,v3,[1 3 3]);
      O{3} = diagram(oo,'V32',v3,v2,[1 3 2]);

      Equalize(O);
   end
   function OrbitS(o)                  % Elongation
      s1 = cook(oo,'s1');
      s2 = cook(oo,'s2');
      s3 = cook(oo,'s3');
 
      O{1} = diagram(oo,'S12',s1,s2,[1 3 1]);
      O{2} = diagram(oo,'S13',s1,s3,[1 3 3]);
      O{3} = diagram(oo,'S32',s3,s2,[1 3 2]);

      Equalize(O);
   end
   function OrbitAV(o)                 % Acceleration/Velocity Orbits  
      ax = cook(oo,'ax','stream');
      ay = cook(oo,'ay','stream');
      az = cook(oo,'az','stream');

      O{1} = diagram(oo,'Axy',ax,ay,[2 3 1]);
      O{2} = diagram(oo,'Axz',ax,az,[2 3 4]);
      O{3} = diagram(oo,'Azy',az,ay,[2 3 2]);
      
      Equalize(O);

      vx = cook(oo,'vx','stream');
      vy = cook(oo,'vy','stream');
      vz = cook(oo,'vz','stream');

      O{1} = diagram(oo,'Vxy',vx,vy,[2 3 6]);
      O{2} = diagram(oo,'Vxz',vx,vz,[2 3 3]);
      O{3} = diagram(oo,'Vzy',vz,vy,[2 3 5]);
      
      Equalize(O);
   end
   function OrbitO(o)                  % Orbit Overview                
      a1 = cook(oo,'a1');
      a2 = cook(oo,'a2');
      a3 = cook(oo,'a3');

      O{1} = diagram(oo,'A12',a1,a2,[3 3 1]);
      O{2} = diagram(oo,'A13',a1,a3,[3 3 2]);
      O{3} = diagram(oo,'A32',a3,a2,[3 3 3]);
      
      Equalize(O);

      v1 = cook(oo,'v1');
      v2 = cook(oo,'v2');
      v3 = cook(oo,'v3');

      O{1} = diagram(oo,'V12',v1,v2,[3 3 4]);
      O{2} = diagram(oo,'V13',v1,v3,[3 3 5]);
      O{3} = diagram(oo,'V32',v3,v2,[3 3 6]);
      
      Equalize(O);

      s1 = cook(oo,'s1');
      s2 = cook(oo,'s2');
      s3 = cook(oo,'s3');

      O{1} = diagram(oo,'S12',s1,s2,[3 3 7]);
      O{2} = diagram(oo,'S13',s1,s3,[3 3 8]);
      O{3} = diagram(oo,'S32',s3,s2,[3 3 9]);
      
      Equalize(O);
   end
   function Equalize(O)                % Equalize Axes Limits          
      lim = 0;
      for (i=1:length(O))
         hax = var(O{i},'hax');
         maxi = max(max(abs(get(hax,'xlim'))),max(abs(get(hax,'ylim'))));
         lim = max(lim,maxi);
      end
      for (i=1:length(O))
         hax = var(O{i},'hax');
         set(hax,'xlim',lim*[-1 1],'ylim',lim*[-1 1]);
      end
   end
end

%==========================================================================
% Evolution
%==========================================================================

function oo = Evolution(o)             % Evolution of Orbits           
   if ~type(o,{'cut'})
      oo = plot(o,'About');
      return
   end
   
   oo = CuttingEvolution(o);
end
function oo = CuttingEvolution(o)      % Evolution of Orbits           
   mode = arg(o,1);
   scaling = opt(o,{'select.scaling','same'});
   
   oo = Current(o);
   
   index = cache(oo,'cluster.index');
   
   cls(o);
   
   t = cook(oo,'t');
   
   a1 = cook(oo,'a1');
   a2 = cook(oo,'a2');
   a3 = cook(oo,'a3');
   
   v1 = cook(oo,'v1');
   v2 = cook(oo,'v2');
   v3 = cook(oo,'v3');

   s1 = cook(oo,'s1');
   s2 = cook(oo,'s2');
   s3 = cook(oo,'s3');
   
      % define layout parameters
      
   m = 3;  n = 6;  extra = 1;
   M = 0;  N = m*n + 2*M;

      % plot top 3 diagrams
   
   switch mode
      case 'A12'
         type1 = mode;  type2 = 'A';  xx = a1;  yy = a2;
         spec = opt(o,'spec.a');
      case 'A13'
         type1 = mode;  type2 = 'A';  xx = a1;  yy = a3;
         spec = opt(o,'spec.a');
      case 'A23'
         type1 = mode;  type2 = 'A';  xx = a2;  yy = a3;
         spec = opt(o,'spec.a');
         
      case 'V12'
         type1 = mode;  type2 = 'V';  xx = v1;  yy = v2;
         spec = opt(o,'spec.v');
      case 'V13'
         type1 = mode;  type2 = 'V';  xx = v1;  yy = v3;
         spec = opt(o,'spec.v');
      case 'V23'
         type1 = mode;  type2 = 'V';  xx = v2;  yy = v3;
         spec = opt(o,'spec.v');
        
      case 'S12'
         type1 = mode;  type2 = 'S';  xx = s1;  yy = s2;
         spec = opt(o,'spec.s');
      case 'S13'
         type1 = mode;  type2 = 'S';  xx = s1;  yy = s3;
         spec = opt(o,'spec.s');
      case 'S23'
         type1 = mode;  type2 = 'S';  xx = s2;  yy = s3;
         spec = opt(o,'spec.s');
   end
   switch opt(o,'spec.mode')
      case 0
         spec = 0;
      case 1
         spec = spec(1);
      case 2
         spec = spec(2);
   end
   
   oo = opt(o,'metrics',false);        % don't add metrics on title
   Info(oo,[m+extra,3,1]);
   
   diagram(oo,mode([1 2]),t,xx,[m+extra,3,2]);
   diagram(oo,mode([1 3]),t,yy,[m+extra,3,3]);

      % get index
      
   [index,t] = cluster(oo);
   
      % plot evolution of orbits
      
   maxi = 0;
   for (i=1:m*n)
      bdx = Chunk(o,index,N,i+M);
      x = xx(bdx);  y = yy(bdx);      
      x = x-mean(x);  y = y-mean(y);  
      
      t1 = o.rd(t(bdx(1)),2);
      t2 = o.rd(t(bdx(end)),2);
      
      if isequal(scaling,'same')
         diagram(oo,type1,x,y,[m+extra n i+n]);
         set(gca,'DataAspectRatio',[1 1 1]);
      else
         oo = opt(oo,'spec',[]);   % no spec drawing
         diagram(oo,type1,x,y,[m+extra n i+n]);
      end
      title(sprintf('%g ... %g',t1,t2));
      shg;  pause(0.01);
      
      maxi = max(maxi,max(max(abs(x)),max(abs(y))));
   end
   
   if isequal(scaling,'same')
      for (i=1:m*n)
         subplot(m+extra,n,i+n);
         maxi = max(maxi,spec*5.5/5);
         set(gca,'xlim',[-maxi maxi],'ylim',[-maxi maxi]);
      end
   end
end
function oo = KapplEvolution(o)        % Evolution of Orbits           
   mode = arg(o,1);
   scaling = opt(o,{'analyse.select.scaling','same'});
   
   refresh(o,o);
   oo = Current(o);
   
   index = cache(oo,'cluster.index');
   
   cls(o);
   
   t = cook(oo,'t');
   %[vx,sx,ax] = velocity(oo,oo.data.ax,t);
   %[vy,sy,ay] = velocity(oo,oo.data.ay,t);
   
   ax = cook(oo,'ax');
   ay = cook(oo,'ay');
   az = cook(oo,'az');

      % define layout parameters
      
   m = 3;  n = 6;  extra = 1;
   %M = 20;  N = m*n + 3*M;
   M = 0;  N = m*n + 2*M;

      % plot top 3 diagrams
   
   switch mode
      case 'A'
         type1 = 'AXY';  type2 = 'A';  xx = ax;  yy = ay;
         spec = opt(o,'spec.a');
      case 'V'
         type1 = 'VXY';  type2 = 'V';  xx = vx;  yy = vy;
         spec = opt(o,'spec.v');
      case 'S'
         type1 = 'SXY';  type2 = 'S';  xx = sx;  yy = sy;
         spec = opt(o,'spec.s');
   end
   switch opt(o,'spec.mode')
      case 0
         spec = 0;
      case 1
         spec = spec(1);
      case 2
         spec = spec(2);
   end
   
   subplot(m+extra,3,1);
   Info(oo);
   
   diagram(oo,[type2,'x'],t,xx,[m+extra,3,2]);
   diagram(oo,[type2,'y'],t,yy,[m+extra,3,3]);
   shg;  pause(0.01);

      % plot evolution of orbits
      
   maxi = 0;
   for (i=1:m*n)
      bdx = Chunk(o,index,N,i+M);
      x = xx(bdx);  y = yy(bdx);      
      x = x-mean(x);  y = y-mean(y);  
      
      if isequal(scaling,'same')
         diagram(oo,type1,x,y,[m+extra n i+n]);
         set(gca,'DataAspectRatio',[1 1 1]);
      else
         oo = opt(oo,'spec',0);   % no spec drawing
         diagram(oo,type1,x,y,[m+extra n i+n]);
      end
      shg;  pause(0.01);
      
      maxi = max(maxi,max(max(abs(x)),max(abs(y))));
   end
   
   if isequal(scaling,'same')
      for (i=1:m*n)
         subplot(m+extra,n,i+n);
         maxi = max(maxi,spec*5.5/5);
         set(gca,'xlim',[-maxi maxi],'ylim',[-maxi maxi]);
      end
   end
end
function oo = Info(o,sub)              % Plot Info Diagram             
   subplot(o,sub);
   oo = opt(o,'subplot',1);
   uscore = util(o,'uscore');
   
   title(uscore(get(oo,'title')));
   set(gca,'xtick',[],'ytick',[]);
   
   nick = sprintf('%s',get(oo,{'nick',''}));
   lage = sprintf('Lage: %g',get(oo,{'lage',NaN}));
   angle = sprintf('Angle: %g',get(oo,{'angle',NaN}));
   station = sprintf('Station: %s',get(oo,{'station',''}));

   comment = {nick,' ',lage,' ',angle,' ',station};
   message(oo,'',comment);
   dark(o,'Axes');
end

%==========================================================================
% Metrics (Cpk,Chk,Mgr)
%==========================================================================

function oo = Metrics(o)               % Plot Metrics (Dispatcher)     
   oo = current(o);
   
   cls(o);
   switch oo.type
      case 'shell'
         ShellMetrics(o);
      case 'pkg'
         PkgMetrics(oo);
      case 'cut'
         CutMetrics(oo);
      otherwise
         plot(oo,'About');
   end
   dark(o);
end
function o = ShellMetrics(o)           % Plot Shell Metricss           
   oo = current(o);
   if ~container(oo) || ~type(oo,{'shell'}) || isempty(oo.data)                 
      plot(o,'About');
      return                           % bye!
   end

   uscore = util(o,'uscore');          % short hand
   strong = (spec(o) <= 1);            % strong spec mode
 
      % begin graphics, return boundary values

   [o,m,xlim] = Begin(o,[1 1 1]);      % begin graphics 
   PlotBars(o);                        % plot bars row by row ...
   End(o);                             % end graphics
   
   function PlotBars(o)                % Plot Bars Row by Row          
      ru = 0.05;                       % graphical raster unit
      p = 0;                           % package index
      y = m;                           % y-position
      for (i=1:length(o.data))
         oo = o.data{i};
         oo = inherit(oo,o);           % inherit options from container
         
         if type(oo,{'pkg'})
            index = var(oo,'index');   % already pre-calculated in Begin
            if isempty(index)
               continue                % ignore this package
            end
            
            p = p+1;                   % inc package index
            y0 = y;                    % mid this y coordinate

            name = get(oo,{'title',''});
            txt = o.iif(name,name,sprintf('Package #%g',p));
            hdl = text(0,y,txt);
            set(hdl,'Color',o.color('bc'));
            FontSize(o,m,hdl,+4);
            y = y-1;                   % decrement y position

               % fetch bag of package cache segment

            [oo,bag,rfr] = cache(oo,'package');
            
            cpk = o.iif(strong,bag.cpks(index),bag.cpkw(index));
            mgr = o.iif(strong,bag.mgrs(index),bag.mgrw(index));
            chk = bag.chk(index);
            facettes = bag.facettes(index);

            if (index)
               objects = bag.objects(index);
            else
               objects = {};
            end

               % plot metrics bars

            for (j=1:length(objects))
               PlotBar(o,mgr(j),[y+3*ru,y+7*ru],'r');
               PlotBar(o,cpk(j),[y-2*ru,y+2*ru],'ryyy');
               PlotBar(o,chk(j),[y-3*ru,y-7*ru],'ggk');

               PlotFacettes(o,facettes(j),[y-7*ru,y+7*ru],'wk');

               x0 = max([cpk(j),mgr(j),chk(j)]);
               Text(oo,m,j,x0,y,ru, objects{j},mgr(j),cpk(j),chk(j));
               
               y = y-1;                   % decrement y position
            end
            
            hdl = plot(o,[1 1],[y0-0.5 y+0.5],'c-.');
            set(hdl,'Linewidth',opt(o,{'spec.linewidth',1}));
         end
      end
   end
   function OldText(o,m,j,x,y,ru,objs,mgr,cpk,chk)                     
      name = uscore(objs);

      txt0 = sprintf('(Mgr: %g, Cpk: %g, Chk: %g)',...
                     o.rd(mgr,2), o.rd(cpk,2), o.rd(chk,2));
      txt1 = [' ',name];
      
         % get other data
         
      try
         index = var(o,'index');

         number = cache(o,'package.number');    number = number(index);
         number = number(j);

         station = cache(o,'package.station');  station = station(index);
         station = uscore(station{j});

         damping = cache(o,'package.damping');  damping = damping(index);
         damping = uscore(damping{j});

         kappl = cache(o,'package.kappl');    kappl = kappl(index);
         kappl = uscore(kappl{j});

         lage = cache(o,'package.lage');    lage = lage(index);
         lage = lage(j);

         vcut = cache(o,'package.vcut');    vcut = vcut(index);
         vcut = vcut(j);

         vseek = cache(o,'package.vseek');    vseek = vseek(index);
         vseek = vseek(j);
      catch
         number = NaN;  station = '';  damping = '';  kappl = '';
         lage = NaN;  vcut = NaN;  vseek = NaN;
      end
      
      objid = sprintf(' %s.%g',get(o,{'package',''}),number);
      txt2 = sprintf([' station:%s, damping:%s, kappl:%s, lage:%g, ',...
                      'vcut:%g, vseek:%g  %s'],...
                       station,damping,kappl,lage,vcut,vseek, txt0);
      
      if (m < 20)
         txt1 = [objid,':  ',txt1];
         hdl1 = text(x,y+3*ru,txt1);
         col = o.iif(dark(o),'w','k');

         hdl2 = text(x,y-3*ru,txt2);
         col = o.iif(dark(o),'w','k');

         set(hdl1,'Horizontal','left','Vertical','mid','Color',o.color('yyk'));   
         set(hdl2,'Horizontal','left','Vertical','mid','Color',col);

         hdl = [hdl1(:); hdl2(:)];
         FontSize(o,m,hdl);         % set proper font size
      else
         txt = [objid,txt2];
         hdl = text(x,y,txt);
         col = o.iif(dark(o),'w','k');

         set(hdl,'Horizontal','left','Vertical','mid','Color',col);
         FontSize(o,m,hdl);         % set proper font size
      end
 end
   function [o,m,xlim] = Begin(o,sub)  % Begin Graphics                
      assert(container(o));            % make sure we deal with shell obj
   
         % for each package we need rows for objects plus package heading

      m = 0;
      xlim = [0 0];
     
         % loop through object list and take action for package objects
         
      for (i=1:length(o.data))
         oo = inherit(o.data{i},o);
         if type(oo,{'pkg'})
            [oo,bag,rfr] = cache(oo,oo,'spec');
            [oo,bag,rfr] = cache(oo,oo,'package');
            
               % get basket indices, store as var in object
               % and refresh container list
               
            index = basket(oo,'Index');
            oo = var(oo,'index',index);
            o.data{i} = oo;
            
               % if index is not empty then add update line count (m)
               % by adding required line numbers
               
            if ~isempty(index)
               m = m + length(index) + 1;
            end

               % calculate xmin and xmax
               
            xmin = -1;  xmax = 1;
            
            if (index)
               cpk = o.iif(strong,bag.cpks(index),bag.cpkw(index));
               mgr = o.iif(strong,bag.mgrs(index),bag.mgrw(index));
               chk = bag.chk(index);

               %facettes = bag.facettes;
               %objects = bag.objects;

               xmax = 3*max([max(cpk),max(mgr),max(chk),1]);
            end
            
            xlim = [min(xlim(1),xmin), max(xlim(2),xmax)];
         end
      end
      
         % begin graphics
         
      subplot(o,sub);
      plot(o,xlim,[0 m+1],'w.');

      set(gca,'Ytick',[]);             % no yticks
      set(gca,'Xlim',[xmin xmax], 'Ylim',[0.5 m+0.5]);
   end
   function End(o)                     % End Graphics                  
      package = get(o,{'package',''});
      title(['Magnitude Reserve (Mgr), Process Capability (Cpk)',...
             ' & Harmonic Capability (Chk)']);
      ylabel('Chk (green),  Cpk (gold),  Mgr (red)');

      txt = Project(o);
      heading(o,txt);
   end
end
function o = PkgMetrics(o)             % Plot Package Metricss         
   if ~type(o,{'pkg'})                 
      plot(o,'About');
      return                           % bye!
   end
   
   package = get(o,{'package',''});
   [o,bag,rfr] = cache(o,o,'spec');
   [o,bag,rfr] = cache(o,o,'package');
      
      % plot Cpk and Mgr (magnitude reserve)
         
   PlotMetrics(o,[1 1 1]);             % plot magnitude reserve & Cpk

   function PlotMetrics(o,sub)         % Plot Magnitude Reserve & Cpk  
      uscore = util(o,'uscore');       % short hand
      subplot(sub(1),sub(2),sub(3));

      [o,bag,rfr] = cache(o,'package');
      index = basket(o,'Index');
      o = var(o,'index',index);        % need in Text()
      
      cpk = o.iif(spec(o)<=1,bag.cpks(index),bag.cpkw(index));
      mgr = o.iif(spec(o)<=1,bag.mgrs(index),bag.mgrw(index));
      chk = bag.chk(index);
      facettes = bag.facettes(index);
      
      if (index)
         objects = bag.objects(index);
      else
         objects = {};
      end

         % start plotting
         
      xmax = 3*max([max(cpk),max(mgr),max(chk),1]);
      xmin = -1;
      plot([xmin xmax],[0 length(cpk)+1],'w.');
      dark(o,'Axes');
      
      m = length(index);  
      ru = 0.05;                          % graphical raster unit

      if (m > 0)
         set(gca,'Ytick',[]);             % no yticks
         set(gca,'Xlim',[xmin xmax], 'Ylim',[0.5 length(cpk)+0.5]);
      end
      
      for (i=1:m)
         y = m+1-i;
         PlotBar(o,mgr(i),[y+3*ru,y+7*ru],'r');
         PlotBar(o,cpk(i),[y-2*ru,y+2*ru],'ryyy');
         PlotBar(o,chk(i),[y-3*ru,y-7*ru],'ggk');

         PlotFacettes(o,facettes(i),[y-7*ru,y+7*ru],'wk');

         x0 = max([cpk(i),mgr(i),chk(i)]);
         Text(o,m,i,x0,y,ru, objects{i},mgr(i),cpk(i),chk(i));
         
         
         %x0 = max(cpk(i),mgr(i));
         %txt = sprintf('  %s (Mgr: %g, Cpk: %g, Chk: %g)',uscore(objects{i}),...
         %              o.rd(mgr(i),2), o.rd(cpk(i),2), o.rd(chk(i),2));
         %hdl = text(x0,k,txt);
         %col = o.iif(dark(o),'w','k');
         %set(hdl,'Horizontal','left','Vertical','mid','Color',col);
         %FontSize(o,m,hdl);            % set proper font size
     end

      hdl = plot(o,[1 1],get(gca,'Ylim'),'c-.');
      set(hdl,'Linewidth',opt(o,{'spec.linewidth',1}));

      package = get(o,{'package',''});
      title(['Magnitude Reserve (Mgr), Process Capability (Cpk)',...
             ' & Harmonic Capability (Chk)']);
      ylabel('Chk (green),  Cpk (gold),  Mgr (red)');

      heading(o);
   end
   function OldText(o,m,j,x,y,ru,objs,mgr,cpk,chk)
      uscore = util(o,'uscore');       % short hand
      name = uscore(objs);

      txt0 = sprintf('(Mgr: %g, Cpk: %g, Chk: %g)',...
                     o.rd(mgr,2), o.rd(cpk,2), o.rd(chk,2));
      txt1 = [' ',name];
      
         % get other data
         
      try
         index = var(o,'index');

         number = cache(o,'package.number');    number = number(index);
         number = number(j);

         station = cache(o,'package.station');  station = station(index);
         station = uscore(station{j});

         damping = cache(o,'package.damping');  damping = damping(index);
         damping = uscore(damping{j});

         kappl = cache(o,'package.kappl');    kappl = kappl(index);
         kappl = uscore(kappl{j});

         lage = cache(o,'package.lage');    lage = lage(index);
         lage = lage(j);

         vcut = cache(o,'package.vcut');    vcut = vcut(index);
         vcut = vcut(j);

         vseek = cache(o,'package.vseek');    vseek = vseek(index);
         vseek = vseek(j);
      catch
         number = NaN;  station = '';  damping = '';  kappl = '';
         lage = NaN;  vcut = NaN;  vseek = NaN;
      end
      
      objid = sprintf(' %s.%g',get(o,{'package',''}),number);
      txt2 = sprintf([' station:%s, damping:%s, kappl:%s, lage:%g, ',...
                      'vcut:%g, vseek:%g  %s'],...
                       station,damping,kappl,lage,vcut,vseek, txt0);
      
      if (m < 20)
         txt1 = [objid,':  ',txt1];
         hdl1 = text(x,y+3*ru,txt1);
         col = o.iif(dark(o),'w','k');

         hdl2 = text(x,y-3*ru,txt2);
         col = o.iif(dark(o),'w','k');

         set(hdl1,'Horizontal','left','Vertical','mid','Color',o.color('yyk'));   
         set(hdl2,'Horizontal','left','Vertical','mid','Color',col);

         hdl = [hdl1(:); hdl2(:)];
         FontSize(o,m,hdl);         % set proper font size
      else
         txt = [objid,txt2];
         hdl = text(x,y,txt);
         col = o.iif(dark(o),'w','k');

         set(hdl,'Horizontal','left','Vertical','mid','Color',col);
         FontSize(o,m,hdl);         % set proper font size
      end
  end
end
function o = CutMetrics(o)             % Plot Cut Object Metrics       
   if ~type(o,{'cut'})                 
      plot(o,'About');
      return                           % bye!
   end

   oo = current(o);
   oo = opt(oo,'select.facette',0);
   PlotAcceleration(oo);
   
   function PlotAcceleration(o)
      o = opt(o,'metrics',false);
      
      t = cook(o,':');
      a1 = cook(o,'a1');               % fetch cutting acceleration 1
      a2 = cook(o,'a2');               % fetch cutting acceleration 2
      a3 = cook(o,'a3');               % fetch cutting acceleration 3
      a = cook(o,'a');                 % fetch cutting acceleration 3

      PlotMetrics(oo,[4 1 1]);

      diagram(o,'A1',t,a1,[4 4 5]);
      diagram(o,'A2',t,a2,[4 4 6]);
      diagram(o,'A3',t,a3,[4 4 7]);
      diagram(o,'A',t,a,[4 4 8]);
      
      diagram(o,'A12',a1,a2,[2 3 4]);
      diagram(o,'A13',a1,a3,[2 3 5]);
      diagram(o,'A23',a2,a3,[2 3 6]);
   end
   function PlotMetrics(o,sub)         % Plot Magnitude Reserve & Cpk  
      uscore = util(o,'uscore');       % short hand
      subplot(sub(1),sub(2),sub(3));

      %[o,bag,rfr] = cache(o,'package');
      [cpks,cpkw,mgrs,mgrw,mgn,sig,avg] = cpk(o,'a');
      %index = basket(o,'Index');
      o = var(o,'index',[1]);          % needed for Text()
      [~,chk] = thdr(oo);
      
      Cpk = o.iif(spec(o)<=1,cpks,cpkw);
      mgr = o.iif(spec(o)<=1,mgrs,mgrw);
      facettes = cluster(o,inf);
      
      objects = {get(o,{'title',''})};

         % start plotting
         
      xmax = 3*max([max(Cpk),max(mgr),max(chk),1]);
      xmin = -1;
      plot([xmin xmax],[0 length(Cpk)+1],'w.');
      dark(o,'Axes');
      
      m = 1;  
      ru = 0.05;                       % graphical raster unit

      if (m > 0)
         set(gca,'Ytick',[]);          % no yticks
         set(gca,'Xlim',[xmin xmax], 'Ylim',[0.5 length(Cpk)+0.5]);
      end
      
      for (i=1:m)
         y = m+1-i;
         PlotBar(o,mgr(i),[y+3*ru,y+7*ru],'r');
         PlotBar(o,Cpk(i),[y-2*ru,y+2*ru],'ryyy');
         PlotBar(o,chk(i),[y-3*ru,y-7*ru],'ggk');

         PlotFacettes(o,facettes(i),[y-7*ru,y+7*ru],'wk');

         x0 = max([Cpk(i),mgr(i),chk(i)]);
         Text(o,m,i,x0,y,ru, objects{i},mgr(i),Cpk(i),chk(i));
         
         %x0 = max(Cpk(i),mgr(i));
         %txt = sprintf('  %s (Mgr: %g, Cpk: %g, Chk: %g)',uscore(objects{i}),...
         %              o.rd(mgr(i),2), o.rd(Cpk(i),2), o.rd(chk(i),2));
         %hdl = text(x0,k,txt);
         %col = o.iif(dark(o),'w','k');
         %set(hdl,'Horizontal','left','Vertical','mid','Color',col);
         %FontSize(o,m,hdl);            % set proper font size
     end

      hdl = plot(o,[1 1],get(gca,'Ylim'),'c-.');
      set(hdl,'Linewidth',opt(o,{'spec.linewidth',1}));

      package = get(o,{'package',''});
      title(['Magnitude Reserve (Mgr), Process Capability (Cpk)',...
             ' & Harmonic Capability (Chk)']);
      ylabel('Chk (g), Cpk (y), Mgr (r)');

      heading(o);
   end
end
function PlotBar(o,len,pos,col)        % Plot a Bar                    
   x = [0 len len 0 0];
   y = [pos(1) pos(1) pos(2) pos(2) pos(1)];
   hdl = patch(x,y,o.color(col));
   hold on;
end
function PlotFacettes(o,nf,pos,col)    % Plot a Bar                    
   y = [pos(1) pos(2)];
   for (i=1:nf)
      plot(o,-i*0.1*[1 1],[pos(1) pos(2)],'wk2');
      hold on;
   end
end
function FontSize(o,m,hdl,delta)       % Set Font Size                 
   if (nargin < 4)
      delta = 0;
   end
   if (m <= 10)
      set(hdl,'FontSize',12+delta);
   elseif (m <= 20)
      set(hdl,'Fontsize',11+delta);
   elseif (m <= 40)
      set(hdl,'Fontsize',10+delta);
   elseif (m <= 60)
      set(hdl,'Fontsize',8+delta);
   else
      set(hdl,'Fontsize',6+delta);
   end
end
function Text(o,m,j,x,y,ru,objs,mgr,cpk,chk)                           
   uscore = util(o,'uscore');          % short hand
   name = uscore(objs);

   txt0 = sprintf('Mgr: %g, Cpk: %g, Chk: %g',...
                  o.rd(mgr,2), o.rd(cpk,2), o.rd(chk,2));
   txt1 = [' ',name];

      % get other data

   try
      index = var(o,'index');

      number = cache(o,'package.number');    number = number(index);
      number = number(j);

      station = cache(o,'package.station');  station = station(index);
      station = uscore(station{j});

      damping = cache(o,'package.damping');  damping = damping(index);
      damping = uscore(damping{j});

      kappl = cache(o,'package.kappl');    kappl = kappl(index);
      kappl = uscore(kappl{j});

      lage = cache(o,'package.lage');    lage = lage(index);
      lage = lage(j);

      vcut = cache(o,'package.vcut');    vcut = vcut(index);
      vcut = vcut(j);

      vseek = cache(o,'package.vseek');    vseek = vseek(index);
      vseek = vseek(j);
   catch
      number = NaN;  station = '';  damping = '';  kappl = '';
      lage = NaN;  vcut = NaN;  vseek = NaN;
      
      if type(o,{'cut'})
         number = get(o,{'number',NaN});
         station = get(o,{'station',''});
         damping = get(o,{'damping',''});
         kappl = get(o,{'kappl',''});
         lage = get(o,{'lage',NaN});
         vcut = get(o,{'vcut',NaN});
         vseek = get(o,{'vseek',NaN});
      end
   end

   objid = sprintf(' %s.%g',get(o,{'package',''}),number);
   txt3 = sprintf([' station:%s, damping:%s, kappl:%s, lage:%g, ',...
                   'vcut:%g, vseek:%g'],...
                    station,damping,kappl,lage,vcut,vseek);
   txt2 = [' ',txt3,' (',txt0,')'];

   col = o.iif(dark(o),'w','k');
   
   if (m == 1)
      txt1 = [objid,':  ',txt1];
      
      hdl1 = text(x,y+5*ru,[' ',txt0]);
      hdl2 = text(x,y+0*ru,['',txt1]);
      hdl3 = text(x,y-5*ru,[' ',txt3]);

      set(hdl1,'Horizontal','left','Vertical','mid','Color',col);
      set(hdl2,'Horizontal','left','Vertical','mid','Color',o.color('yyk'));   
      set(hdl3,'Horizontal','left','Vertical','mid','Color',col);

      hdl = [hdl1(:); hdl2(:); hdl3(:)];
      FontSize(o,m,hdl);         % set proper font size
   elseif (m < 20)
      txt1 = [objid,':  ',txt1];
      
      hdl1 = text(x,y+3*ru,txt1);
      hdl2 = text(x,y-3*ru,txt2); 

      set(hdl1,'Horizontal','left','Vertical','mid','Color',o.color('yyk'));   
      set(hdl2,'Horizontal','left','Vertical','mid','Color',col);

      hdl = [hdl1(:); hdl2(:)];
      FontSize(o,m,hdl);         % set proper font size
   else
      txt = [objid,txt2];
      hdl = text(x,y,txt);

      set(hdl,'Horizontal','left','Vertical','mid','Color',col);
      FontSize(o,m,hdl);         % set proper font size
   end
end
function txt = Project(o)              % Get Project(s) Text           
   if ~container(o)
      txt = 'Metrics - Project Overview';
      return
   end
   uscore = util(o,'uscore');          % short hand
   
   projects = {};
   sep = '';  txt = '';
   for (i=1:length(o.data))
      oo = o.data{i};
      project = get(oo,{'project',''});
      
      if ~isempty(project) && ~o.is(project,projects)
         projects{end+1} = project;
         txt = [txt,sep,project]; sep = ', ';
      end
   end
   
   if isempty(txt)
      txt = 'Metrics - Project Overview';
   elseif (length(projects) == 1)
      txt = ['Metrics Overview - Project: ',txt];
   else
      txt = ['Metrics Overview - Projects: ',txt];
   end
   
      % add some heading tail
      
   tail = opt(o,'view.heading');
   if (~isempty(tail) && ~all(tail==' '))
      txt = [txt,'  (',tail,')'];
   end
end

%==========================================================================
% Helper
%==========================================================================

function bdx = Chunk(o,idx,n,i)                                        
   i1 = 0;
   L = length(idx);
   delta = L/n;
   
   for (j=1:i)
      i0 = i1+1;
      i1 = ceil(i0+delta);
   end
   i1 = min(i1,L);
   bdx = i0:i1;
   
   assert(all(bdx<=L));
end
function SpecLimits(o,positive)                                        
   
   mode = opt(o,{'specs.display',1});  % display mode
   if (~mode)
      return     % don't show spec limits
   end
   
   kind = opt(o,{'kind',''});
   switch kind
      case {'A','a'}
         spec = opt(o,{'specs.a',[25 100]});
      case {'V','v'}
         spec = opt(o,{'specs.a',[25 100]});
      case {'S','s'}
         spec = opt(o,{'specs.a',[25 100]});
      otherwise
         return
   end
   strong = spec(1);
   weak  = spec(2);
   limit = [];                         % so far limit is deactivated
   
   oo = corazon(o);
   if (kind == upper(kind))            % circular
      phi = 0:pi/100:2*pi;
      hold on;
      plot(strong*cos(phi),strong*sin(phi),'k');
      plot(weak *cos(phi), weak*sin(phi),'k');
      
      if (mode == 2)
         plot([0 0],bad*[-1.2 1.2],'k');
         plot(bad*[-1.2 1.2],[0 0],'k');
      end

      if (length(limit) > 0 && prod(limit) ~= 0)
         set(gca,'xlim',limit, 'ylim',limit);
      end
      set(gca,'DataaspectRatio',[1 1 1])
   else
      xlim = get(gca,'xlim');
      plot(oo,xlim,+strong*[1 1],'c-.');
      plot(oo,xlim,-strong*[1 1],'c-.');
      set(gca,'ylim',strong*6/5*[-1 1]);
      
      if (mode == 2)
         plot(oo,xlim, +weak*[1 1],'c-.');
         plot(oo,xlim, -weak*[1 1],'c-.');
      end
      
      if (nargin >=2 && positive)
         limit(1) = -0.0001;
      end
      if (length(limit) > 0 && prod(limit) ~= 0)
         set(gca,'ylim',limit);
      end
   end
end
function list = Basket(o,tag,value)    % Get Basket List               
   list = {};
   for (i=1:length(o.data))
      oo = o.data{i};      
      if type(oo,{'cut'}) 
         if isequal(get(oo,{tag,''}),value)
            list{end+1} = oo;
         end
      end
   end   
end
function Stretch(o)                    % Stretch Orbit Plot            
   ylim = get(gca,'Ylim');
   set(gca,'Xlim',ylim*1.5);
   shelf(o,gca,'closeup',0);           % prevent from closeup control
end
