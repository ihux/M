function oo = analyse(o,varargin)      % Graphical Analysis            
%
% ANALYSE   Graphical analysis
%
%    Plenty of graphical analysis functions
%
%       analyse(o)                % analyse @ opt(o,'mode.analyse')
%
%       oo = analyse(o,'menu')    % setup Analyse menu
%       oo = analyse(o,'Surf')    % surface plot
%       oo = analyse(o,'Histo')   % display histogram
%
%    See also: SPM, PLOT, STUDY
%
   [gamma,o] = manage(o,varargin,@Err,@Menu,@WithCuo,@WithSho,@WithBsk,...
                      @Trf,@TfOverview,...
                      @Overview,@Rloc,@Nyq,@OpenLoop,@Calc,...
                      @AnalyseRamp,@NormRamp,...
                      @BodePlots,@StepPlots,@PolesZeros);
   oo = gamma(o);                 % invoke local function
end

%==========================================================================
% Menu Setup & Common Menu Callback
%==========================================================================

function oo = Menu(o)                  % Setup Analyse Menu            
   oo = mitem(o,'Closed Loop');
   ooo = mitem(oo,'Bode Plots',{@WithCuo,'BodePlots'});
   ooo = mitem(oo,'Step Responses',{@WithCuo,'StepPlots'});
   ooo = mitem(oo,'Poles & Zeros',{@WithCuo,'PolesZeros'});

   oo = Stability(o);                  % add stability menu

   ooo = mitem(oo,'-'); 
   oo = Force(o);                      % add Force menu
   oo = Acceleration(o);               % add Acceleration menu
   oo = Velocity(o);                   % add Velocity menu
   oo = Elongation(o);                 % add Elongation menu
   
   oo = mitem(o,'-');
   %oo = CriticalMenu(o);
   oo = mitem(o,'Normalized System');
   %enable(ooo,type(current(o),types));
   ooo = mitem(oo,'Force Ramp @ F2',{@WithCuo,'NormRamp'},2);
end
function oo = Stability(o)             % Closed Loop Stability         
   oo = mitem(o,'Stability');
   ooo = mitem(oo,'Root Locus',{@WithCuo,'Rloc'});
   ooo = mitem(oo,'Nyquist',{@WithCuo,'Nyq'});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'L1(s): Open Loop',{@WithCuo,'OpenLoop','L1',1,'c'});
   ooo = mitem(oo,'L1(s): Calculation',{@WithCuo,'Calc','L1',1,'c'});
end
function oo = Force(o)                 % Closed Loop Force Menu        
   oo = mitem(o,'Force');
   sym = 'Tf';  sym1 = 'Tf1';  sym2 = 'Tf2';  col = 'yyyr';  

   ooo = mitem(oo,'Overview',{@WithCuo,'Overview',sym1,sym2,col});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Tf(s)',{@WithCuo,'Trf',sym,0,col});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Tf1(s)',{@WithCuo,'Trf',sym1,1,col});
   ooo = mitem(oo,'Tf2(s)',{@WithCuo,'Trf',sym2,2,col});
end
function oo = Acceleration(o)          % Closed Loop Acceleration Menu 
   oo = mitem(o,'Acceleration');
   sym = 'Ta';  sym1 = 'Ta1';  sym2 = 'Ta2';  col = 'r';

   ooo = mitem(oo,'Overview',{@WithCuo,'Overview',sym1,sym2,col});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Ta(s)',{@WithCuo,'Trf',sym,0,col});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Ta1(s)',{@WithCuo,'Trf',sym1,1,col});
   ooo = mitem(oo,'Ta2(s)',{@WithCuo,'Trf',sym2,2,col});
end
function oo = Velocity(o)              % Closed Loop Velocity Menu     
   oo = mitem(o,'Velocity');
   sym = 'Tv';  sym1 = 'Tv1';  sym2 = 'Tv2';  col = 'bc';  

   ooo = mitem(oo,'Overview',{@WithCuo,'Overview',sym1,sym2,col});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Tv(s)',{@WithCuo,'Trf',sym,0,col});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Tv1(s)',{@WithCuo,'Trf',sym1,1,col});
   ooo = mitem(oo,'Tv2(s)',{@WithCuo,'Trf',sym2,2,col});
end
function oo = Elongation(o)            % Closed Loop Elongation Menu   
   oo = mitem(o,'Elongation');
   sym = 'Ts';  sym1 = 'Ts1';  sym2 = 'Ts2';  col = 'g';  

   ooo = mitem(oo,'Overview',{@WithCuo,'Overview',sym1,sym2,col});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Ts(s)',{@WithCuo,'Trf',sym,0,col});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Ts1(s)',{@WithCuo,'Trf',sym1,1,col});
   ooo = mitem(oo,'Ts2(s)',{@WithCuo,'Trf',sym2,2,col});
