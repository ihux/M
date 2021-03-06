function oo = meter(o,varargin)     % Metering Studies                       
%
% METER    Metering Studies
%
%             meter                 % launch METER study shell
%             oo = meter(o,func)    % call local ntc function
%
%          See also: CORAZON, PLUGIN, SAMPLE, SIMPLE
%
   if (nargin == 0)
      oo = meter(corazon);
      return
   end
   
   [gamma,oo] = manage(o,varargin,@Menu,...
                       @WithCuo,@WithSho,@WithBsk,@Algorithm,...
                       @Implementation);
   oo = gamma(oo);
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
%  hold on;                            % hold subsequent plots
 
   oo = current(o);                    % get current object
   gamma = eval(['@',mfilename]);
   oo = gamma(oo);                     % forward to executing method

   if isempty(oo)                      % irregulars happened?
      oo = set(o,'comment',...
                 {'No idea how to plot object!',get(o,{'title',''})});
      message(oo);                     % report irregular
  end
  dark(o);                            % do dark mode actions
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

%==========================================================================
% Menu Setup
%==========================================================================

function oo = Menu(o)                  % Setup Rolldown Menu           
   o = Init(o);
   
   o = menu(o,'Begin');
   oo = menu(o,'File');
%  oo = menu(o,'Edit');
   oo = menu(o,'View');
   oo = Select(o);
   oo = Meter(o);                      % add Meter menu items
   oo = menu(o,'Info');
   oo = menu(o,'Figure');
   oo = menu(o,'End');
end
function o = Init(o)                   % Init Object                   
   if isempty(get(o,'title')) && container(o)
      o = refresh(o,{'menu','About'}); % provide refresh callback
      o = set(o,'title','Metering Studies');
      o = set(o,'comment',...
              {'Testing the metering algorithm'});
      o = control(o,{'dark'},1);       % run in non dark mode
   end
   o = dynamic(o,true);                % setup as a dynamic shell
   o = launch(o,mfilename);            % use this mfile as launch function
end

%==========================================================================
% Select Menu
%==========================================================================

function oo = Select(o)                % Select Menu                   
   setting(o,{'meter.periods'},10);
   setting(o,{'meter.Ts'},0.000551);
   setting(o,{'meter.P0'},600);
   setting(o,{'meter.algo'},1);
   
   oo = mhead(o,'Select');
   ooo = mitem(oo,'Integration Algorithm',{},'meter.algo');
   choice(ooo,{{'Trapezoidal',1},{'Simple',2}},{});

   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Number of Periods',{},'meter.periods');
   choice(ooo,[1:5,10:10:100],{});
   
   ooo = mitem(oo,'Sampling Time',{},'meter.Ts');
   choice(ooo,{{'4.32 ms',0.00432},{'1.11 ms',0.0011},...
              {'0.551 ms',0.000551},{'0.11 ms',0.00011}},{});
           
   ooo = mitem(oo,'Load',{},'meter.P0');
   choice(ooo,{{'100 W',100},{'200 W',200},{'300 W',300},...
               {'400 W',400},{'500 W',500},{'600 W',600}},{});
end

%==========================================================================
% Meter Menu
%==========================================================================

function oo = Meter(o)                 % Meter Menu                    
   oo = mhead(o,'Meter');              % add Meter rolldown menu header
   ooo = mitem(oo,'Algorithm',{@WithCuo,'Algorithm'});
   ooo = mitem(oo,'Implementation',{@WithCuo,'Implementation'});
end

