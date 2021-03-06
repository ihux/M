function oo = new(o,varargin)          % CORASIM New Method            
%
% NEW   New CORASIM object
%
%           oo = new(o,'Menu')         % menu setup
%
%           o = new(corasim,'Css')     % continuous state space
%           o = new(corasim,'Dss')     % discrete state space
%
%           o = new(corasim,'PT1')     % PT1 system
%           o = new(corasim,'Filter2') % order 2 filter
%           o = new(corasim,'Modal3')  % modal form (continuous, order 3)
%
%           o = new(corasim,'Motion100mm')
%           o = new(corasim,'Motion200mm')
%           o = new(corasim,'Motion100um')
%
%       See also: CORASIM, PLOT, ANALYSIS, STUDY
%
   [gamma,oo] = manage(o,varargin,@Css,@Dss,@Modal3,@PT1,@Filter2,@PT3,...
                       @Trf23,...
                       @Motion100mm,@Motion200mm,@Motion100um,...
                       @Modal,@Menu);
   oo = gamma(oo);
end

%==========================================================================
% Menu Setup
%==========================================================================

function oo = Menu(o)                  % Setup Menu                    
   oo = mitem(o,'Continuous State Space (css)',{@Callback,'Css'},[]);
   oo = mitem(o,'Discrete State Space (dss)',{@Callback,'Dss'},[]);
   oo = mitem(o,'-');
   oo = mitem(o,'Continuous PT1 System',{@Callback,'PT1'},[]);
   oo = mitem(o,'Continuous PT2 System,',{@Callback,'Filter2'},[]);
   oo = mitem(o,'Continuous PT3 System,',{@Callback,'PT3'},[]);
   oo = mitem(o,'Transfer Function 2/3,',{@Callback,'Trf23'},[]);
   oo = mitem(o,'-');
   oo = mitem(o,'Order 3 Modal Form',{@Callback,'Modal3'},[]);
   oo = mitem(o,'-');
   oo = mitem(o,'100 mm Motion',{@Callback,'Motion100mm'},[]);
   oo = mitem(o,'200 mm Motion',{@Callback,'Motion200mm'},[]);
   oo = mitem(o,'100 um Motion',{@Callback,'Motion100um'},[]);
end
function oo = Callback(o)              % Launch Callback               
   mode = arg(o,1);
   oo = new(o,mode);
   oo = launch(oo,launch(o));          % inherit launch function
   paste(o,{oo});                      % paste object into shell
end

%==========================================================================
% New Dynamic System
%==========================================================================

function oo = Css(o)                   % New css object                
   oo = corasim('css');                % continuous state space
   oo.par.title = sprintf('Continuous State Space System (%s)',datestr(now));
   oo = system(oo,[0 1;0 0],[0;1],[1 0],0);
end
function oo = Dss(o)                   % New dss object                
   oo = corasim('dss');                % discrete state space
   oo.par.title = sprintf('Discrete State Space System (%s)',datestr(now));
   lambda = [-1 -2] + randn(1,2);
   oo = system(oo,diag(lambda),[1;1],[1 -2],0);
   oo = c2d(oo,0.1);
end
function oo = PT1(o)                   % New PT1 System                
   oo = system(corasim,{1,[1 1]});     % continuous PT1 system
   oo.par.title = sprintf('Continuous PT1 System (%s)',datestr(now));
   oo.par.comment = {'G(s) = 1/(s+1)'};
end
function oo = Filter2(o)               % New continuous order 2 filter 
   f = 10/2/pi;                        % band width 1.6 Hz
   om = 2*pi*f;                        % cut-off circular frequency
   zeta = 0.4;                         % damping   
   
   oo = system(corasim,{1,[om^2 2*zeta*om 1]});     % continuous trf
   oo.par.title = sprintf('Continuous Order 2 Filter (%s)',datestr(now));
   oo.par.comment = {sprintf('Bandwidth: f = %g Hz',o.rd(f,1)),...
                     sprintf('Damping: zetea = %g',zeta)};
end
function oo = PT3(o)                   % New PT3 System                
   oo = system(corasim,{1,[1 3 3 1]}); % continuous PT3 system
   oo.par.title = sprintf('Continuous PT3 System (%s)',datestr(now));
   oo.par.comment = {'G(s) = 1/(s+1)^3'};
end
function oo = Trf23(o)                 % New Transfer Function 2/3     
   den = mul(o,[1 1],[1 0.5 1]);
   oo = system(corasim,{[1 5 6],den}); % transfer function 2/3
   oo.par.title = sprintf('Transfer Function 2/3 (%s)',datestr(now));
   oo.par.comment = {'G(s) = 1/(s+1)^3'};
end
function oo = Modal3(o)                % New css Object in Modal Form  
   omega = [1 2 3]';
   zeta  = [0.1 0.1 0.1]';
   M = [1 -1 1]';
   N = [0 2 3]';
   
   a0 = omega.*omega;  a1 = 2*zeta.*omega;  n = length(omega);
   A = [zeros(n),eye(n); -diag(a0) -diag(a1)];
   B = [0*N; M];  C=[M' N'];  D = 1;
   
   oo = system(corasim,A,B,C,D);       % continuous state space (modal)
   oo.par.title = sprintf('Continuous State Space System (%s)',...
                          datestr(now));
   oo.par.comment = {'Modal Form',...
     'omega = [1 2 3], zeta = [0.1 0.1 0.1],  M = [1 -1 1],  N = [2 3 4]'};
end

%==========================================================================
% New Motion Object
%==========================================================================

function oo = Motion100mm(o)           % 100 mm Motion                 
   oo = corasim('motion');             % continuous state space
   oo.data.smax = 0.1;                 % 0.1 m
   oo.data.vmax = 1;                   % 1 m/s
   oo.data.amax = 10;                  % 10 m/s2
   oo.data.tj = 0.02;                  % 20 ms jerk time
   
   oo.data.tunit = 'ms';               % time unit
   oo.data.sunit = 'mm';               % stroke unit
   
   oo.par.title = sprintf('Motion 100 mm (%s)',datestr(now));
   oo.par.comment = {'vmax: 1m/s, amax: 10 m/s2, Tj = 20 ms'};
end
function oo = Motion200mm(o)           % 200 mm Motion                 
   oo = corasim('motion');             % continuous state space
   oo.data.smax = 0.2;                 % 200 mm
   oo.data.vmax = 1;                   % 1 m/s
   oo.data.amax = 10;                  % 10 m/s2
   oo.data.tj = 0.02;                  % 20 ms jerk time
   
   oo.data.tunit = 'ms';               % time unit
   oo.data.sunit = 'mm';               % stroke unit
   
   oo.par.title = sprintf('Motion 200 mm (%s)',datestr(now));
   oo.par.comment = {'vmax: 1m/s, amax: 10 m/s2, Tj = 20 ms'};
end
function oo = Motion100um(o)           % 100 um Motion                 
   oo = corasim('motion');             % continuous state space
   oo.data.smax = 100e-6;              % 100 um
   oo.data.vmax = 0.15e-3;             % 0.15 mm/s
   oo.data.amax = 1e-3;                % 10 m/s2
   oo.data.tj = 0.02;                  % 20 ms jerk time
   
   oo.data.tunit = 'ms';               % time unit
   oo.data.sunit = 'mm';               % stroke unit
   
   oo.par.title = sprintf('Motion 100 um (%s)',datestr(now));
   oo.par.comment = {'vmax: 0.15mm/s, amax: 1 mm/s2, Tj = 20 ms'};
end