end

function oo = OldCriticalMenu(o)       % Critical Path Menu            
   oo = mitem(o,'Critical Path');
   ooo = mitem(oo,'Overview',{@Overview});
   
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'F3 -> y3:  G33(s)',{@plot,'WithCuo','Gs',3,3});
   ooo = mitem(oo,'y3 -> F3:  H33(s)',{@plot,'WithCuo','Hs',3,3});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'F1 -> y3:  G31(s)',{@plot,'WithCuo','Gs',3,1});
   ooo = mitem(oo,'F1 -> y3:  H31(s) = -G31(s)*H33(s)',...
                                      {@plot,'WithCuo','Hs',3,1});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'F1 -> y3:  L51(s) = H31(s)',{@plot,'WithCuo','Ls',5,1});
   ooo = mitem(oo,'-');
end

%==========================================================================
% Launch Callbacks
%==========================================================================

function oo = WithSho(o)               % 'With Shell Object' Callback  
%
% WITHSHO General callback for operation on shell object
%         with refresh function redefinition, screen
%         clearing, current object pulling and forwarding to executing
%         local function, reporting of irregularities, dark mode support
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
% WITHCUO A general callback with refresh function redefinition, screen
%         clearing, current object pulling and forwarding to executing
%         local function, reporting of irregularities, dark mode support
%
   refresh(o,o);                       % remember to refresh here
   cls(o);                             % clear screen
 
   oo = current(o);                    % get current object
   if ~type(oo,{'spm'})
      plot(oo,'About');
      return
   end
   
      % refresh caches
      
   [oo,bag,rfr] = cache(oo,oo,'trf');  % transfer function cache segment
   [oo,bag,rfr] = cache(oo,oo,'consd');% constrained trf cache segment
   [oo,bag,rfr] = cache(oo,oo,'process'); % process cache segment
   
   gamma = eval(['@',mfilename]);
   oo = gamma(oo);                     % forward to executing method

   if isempty(oo)                      % irregulars happened?
      oo = set(o,'comment',...
                 {'No idea how to plot object!',get(o,{'title',''})});
      message(oo);                     % report irregular
   else
      dark(oo);                        % do dark mode actions
   end
end
function oo = WithBsk(o)               % 'With Basket' Callback        
%
% WITHBSK  Plot basket, or perform actions on the basket, screen clearing, 
%          current object pulling and forwarding to executing local func-
%          tion, reporting of irregularities and dark mode support
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

function o = Err(o)                    % Error Handler                 
   error('bad mode');
end

%==========================================================================
% Root Locus
%==========================================================================

function o = Rloc(o)                   % Root Locus                    
   o = with(o,'rloc');
   o = with(o,'style');
   
   sym = 'L1';
   L1 = cook(o,sym);   
   [num,den] = peek(L1);
   
   mu = opt(o,{'process.mu',0.1});
   
   oo = system(inherit(corasim,o),{-mu*num,den});
   
   subplot(o,111);
   rloc(oo);
   title(sprintf('Root Locus %s(s) - mu = %g',sym,mu));
   
   heading(o);
end
function oo = Nyq(o)                   % Nyquist Plot                  
   o = with(o,'style');
   mu = opt(o,{'process.mu',0.1});
   
   L1 = cook(o,'L1');      
   oo = (-mu)*L1;
   sym = 'L0(s) = mu*L1(s)';
   
   o = with(o,'bode');
   o = opt(o,'color','ccb');
   o = diagram(o,'Bode',sym,oo,2211);
   
   o = with(o,'nyq');
   o = opt(o,'color','ccb');
   oo = diagram(o,'Nyq',sym,oo,1212);
   xlabel(sprintf('Friction Coefficient: mu = %g',mu));
   
   if control(o,'verbose') > 0
      display(o);   
   end
   
   heading(o);
end
function o = OpenLoop(o)               % L(s) Open Loop                
   o = with(o,'bode');
   o = with(o,'simu');
   o = with(o,'rloc');

   sym = arg(o,1);
   idx = arg(o,2);
   col = arg(o,3);
   
   oo = cook(o,sym);
   o = opt(o,'color',col);
   sym = [sym,'(s)'];
   
   if (idx == 0)
      diagram(o,'Trf',sym,oo,111);
   else
      title = [sym,': Open Loop Transfer Function'];
      diagram(o,'Trf', sym,oo,3111,title);
      diagram(o,'Step',sym,oo,3221);
      diagram(o,'Rloc',sym,oo,3222);
      diagram(o,'Bode',sym,oo,3231);
      diagram(o,'Nyq',sym,oo,3232);
   end
   
   display(oo);
   heading(o);