function o = Algorithm(o)              % Metering Algorithm            
   N = opt(o,'meter.periods');         % number of periods to simulate
   algo = opt(o,'meter.algo');         % algorithm selection
   
   tmax = N*20e-3;                     % N periods
   Ts = opt(o,'meter.Ts');             % sampling Time
   
   time = 0:1e-4:tmax;                 % time vector
   U = GridVoltage(o,time);
   I = Current(o,time);                % current
   
   tk = -Ts/2:Ts:tmax+Ts;
   uk = GridVoltage(o,tk);
   ik = Current(o,tk);
   
      % run algorithm
      
   t_ = GridTime(o,tk(1));  u_ = uk(1);  i_ = ik(1);
   t0 = [];  u0 = [];  i0 = [];
   
      % initializing

       % init variables to be recorded
   
   Tgrid = [];  Irms = [];  Urms = [];  Peff = [];
   
       % init algorithm state
       
   t_ = 0;  i_ = 0;  u_ = 0;  ui_ = 0;  i2_ = 0;  u2_ = 0;
   Tp = 0;  I2T = 0;  U2T = 0;  UIT = 0;
   
   for(k=2:length(tk))
      
         % measure t,u,i
         
      [t,toff] = GridTime(o,tk(k));  
      u = uk(k);  i = ik(k);
      
         % check for zero cross
         
      if (t < t_)
         t_ = t_ - GridPeriod(o);      % make negative
         dt = t - t_;                  % calculate time difference
         
         ku = (u - u_)/dt;
         ki = (i - i_)/dt;

         u0(end+1) = u - ku*t;
         i0(end+1) = i - ki*t;
         t0(end+1) = toff;
         
            % complete integration
            
         IntegrationStep(0,u0(end),i0(end));
         
         Tgrid(end+1) = Tp;              % record grid period
         Irms(end+1) = sqrt(I2T/(3*Tp)); % record RMS current
         Urms(end+1) = sqrt(U2T/(3*Tp)); % record RMS voltage
         Peff(end+1) = UIT/(6*Tp);       % record effective power
         
            % reinitialize integral quantities
            
         Tp = 0;  I2T = 0;  U2T = 0;  UIT = 0;
      end
      
         % normal integration step
         
      IntegrationStep(t,u,i);
   end
   
      % display results
      
   Display(o);
   
      % plot voltage & current
         
   PlotU(o,2211);
   PlotI(o,2221);
   
      % plot calculation errors
      
   PlotEI(o,3212);
   PlotEU(o,3222);
   PlotEP(o,3232);
   
   Heading(o,'Algorithm',algo);
   
   function IntegrationStep(t,u,i)     % Perform Integration Step      
      T = t - t_;                      % time delta
      ui = 2*u*i;                      % power term
      i2 = i*i;                        % squared current term
      u2 = u*u;                        % squared voltage term
      uxi = u*i_ + u_*i;               % cross power term
      
         % sum-up Tp, R and W
         
      Tp = Tp + T;                     % sum-up period
      
      switch algo
         case 1
            I2T = I2T + (i2_ + i*i_ + i2)*T;     % sum-up i2t integral
            U2T = U2T + (u2_ + u*u_ + u2)*T;     % sum-up u2t integral
            UIT = UIT + (ui_ + uxi + ui)*T;      % sum-up power integral
         case 2
            I2T = I2T + 3*i2*T;                  % sum-up i2t integral
            U2T = U2T + 3*u2*T;                  % sum-up u2t integral
            UIT = UIT + 3*ui*T;                  % sum-up power integral
         otherwise
            error('bad algo');
      end
         % refresh history
         
      t_ = t;  u_ = u;  i_ = i;
      ui_ = ui;  u2_ = u2;  i2_ = i2;
   end
   function Display(o)                 % Display Integraton Results    
      Z0 = Impedance(o);
      Urms0 = GridRmsVoltage(o);
      Irms0 = Urms0/Z0;
      Peff0 = Urms0*Irms0;
      Tgrid0 = GridPeriod(o);
      
      fprintf('Grid period [ms] (%g ms)\n',Tgrid0*1000);
      disp(Tgrid*1000);
      fprintf('RMS current [mA] (%g mA)\n',Irms0*1000);
      disp(Irms*1000);
      fprintf('RMS voltage [V] (%g V)\n',Urms0);
      disp(Urms);
      fprintf('Effective Power [W] (%g W)\n',Peff0);
      disp(Peff);
   end

   function PlotU(o,sub)               % Plot Voltage                  
      subplot(o,sub);
      o = opt(o,'xscale',1000);
      
      plot(o,time,U,'bc');
      hold on;
      plot(o,tk,uk,'K|', tk,uk,'co');
      plot(o,tk,uk,'c'); 
               
      plot(o,t0,u0,'go');

      set(gca,'xlim',[time(1)-5e-3,time(end)+5e-3]*1000);
      title('Grid Voltage');
      xlabel('time [ms]');
      ylabel('u [V]');
      subplot(o);                      % subplot complete
   end
   function PlotI(o,sub)               % Plot Current                  
      subplot(o,sub);
      o = opt(o,'xscale',1000);
      o = opt(o,'yscale',1000);
      
      plot(o,time,I,'r');
      hold on;
      plot(o,tk,ik,'K|', tk,ik,'mo');
      plot(o,tk,ik,'m'); 
      
      plot(o,t0,i0,'go');

      set(gca,'xlim',[time(1)-5e-3,time(end)+5e-3]*1000);
      title('Current');
      xlabel('time [ms]');
      ylabel('i [mA]');
      subplot(o);                      % subplot complete
   end

   function PlotEI(o,sub)              % Plot Current Error            
      Z0 = Impedance(o);
      Urms0 = GridRmsVoltage(o);
      Irms0 = Urms0/Z0;
      
      e = (Irms-Irms0)/Irms0;          % current error
      idx = 1:length(e);
 
      subplot(o,sub);
      
      plot(o,idx,e*100,'r', idx,e*100,'Ko');

      err = o.rd(max(abs(e*100)),2);
      title(sprintf('RMS Current Error: %g %% (Ts = %g ms)',err,Ts*1000));
      xlabel('Period Index');
      ylabel('e_I [%]');
      subplot(o);                      % subplot complete
   end
   function PlotEU(o,sub)              % Plot Voltage Error            
      Urms0 = GridRmsVoltage(o);
      
      e = (Urms-Urms0)/Urms0;          % current error
      idx = 1:length(e);
 
      subplot(o,sub);
      
      plot(o,idx,e*100,'bc', idx,e*100,'Ko');

      err = o.rd(max(abs(e*100)),2);
      title(sprintf('RMS Voltage Error: %g %% (Ts = %g ms)',err,Ts*1000));
      xlabel('Period Index');
      ylabel('e_U [%]');
      subplot(o);                      % subplot complete
   end
   function PlotEP(o,sub)              % Plot Power Error              
      Z0 = Impedance(o);
      Urms0 = GridRmsVoltage(o);
      Irms0 = Urms0/Z0;
      Peff0 = Urms0*Irms0;
      
      e = (Peff-Peff0)/Peff0;          % current error
      idx = 1:length(e);
 
      subplot(o,sub);
      
      plot(o,idx,e*100,'g', idx,e*100,'Ko');

      err = o.rd(max(abs(e*100)),2);
      title(sprintf('Effective Power Error: %g %% (Ts = %g ms)',err,Ts*1000));
      xlabel('Period Index');
      ylabel('e_P [%]');
      subplot(o);                      % subplot complete
   end
