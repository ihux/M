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
                      @WithSpm,@Numeric,@Trf,@TfOverview,...
                      @LmuDisp,@LmuRloc,@LmuStep,@LmuBode,@LmuNyq,...
                      @LmuBodeNyq,@Overview,...
                      @Margin,@Rloc,@StabilityOverview,@OpenLoop,@Calc,...
                      @Damping,@Contribution,@NumericCheck,...
                      @SensitivityW,@SensitivityF,@SensitivityD,...
                      @AnalyseRamp,@NormRamp,@SimpleCalc,@Critical,...
                      @BodePlots,@StepPlots,@PolesZeros,...
                      @L0Magni,@LambdaMagni,@LambdaBode,...
                      @SetupAnalysis,...
                      @EigenvalueCheck);
   oo = gamma(o);                 % invoke local function
end

%==========================================================================
% Menu Setup & Common Menu Callback
%==========================================================================

function oo = Menu(o)                  % Setup Analyse Menu            
   switch type(current(o))
      case 'shell'
         oo = ShellMenu(o);
      case 'spm'
         oo = SpmMenu(o);
      case 'pkg'
         oo = PkgMenu(o);
      otherwise
         oo = mitem(o,'About',{@WithCuo,'About'});
   end
end
function oo = ShellMenu(o)             % Setup Plot Menu for SHELL Type
   oo = mitem(o,'Stability');
return;   
   ooo = mitem(oo,'Overview',{@WithCuo,'StabilityOverview'});
end
function oo = PkgMenu(o)               % Setup Plot Menu for Pkg Type  
   oo = Stability(o);
end
function oo = SpmMenu(o)               % Setup SPM Analyse Menu        
   oo = CriticalMenu(o);               % Add Critical menu
%  oo = Stability(o);                  % add Stability menu
   return
   
   oo = NumericMenu(o);                % add Numeric menu

   oo = mitem(o,'-'); 
   oo = OpenLoopMenu(o);               % add Open Loop menu
   oo = ClosedLoopMenu(o);             % add Closed Loop menu

   oo = mitem(o,'-'); 
   oo = Stability(o);                  % add Stability menu
   oo = Sensitivity(o);                % add Sensitivity menu
   
   oo = mitem(o,'-'); 
   oo = Spectrum(o);                   % add Spectrum menu
   oo = Setup(o);                      % add Setup menu
   
   oo = mitem(o,'-'); 
   oo = Force(o);                      % add Force menu
   oo = Acceleration(o);               % add Acceleration menu
   oo = Velocity(o);                   % add Velocity menu
   oo = Elongation(o);                 % add Elongation menu
   
   oo = mitem(o,'-');
   %oo = CriticalMenu(o);
   oo = mitem(o,'Normalized System');
   %enable(ooo,type(current(o),types));
   ooo = mitem(oo,'Force Ramp @ F2',{@WithCuo,'NormRamp'},2);
   
   oo = Precision(o);
end

function oo = NumericMenu(o)           % Numeric Menu                  
   oo = mitem(o,'Numeric');
   ooo = mitem(oo,'Numeric Quality of G(s)',{@WithSpm,'Numeric'});
end
function oo = OpenLoopMenu(o)          % Open Loop Menu                
   oo = mitem(o,'Open Loop');
   ooo = mitem(oo,'Overview',{@WithCuo,'OpenLoop','Lmu',1,'bcc'});
   ooo = mitem(oo,'Lmu(s)',{@WithCuo,'LmuDisp'});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Poles/Zeros',{@WithCuo,'LmuRloc'});
   ooo = mitem(oo,'Step Response',{@WithCuo,'LmuStep'});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Bode Plot',{@WithCuo,'LmuBode'});
   ooo = mitem(oo,'Nyquist Plot',{@WithCuo,'LmuNyq'});
   ooo = mitem(oo,'Bode/Nyquist',{@WithCuo,'LmuBodeNyq'});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Calculation',{@WithCuo,'Calc','L0',1,'bcc'});
end
function oo = ClosedLoopMenu(o)        % Closed Loop Menu              
   oo = mitem(o,'Closed Loop');
   ooo = mitem(oo,'Bode Plots',{@WithCuo,'BodePlots'});
   ooo = mitem(oo,'Step Responses',{@WithCuo,'StepPlots'});
   ooo = mitem(oo,'Poles & Zeros',{@WithCuo,'PolesZeros'});