end
function o = Calc(o)                   % Calculation of L(s)           
   sym = arg(o,1);
   idx = arg(o,2);
   col = arg(o,3);
   
   oo = cook(o,sym);
   o = opt(o,'color',col);
   sym = [sym,'(s)'];
   
   diagram(o,'Calc',sym,oo,4312);

   diagram(o,'Bode',sym,oo,4321);
   diagram(o,'Step',sym,oo,4322);
   diagram(o,'Rloc',sym,oo,4323);
   
   switch sym
      case 'L1(s)'
         sym = 'G31';
      case 'L2(s)'
         sym = 'G32';
      otherwise
         return
   end
   o = opt(o,'color','g')
   
      % G31(s) or G32(s) diagrams
      
   oo = cook(o,sym);
   sym = [sym,'(s)'];
   
   diagram(o,'Bode',sym,oo,4331);
   diagram(o,'Step',sym,oo,4332);
   diagram(o,'Rloc',sym,oo,4333);

      % G33(s) diagrams

   sym = 'G33';
   oo = cook(o,sym);
   sym = [sym,'(s)'];
   
   diagram(o,'Bode',sym,oo,4341);
   diagram(o,'Step',sym,oo,4342);
   diagram(o,'Rloc',sym,oo,4343);
     
   display(oo);
   heading(o);
end

%==========================================================================
% Closed Loop
%==========================================================================

function o = BodePlots(o)              % Closed Loop Bode Plots        
   [Tf1,Tf2] = cook(o,'Tf1,Tf2');
   
   o = opt(o,'color','yyr');
   diagram(o,'Bode','Tf1(s)',Tf1,[4 2 1 1]);
   diagram(o,'Bode','Tf2(s)',Tf2,[4 2 1 2]);

   [Ts1,Ts2] = cook(o,'Ts1,Ts2');
   
   o = opt(o,'color','g');
   diagram(o,'Bode','Ts1(s)',Ts1,[4 2 2 1]);
   diagram(o,'Bode','Ts2(s)',Ts2,[4 2 2 2]);
   
   [Tv1,Tv2] = cook(o,'Tv1,Tv2');
   
   o = opt(o,'color','bc');
   diagram(o,'Bode','Tv1(s)',Tv1,[4 2 3 1]);
   diagram(o,'Bode','Tv2(s)',Tv2,[4 2 3 2]);

   [Ta1,Ta2] = cook(o,'Ta1,Ta2');
   
   o = opt(o,'color','r');
   diagram(o,'Bode','Ta1(s)',Ta1,[4 2 4 1]);
   diagram(o,'Bode','Ta2(s)',Ta2,[4 2 4 2]);
   
   heading(o);
end
function o = StepPlots(o)              % Closed Loop Step Plots        
   o = with(o,'simu');
   
   [Tf1,Tf2] = cook(o,'Tf1,Tf2');
   o = opt(o,'color','yyr');
   diagram(o,'Fstep','Tf1(s)',Tf1,4211);
   diagram(o,'Fstep','Tf2(s)',Tf2,4212);

   [Ts1,Ts2] = cook(o,'Ts1,Ts2');
   o = opt(o,'color','g');
   diagram(o,'Step','Ts1(s)',Ts1,4221);
   diagram(o,'Step','Ts2(s)',Ts2,4222);
   
   [Tv1,Tv2] = cook(o,'Tv1,Tv2');
   o = opt(o,'color','bc');
   diagram(o,'Vstep','Tv1(s)',Tv1,4231);
   diagram(o,'Vstep','Tv2(s)',Tv2,4232);
   
   
   [Ta1,Ta2] = cook(o,'Ta1,Ta2');
   o = opt(o,'color','r');
   diagram(o,'Astep','Ta1(s)',Ta1,4241);
   diagram(o,'Astep','Ta2(s)',Ta2,4242);
   
   heading(o);
end
function o = PolesZeros(o)             % Closed Loop Poles & Zeros     
   o = with(o,'simu');
   
   [Tf1,Tf2] = cook(o,'Tf1,Tf2');
   o = opt(o,'color','yyr');
   diagram(o,'Rloc','Tf1(s)',Tf1,4211);
   diagram(o,'Rloc','Tf2(s)',Tf2,4212);

   [Ts1,Ts2] = cook(o,'Ts1,Ts2');
   o = opt(o,'color','g');
   diagram(o,'Rloc','Ts1(s)',Ts1,4221);
   diagram(o,'Rloc','Ts2(s)',Ts2,4222);
   
   [Tv1,Tv2] = cook(o,'Tv1,Tv2');
   o = opt(o,'color','bc');
   diagram(o,'Rloc','Tv1(s)',Tv1,4231);
   diagram(o,'Rloc','Tv2(s)',Tv2,4232);
   
   
   [Ta1,Ta2] = cook(o,'Ta1,Ta2');
   o = opt(o,'color','r');
   diagram(o,'Rloc','Ta1(s)',Ta1,4241);
   diagram(o,'Rloc','Ta2(s)',Ta2,4242);
   
   heading(o);