end
function o = Implementation(o)         % Metering Implementation       
   SHIFTI = 2^0;                       % current normalization constant
   SHIFTU = 2^6;                       % voltage normalization constant
   SHIFTT = 2^11;                      % time normalization
   
   N = opt(o,'meter.periods');         % number of periods to simulate
   algo = opt(o,'meter.algo');         % algorithm selection
   
   tmax = N*20e-3;                     % N periods
   Ts = opt(o,'meter.Ts');             % sampling Time
   
   time = 0:1e-4:tmax;                 % time vector
   U = GridVoltage(o,time);
   I = Current(o,time);                % current
   
   tk = -Ts/2:Ts:tmax+Ts;
   uk = GridVoltage(o,tk);
   ik = Current(o,tk);
   
      % convert to mA and mV
      
   ImA = int32(ik*1000);
   UmV = int32(uk*1000);
   
      % run algorithm
      
   t_ = GridTime(o,tk(1));  u_ = uk(1);  i_ = ik(1);
   t0 = [];  u0 = [];  i0 = [];
   
      % convert to 
      % initializing

       % init variables to be recorded
   
   Tgrid = [];  Irms = [];  Urms = [];  Peff = [];
   
       % init algorithm state
       
   t_ = 0;  i_ = 0;  u_ = 0;  ui_ = 0;  i2_ = 0;  u2_ = 0;
   Tp = 0;  I2T = 0;  U2T = 0;  UIT = 0;
   
   for(k=2:length(tk))
      
         % measure t,u,i
         
      [t,toff] = GridTimeUs(o,tk(k));  
      u = UmV(k) / SHIFTU;             % u = uk(k) >> 11;  
      i = ImA(k) / SHIFTI;             % i = ik(k) >> 5;
      
         % check for zero cross
         
      if (t < t_)
         t_ = t_ - GridPeriodUs(o);    % make negative
         dt = t - t_;                  % calculate time difference
         
         u0(end+1) = u - ((u-u_)*t) / dt;
         i0(end+1) = i - ((i-i_)*t) / dt;
         t0(end+1) = toff;
         
            % complete integration
            
         IntegrationStep(0,u0(end),i0(end));
         Finalize(o);
      end
      
         % normal integration step
         
      IntegrationStep(t,u,i);
   end
   
      % display results
      
   Display(o);
   
      % plot voltage & current
         
   PlotU(o,2211);
   PlotI(o,2221);
   
      % plot calculation errors
      
   PlotEI(o,3212);
   PlotEU(o,3222);
   PlotEP(o,3232);

   Heading(o,'Implementation',algo);

   function IntegrationStep(t,u,i)     % Perform Integration Step      
      T = t - t_;                      % time delta
      ui = 2*u*i;                      % power term
      i2 = i*i;                        % squared current term
      u2 = u*u;                        % squared voltage term
      uxi = u*i_ + u_*i;               % cross power term
                     
         % depending on algorithm calculate integrands
         
      switch algo
         case 1
            dI2 = (i2_ + i*i_ + i2) / SHIFTT;
            dU2 = (u2_ + u*u_ + u2) / SHIFTT;
            dUI = (ui_ + uxi  + ui) / SHIFTT;
         case 2
            dI2 = (3*i2) / SHIFTT;
            dU2 = (3*u2) / SHIFTT;
            dUI = (3*ui) / SHIFTT;
         otherwise
            error('bad algo');
      end
      
         % sum-up period ands integrals I2T,U2T,UIT ...
         
      Tp = Tp + T;                     % sum-up period
      I2T = I2T + (dI2*T);             % sum-up i2t integral
      U2T = U2T + (dU2*T);             % sum-up u2t integral
      UIT = UIT + (dUI*T);             % sum-up power integral

         % refresh history
         
      t_ = t;  u_ = u;  i_ = i;
      ui_ = ui;  u2_ = u2;  i2_ = i2;
   end
   function Finalize(o)                % Finalize Integration          
      Tgrid(end+1) = Tp;               % record grid period

      Irms2 = double(I2T/(3*Tp)) * (SHIFTI*SHIFTI*SHIFTT);
      Urms2 = double(U2T/(3*Tp)) * (SHIFTU*SHIFTU*SHIFTT);
      PmW   = double(UIT/(6*Tp)) * (SHIFTU*SHIFTI*SHIFTT);

      Irms(end+1) = sqrt(Irms2)/1000;  % record RMS current
      Urms(end+1) = sqrt(Urms2)/1000;  % record RMS voltage
      Peff(end+1) = PmW/1000000;       % record effective power

         % reinitialize integral quantities
            
      Tp = 0;  I2T = 0;  U2T = 0;  UIT = 0;
   end
   function Display(o)                 % Display Integraton Results    
      Z0 = Impedance(o);
      Urms0 = GridRmsVoltage(o);
      Irms0 = Urms0/Z0;
      Peff0 = Urms0*Irms0;
      Tgrid0 = GridPeriod(o);
      
      fprintf('Grid period [ms] (%g ms)\n',Tgrid0*1000);
      disp(Tgrid*1000);
      fprintf('RMS current [mA] (%g mA)\n',Irms0*1000);
      disp(Irms*1000);
      fprintf('RMS voltage [V] (%g V)\n',Urms0);
      disp(Urms);
      fprintf('Effective Power [W] (%g W)\n',Peff0);
      disp(Peff);
   end

   function PlotU(o,sub)               % Plot Voltage                  
      subplot(o,sub);
      o = opt(o,'xscale',1000);
      
      plot(o,time,U,'bc');
      hold on;
      plot(o,tk,uk,'K|', tk,uk,'co');
      plot(o,tk,uk,'c'); 
               
      plot(o,t0,u0,'go');

      set(gca,'xlim',[time(1)-5e-3,time(end)+5e-3]*1000);
      title('Grid Voltage');
      xlabel('time [ms]');
      ylabel('u [V]');
      subplot(o);                      % subplot complete
   end
   function PlotI(o,sub)               % Plot Current                  
      subplot(o,sub);
      o = opt(o,'xscale',1000);
      o = opt(o,'yscale',1000);
      
      plot(o,time,I,'r');
      hold on;
      plot(o,tk,ik,'K|', tk,ik,'mo');
      plot(o,tk,ik,'m'); 
      
      plot(o,t0,i0,'go');

      set(gca,'xlim',[time(1)-5e-3,time(end)+5e-3]*1000);
      title('Current');
      xlabel('time [ms]');
      ylabel('i [mA]');
      subplot(o);                      % subplot complete
   end

   function PlotEI(o,sub)              % Plot Current Error            
      Z0 = Impedance(o);
      Urms0 = GridRmsVoltage(o);
      Irms0 = Urms0/Z0;
      
      e = (Irms-Irms0)/Irms0;          % current error
      idx = 1:length(e);
 
      subplot(o,sub);
      
      plot(o,idx,e*100,'r', idx,e*100,'Ko');

      err = o.rd(max(abs(e*100)),2);
      title(sprintf('RMS Current Error: %g %% (Ts = %g ms)',err,Ts*1000));
      xlabel('Period Index');
      ylabel('e_I [%]');
      subplot(o);                      % subplot complete
   end
   function PlotEU(o,sub)              % Plot Voltage Error            
      Urms0 = GridRmsVoltage(o);
      
      e = (Urms-Urms0)/Urms0;          % current error
      idx = 1:length(e);
 
      subplot(o,sub);
      
      plot(o,idx,e*100,'bc', idx,e*100,'Ko');

      err = o.rd(max(abs(e*100)),2);
      title(sprintf('RMS Voltage Error: %g %% (Ts = %g ms)',err,Ts*1000));
      xlabel('Period Index');
      ylabel('e_U [%]');
      subplot(o);                      % subplot complete
   end
   function PlotEP(o,sub)              % Plot Power Error              
      Z0 = Impedance(o);
      Urms0 = GridRmsVoltage(o);
      Irms0 = Urms0/Z0;
      Peff0 = Urms0*Irms0;
      
      e = (Peff-Peff0)/Peff0;          % current error
      idx = 1:length(e);
 
      subplot(o,sub);
      
      plot(o,idx,e*100,'g', idx,e*100,'Ko');

      err = o.rd(max(abs(e*100)),2);
      title(sprintf('Effective Power Error: %g %% (Ts = %g ms)',err,Ts*1000));
      xlabel('Period Index');
      ylabel('e_P [%]');
      subplot(o);                      % subplot complete
   end