end
function oo = CriticalMenu(o)          % Critical Menu                 
   oo = mitem(o,'Critical');
   ooo = mitem(oo,'Overview',{@WithSpm,'Critical','Overview'});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Worst Damping',{@WithSpm,'Critical','Damping'});
   ooo = mitem(oo,'Bode Plot',{@WithSpm,'Critical','Bode'});
%  ooo = mitem(oo,'-');
%  ooo = mitem(oo,'Simple Calculation', {@WithSpm,'SimpleCalc'});
end
function oo = Stability(o)             % Closed Loop Stability Menu    
   oo = mitem(o,'Stability');
   if type(current(o),{'spm'})
      ooo = mitem(oo,'Critical Quantities',{@WithSpm,'Critical'});
   end
return

   oo = mitem(o,'Stability');
   ooo = mitem(oo,'Overview',{@WithCuo,'StabilityOverview'});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Stability Margin',{@WithCuo,'Margin'});
   ooo = mitem(oo,'Damping',{@WithCuo,'Damping'});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Root Locus',{@WithCuo,'Rloc'});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Critical Quantities',{@WithSpm,'Critical'});
   ooo = mitem(oo,'Simple Calculation', {@WithSpm,'SimpleCalc'});
%  ooo = mitem(oo,'-');
%  ooo = mitem(oo,'Open Loop L0(s)',{@WithCuo,'OpenLoop','L0',1,'bc'});
end
function oo = Sensitivity(o)           % Sensitivity Menu              
   oo = mitem(o,'Sensitivity');
   ooo = mitem(oo,'Weight Sensitivity',{@WithSpm,'SensitivityW'});
   ooo = mitem(oo,'Frequency Sensitivity',{@WithSpm,'SensitivityF'});
   ooo = mitem(oo,'Damping Sensitivit',{@WithSpm,'SensitivityD'});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Modal Contribution',{@WithSpm,'Contribution'});
   ooo = mitem(oo,'Numerical Check',{@WithSpm,'NumericCheck'});
end
function oo = Spectrum(o)              % Spectrum Menu                 
   oo = mitem(o,'Spectrum');
   ooo = mitem(oo,'L0 Magnitude Plots',{@WithSpm,'L0Magni'});
   ooo = mitem(oo,'Lambda Magnitude Plots',{@WithSpm,'LambdaMagni'});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Lambda Bode Plot',{@WithSpm,'LambdaBode'});
end
function oo = Setup(o)                 % Setup Menu                    
   oo = mitem(o,'Setup');
   ooo = mitem(oo,'Basic Study',{@WithCuo,'SetupAnalysis','basic'});
   ooo = mitem(oo,'Symmetry Study',{@WithCuo,'SetupAnalysis','symmetry'});
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
function oo = Precision(o)             % Precision Menu                
   oo = mitem(o,'Precision');
   ooo = mitem(oo,'Eigenvalues',{@WithCuo,'EigenvalueCheck'});
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
   if ~type(oo,{'spm','shell','pkg'})
      plot(oo,'About');
      return
   end
   
      % refresh caches
      
%  [oo,bag,rfr] = cache(oo,oo,'trf');  % transfer function cache segment
%  [oo,bag,rfr] = cache(oo,oo,'consd');% constrained trf cache segment
%  [oo,bag,rfr] = cache(oo,oo,'process'); % process cache segment
   
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
function oo = WithSpm(o)               % 'With Current Spm Callback    
%
% WITHSPM Same as WithCuo but checking if current object is an spm object,
%         otherwise calling plot(o,'About')
%
   refresh(o,o);                       % remember to refresh here
   cls(o);                             % clear screen
 
   oo = current(o);                    % get current object
   if ~type(oo,{'spm'})
      plot(oo,'About');
      return
   end
   
      % refresh caches
      
%  [oo,bag,rfr] = cache(oo,oo,'trf');  % transfer function cache segment
%  [oo,bag,rfr] = cache(oo,oo,'consd');% constrained trf cache segment
%  [oo,bag,rfr] = cache(oo,oo,'process'); % process cache segment
   
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
% Numeric Quality
%==========================================================================


%==========================================================================
% Stability
%==========================================================================

function o = Critical(o)               % Calculate Critical Quantities       
   if type(o,{'spm'})
      o = cache(o,o,'critical');
   else
      plot(o,'About');
      return
   end

   o = with(o,{'bode','stability'});
   points = opt(o,{'omega.points',20000});
   closeup = opt(o,{'bode.closeup',0});
   
   if (closeup)
       points = max(points,500);
       f0 = cook(o,'f0');
       o = opt(o,'omega.low',2*pi*f0/(1+closeup));
       o = opt(o,'omega.high',2*pi*f0*(1+closeup));
       o = opt(o,'omega.points',points);
   end
   o = opt(o,'omega.points',points);
   
   critical(o);
   Heading(o);