end

%==========================================================================
% Closed Loop Force
%==========================================================================

function o = Overview(o)              % Closed Loop Overview           
   o = with(o,'bode');
   o = with(o,'simu');
   o = with(o,'rloc');
   
   sym1 = arg(o,1)
   sym2 = arg(o,2)
   col = arg(o,3);

   o = opt(o,'color',col);
   o1 = cook(o,sym1);
   o2 = cook(o,sym2);
   
   sym1 = [sym1,'(s)'];
   sym2 = [sym2,'(s)'];
   
   diagram(o,'Bode',sym1,o1,3211);
   diagram(o,'Bode',sym2,o2,3212);

   diagram(o,'Fstep',sym1,o1,3221);
   diagram(o,'Fstep',sym2,o2,3222);

   diagram(o,'Rloc',sym1,o1,3231);
   diagram(o,'Rloc',sym2,o2,3232);

   heading(o);
end
function o = Trf(o)                   % Transfer Function              
   o = with(o,'bode');
   o = with(o,'simu');
   o = with(o,'rloc');

   sym = arg(o,1);
   idx = arg(o,2);
   col = arg(o,3);
   
   oo = cook(o,sym);
   o = opt(o,'color',col);
   sym = [sym,'(s)'];
   oo = set(oo,'name',sym);
   
   if (idx == 0)
      diagram(o,'Trf',sym,oo,111);
   else
      diagram(o,'Trf', sym,oo,3111);
      diagram(o,'Bode',sym,oo,3221);
      diagram(o,'Rloc',sym,oo,3222);
      diagram(o,'Step',sym,oo,3131);
   end
   
   display(oo);
   heading(o);
end

%==========================================================================
% Analyse Menu Plugins
%==========================================================================

function o = NormRamp(o)               % Normalized System's Force Ramp
   if ~type(o,{'spm'})
      plot(o,'About');
      return
   end
   
      % fetch some simulation parameters
      
   index = arg(o,1);                   % get force component index
   Fmax = opt(o,{'Fmax',100});

      % transform system
      
   o = brew(o,'Normalize');
   [A,B,C,D]=get(o,'system','A,B,C,D');% for debug

   oo = type(corasim(o),'css');        % cast and change type
   t = Time(oo);
   u = RampInput(oo,t,index,Fmax);
   
   oo = sim(oo,u,[],t);
   PlotY(oo);
   
   heading(o,sprintf('Analyse Force Ramp: F%g->y - %s',index,Title(o)));
end

%==========================================================================
% Helper
%==========================================================================

function title = Title(o)              % Get Object Title              
   title = get(o,{'title',[class(o),' object']});
   
   dir = get(o,'dir');   
   idx = strfind(dir,'@');
   if ~isempty(dir)
      [package,typ,name] = split(o,dir(idx(1):end));
      title = [title,' - [',package,']'];
   end
end
function t = Time(o)                   % Get Time Vector               
   T = opt(o,{'simu.dt',0.00005});
   tmax = opt(o,{'simu.tmax',0.01});
   t = 0:T:tmax;
end
function oo = Corasim(o)               % Convert To Corasim Object     
   oo = type(cast(o,'corasim'),'css');
   [A,B,C,D] = data(o,'A,B,C,D');
   oo = system(oo,A,B,C,D);
end
function u = StepInput(o,t,index,Fmax) % Get Step Input Vector         
%
% STEPINPUT   Get step input vector (and optional time vector)
%
%                u = StepInput(o,t,index)
%                u = StepInput(o,t,index,Fmax)
%
   if (nargin < 4)
      Fmax = 1;
   end
   
   [~,m] = size(o);                   % number of inputs

   if (index > m)
      title = sprintf('Output #%g not supported!',index);
      comment = {sprintf('number of outputs: %g',m)};
      message(o,title,comment);
      error(title);
      return
   end

   I = eye(m);
   u = Fmax * I(:,index)*ones(size(t));
end
function u = RampInput(o,t,index,Fmax) % Get Ramp Input Vector         
%
% RAMPINPUT   Get ramp input vector (and optional time vector)
%
%                u = RampInput(o,t,index)
%                u = RampInput(o,t,index,Fmax)
%
   if (nargin < 4)
      Fmax = max(t);
   end
   
   [~,m] = size(o);                   % number of inputs
   
   if (index > m)
      title = sprintf('Output #%g not supported!',index);
      comment = {sprintf('number of outputs: %g',m)};
      message(o,title,comment);
      error(title);
      return
   end
   
   I = eye(m);
   u = I(:,index)*t * Fmax/max(t);
end