end

%==========================================================================
% Helper
%==========================================================================

function T = GridPeriod(o)             % Get Grid Period               
   om = 2*pi*50;                       % circular frequency
   T = 2*pi/om;
end
function Tus = GridPeriodUs(o)         % Get Microsecond Grid Period   
   T = GridPeriod(o);                  % grid period in seconds
   Tus = int32(T*1e6);
end
function [t,toff] = GridTime(o,t)      % Get Grid Time                 
   T = GridPeriod(o);
   toff = 0;
   while (t < 0)
      t = t+T;  toff = toff - T;
   end
   while (t >= T)
      t = t-T;  toff = toff + T;
   end
end
function [tus,toff] = GridTimeUs(o,t)  % Get Mirosecond Grid Time      
   [t,toff] = GridTime(o,t);
   tus = int32(t*1e6);
end
function Urms = GridRmsVoltage(o)      % Get RMS Grid Voltage          
   Urms = 230;
end
function u = GridVoltage(o,t)          % Get Grid Voltage              
   om = 2*pi/GridPeriod(o);
   Urms = GridRmsVoltage(o);
   u = Urms*sqrt(2)*sin(om*t);
end
function Z0 = Impedance(o)             % Load Impedance                
   P0 = opt(o,'meter.P0');             % nominal load power
   Urms = GridRmsVoltage(o);           % grid RMS voltage
   Z0 = Urms^2/P0;
end
function i = Current(o,t)              % Get Current                   
   Z0 = Impedance(o);
   u = GridVoltage(o,t);
   i = u/Z0;
end
function Heading(o,msg,algo)               % Plot Figure Heading           
   switch algo
      case 1
         prefix = 'Trapezoidal';
      case 2
         prefix = 'Simple';
      otherwise
         prefix = '???';
   end
   heading(o,[prefix,' Metering ',msg]);
end