end

%==========================================================================
% Sensitivity
%==========================================================================


%==========================================================================
% Open Loop
%==========================================================================


%==========================================================================
% Closed Loop
%==========================================================================


%==========================================================================
% Closed Loop Force
%==========================================================================


%==========================================================================
% Normalized System
%==========================================================================


%==========================================================================
% Spectrum
%==========================================================================


%==========================================================================
% Setup
%==========================================================================


%==========================================================================
% Checks
%==========================================================================


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
function Verbose(o,G)                  % Verbose Tracing of TFF        
   if (control(o,'verbose') > 0)
      G = opt(G,'detail',true);
      display(G);
   end
end
function Legend(o,sub,objects)         % Plot Legend                   
   subplot(o,sub);
   list = {''};                        % ignore 1st, as some dots plotted 
   for (i=1:length(objects))
      list{end+1} = get(objects{i},{'package',''});
   end
   hdl = legend(list);
   set(hdl,'color','w');
end
function [om,om0] = Omega(o,f0,k,n)    % Omega range near f0           
%
% OMEGA  Omega range near f0
%       
%           om = Omega(o,f0,1.05,50)   % om = f0/1.02,..,f0*1.02, 50 points
%           om = Omega(o,f0)           % same as above
%           om = Omega(o)              % cook f0
%         
%           [om,om0] = Omega(o)        % also return center frequency
%
   if (nargin < 4)
      n = 50;
   end
   if (nargin < 3)
      k = 1.05;
   end
   k1 = 1/k;  k2 = k;
   
   if (nargin < 2)
      [f0,L0] = cook(o,'f0,L0');
   end
   
   om0 = 2*pi*f0;
   om = logspace(log10(om0*k1),log10(om0*k2),n);
end
function Heading(o)                                                    
   txt = Contact(o);
   [~,phitxt] = getphi(o);
   msg = [get(o,{'title',''}),' (',txt,', ',phitxt,') - ',id(o)];
   heading(o,msg);
end
function txt = Contact(o)
   contact = opt(o,'process.contact');
   if isempty(contact)
      txt = '';
   elseif iscell(contact)
      txt = 'contact: -';  sep = '';
      for (i=1:length(contact(:)))
         txt = [txt,sep,sprintf('%g',contact{i})];  sep = '-';
      end
      txt = [txt,'-'];   elseif (contact == 0)
      txt = 'contact: center';
   elseif isequal(contact,-1)
      txt = 'contact: leading';
   elseif isequal(contact,-2)
      txt = 'contact: trailing';
   elseif isequal(contact,-3)
      txt = 'contact: triple';
   elseif isinf(contact)
      txt = 'contact: all';
   elseif (length(contact) == 1)
      txt = sprintf('contact: %g',contact);
   else
      txt = 'contact: [';  sep = '';
      for (i=1:length(contact(:)))
         txt = [txt,sep,sprintf('%g',contact(i))];  sep = ',';
      end
      txt = [txt,']'];
   end
end
function [fcol,bcol,ratio] = Colors(o,K)                               
%
% COLORS   Return colors and color ratio of a critical value, where output
%          arg is the ratio of foreground (fcol) to background (bcol9 color 
%
%             [fcol,bcol,ratio] = Colors(o,K)
%
%          Method
%             K = 0:0.5     green/yellow, ratio = 1-K
%             K = 0.5:1     green/yellow, ratio = 1-K
%             K = 1:2       red/yellow,   ratio = 1-1/K
%             K = 2:inf     red/yellow,   ratio = 1-1/K
%
%          Examples:
%             K = 0.1:      90% green @ 10% yellow
%             K = 0.2:      80% green @ 20% yellow
%             K = 0.5:      50% green @ 50% yellow
%             K = 0.8:      20% green @ 80% yellow
%             K = 1.0:       0% green @ 100% yellow
%             K = 1.5:      33% red   @ 67% yellow
%             K = 2:        50% red   @ 50% yellow
%             K = 5:        80% red   @ 20% yellow
%             K = 10:       90% red   @ 10% yellow
%
   n = 2;                              % exponent
   K = abs(K);
   if (K > 1.0)
      fcol = 'ggk';  bcol = 'yyyr';
      ratio = 1 - (1/K)^n;
   else
      fcol = 'r';  bcol = 'yyyr';
      ratio = 1 - K^n;
   end
   
   ratio = 1-ratio;
end
    