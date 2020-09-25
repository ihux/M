function oo = plot(o,varargin)         % SPM Plot Method               
%
% PLOT   SPM plot method
%
%           plot(o)                    % default plot method
%           plot(o,'Plot')             % default plot method
%
%           plot(o,'Overview')         % Overview about eigenvalues of SPM
%
%           plot(o,'Step')             % force step response
%           plot(o,'Ramp')             % force ramp response
%
%        See also: SPM, SHELL
%
   [gamma,oo] = manage(o,varargin,@Plot,@Menu,@WithCuo,@WithSho,@WithBsk,...
                   @Overview,@About,@Real,@Imag,@Complex,...
                   @Trfd,@Trfr,@Consd,@Consr,@Ls,@LsStepOverview,...
                   @Step,@Ramp,@ForceRamp,@ForceStep,@MotionRsp,...
                   @AnalyseRamp,@NormRamp);
   oo = gamma(oo);
end

%==========================================================================
% Plot Menu
%==========================================================================

function oo = Menu(o)                  % Setup Plot Menu               
%
% MENU  Setup plot menu. Note that plot functions are best invoked via
%       Callback or Basket functions, which do some common tasks
%
   oo = mitem(o,'About',{@WithCuo,'About'});
   oo = mitem(o,'Overview',{@WithCuo,'Plot'});
   oo = mitem(o,'-');
   oo = mitem(o,'Eigenvalues');
   ooo = mitem(oo,'Complex', {@WithCuo,'Complex'});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Real Part',{@WithCuo,'Real'});
   ooo = mitem(oo,'Imaginary Part',{@WithCuo,'Imag'});
   
   oo = TransferMatrix(o);
   oo = ConstrainMatrix(o);            % H(s)
   oo = LinearSystem(o);               % L(s)

   oo = mitem(o,'-');
   oo = StepResponse(o);               % step response sub-menu
   oo = RampResponse(o);               % ramp response sub-menu
   oo = MotionResponse(o);             % motion response sub menu
end
function oo = TransferMatrix(o)        % Transfer Matrix Menu          
   oo = current(o);
   [B,C] = data(oo,'B,C');
   [~,m] = size(B);
   [l,~] = size(C);
   
   oo = mhead(o,'Transfer Matrix');
   ooo = mitem(oo,sprintf('G(s)'),{@WithCuo,'Trfd',0,0});
   ooo = Double(oo);                   % Double submenu
   
   ooo = mitem(oo,'-');
   for (i=1:l)
      for (j=1:m)
         ooo = mitem(oo,sprintf('G%g%g(s)',i,j),{@WithCuo,'Trfd',i,j});
      end
      if (i < l)
         ooo = mitem(oo,'-');
      end
   end
   
   function oo = Double(o)             % Double Sub Menu               
      oo = mitem(o,'Rational');
      enable(oo,false);
      ooo = mitem(oo,sprintf('G(s)'),{@WithCuo,'Trfr',0,0});
      ooo = mitem(oo,'-');
      for (i=1:l)
         for (j=1:m)
            ooo = mitem(oo,sprintf('G(%g,%g)',i,j),{@WithCuo,'Trfr',i,j});
         end
         if (i < l)
            ooo = mitem(oo,'-');
         end
      end
   end   
end
function oo = ConstrainMatrix(o)       % Transfer Matrix Menu          
   oo = current(o);
   [B,C] = data(oo,'B,C');
   [~,m] = size(B);
   [l,~] = size(C);
   
   oo = mhead(o,'Constrained Matrix');
   ooo = mitem(oo,sprintf('H(s)'),{@WithCuo,'Consd',0,0});
   ooo = Rational(oo);
   ooo = mitem(oo,'-');
   for (i=1:l)
      for (j=1:m)
         ooo = mitem(oo,sprintf('H%g%g(s)',i,j),{@WithCuo,'Consd',i,j});
      end
      if (i < l)
         ooo = mitem(oo,'-');
      end
   end
   
   
   function oo = Rational(o)           % Rational Submenu              
      oo = mitem(o,'Rational');
      enable(oo,false);
      ooo = mitem(oo,sprintf('H(s)'),{@WithCuo,'Consr',0,0});
      ooo = mitem(oo,'-');
      for (i=1:l)
         for (j=1:m)
            ooo = mitem(oo,sprintf('H(%g,%g)',i,j),{@WithCuo,'Consr',i,j});
         end
         if (i < l)
            ooo = mitem(oo,'-');
         end
      end
   end
 end
function oo = LinearSystem(o)          % Linear System Menu            
   oo = mhead(o,'Linear System');

   oo = current(o);
   if container(oo)
      return                           % done for container objects
   end
   
   [oo,bag,rfr] = cache(oo,oo,'consd');
   
   L = cache(oo,'consd.L');
   [m,n] = size(L);

      % add mhead again !!!
      
   oo = mhead(o,'Linear System');
   ooo = mitem(oo,sprintf('L(s)'),{@WithCuo,'Ls',0,0});
   ooo = mitem(oo,'Step Response Overview',{@WithCuo,'LsStepOverview'});
   
   ooo = mitem(oo,'-');
   for (i=1:m)
      for (j=1:n)
         ooo = mitem(oo,sprintf('L%g%g(s)',i,j),{@WithCuo,'Ls',i,j});
      end
      if (i < m)
         ooo = mitem(oo,'-');
      end
   end
 end
   
function oo = StepResponse(o)          % Step Response Menu            
   oo = mitem(o,'Step Response');
   ooo = mitem(oo,'Force Step Overview',{@WithCuo,'ForceStep'},0);

   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Force Step @ F1',{@WithCuo,'ForceStep'},1);
   ooo = mitem(oo,'Force Step @ F2',{@WithCuo,'ForceStep'},2);
   ooo = mitem(oo,'Force Step @ F3',{@WithCuo,'ForceStep'},3);    

   ooo = mitem(oo,'-');
   ooo = mitem(oo,'F-Step Orbit @ F1',{@WithCuo,'ForceStep'},10);
   ooo = mitem(oo,'F-Step Orbit @ F2',{@WithCuo,'ForceStep'},20);
   ooo = mitem(oo,'F-Step Orbit @ F3',{@WithCuo,'ForceStep'},30);    
end
function oo = RampResponse(o)          % Ramp Response Menu            
   oo = mitem(o,'Ramp Response');
   ooo = mitem(oo,'Force Ramp Overview',{@WithCuo,'ForceRamp'},0);

   ooo = mitem(oo,'-');
   ooo = mitem(oo,'Force Ramp @ F1',{@WithCuo,'ForceRamp'},1);
   ooo = mitem(oo,'Force Ramp @ F2',{@WithCuo,'ForceRamp'},2);
   ooo = mitem(oo,'Force Ramp @ F3',{@WithCuo,'ForceRamp'},3);   

   ooo = mitem(oo,'-');
   ooo = mitem(oo,'F-Ramp Orbit @ F1',{@WithCuo,'ForceRamp'},10);
   ooo = mitem(oo,'F-Ramp Orbit @ F2',{@WithCuo,'ForceRamp'},20);
   ooo = mitem(oo,'F-Ramp Orbit @ F3',{@WithCuo,'ForceRamp'},30);    
end
function oo = MotionResponse(o)        % Motion Response Menu          
   oo = mitem(o,'Motion Response');
   ooo = mitem(oo,'y3 -> y1',{@WithCuo,'MotionRsp',31});
   ooo = mitem(oo,'y3 -> y2',{@WithCuo,'MotionRsp',32});
   ooo = mitem(oo,'-');
   ooo = mitem(oo,'y3 -> F3',{@WithCuo,'MotionRsp',33});
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

   cls(o);                             % clear screen
   switch o.type
      case 'spm'
         oo = Overview(o);
      otherwise
         oo = plot(o,'About');         % no idea how to plot
   end
end

%==========================================================================
% Plot Overview and About Object
%==========================================================================

function o = Overview(o)               % Plot Overview                 
   if ~type(o,{'spm'})
      plot(o,'About');
      return                           % no idea how to plot this type
   end

   o = cache(o,o,'eigen');             % hard refresh 'eigen' cache segment
   
   Real(o,[2 2 1]);
   Imag(o,[2 2 3]);
   Complex(o,[1 2 2]);

   heading(o);
end
function o = About(o)                  % About Object                  
   o = menu(o,'About');                % keep it simple
end

%==========================================================================
% Plot Eigenvalues and Transfer Matrix
%==========================================================================

function o = Real(o,sub)               % Plot Real Part of Eigenvalues 
   if ~type(o,{'spm'})
      plot(o,'About');
      return                           % no idea how to plot this type
   end
   
   if (nargin < 2)
      sub = [1 1 1];                   % default subplot full canvas
   end
   subplot(o,sub);
   
   index = cache(o,'eigen.index');
   real = cache(o,'eigen.real');
   
   plot(o,index,real,'r2');

   title('Real Part of System Eigenvalues');
   xlabel('index');  ylabel('real part');
   
   heading(o);
end
function o = Imag(o,sub)               % Plot Imag Part of Eigenvalues 
   if ~type(o,{'spm'})
      plot(o,'About');
      return                           % no idea how to plot this type
   end

   if (nargin < 2)
      sub = [1 1 1];                   % default subplot full canvas
   end
   subplot(o,sub);
   
   index = cache(o,'eigen.index');
   imag = cache(o,'eigen.imag');
   
   plot(o,index,imag,'g2');

   title('Imaginary Part of System Eigenvalues');
   xlabel('index');  ylabel('real part');
  
   heading(o);
end
function o = Complex(o,sub)            % Eigenvalues in Complex Plane  
   if ~type(o,{'spm'})
      oo = plot(o,'About');
      return                           % no idea how to plot this type
   end

   if (nargin < 2)
      sub = [1 1 1];                   % default subplot full canvas
   end
   subplot(o,sub);
   
   real = cache(o,'eigen.real');
   imag = cache(o,'eigen.imag');

   plot(o,real,imag,'yyyrx');
   hold on;
   plot(o,real,imag,'yyyro');

   title('Eigenvalues in Complex Plane');
   xlabel('real part');  ylabel('imaginary part');

%  set(gca,'DataAspectRatio',[1 1 1]);
   heading(o);
end

%==========================================================================
% Plot Transfer Matrix G(s)
%==========================================================================

function o = Trfd(o)                   % Double Transfer Function      
%  o = with(o,'view');                 % unwrap view options 
   i = arg(o,1);
   j = arg(o,2);

   G = cache(o,'trfd.G');
   W = cache(o,'trfd.W');
   if (i == 0 || j == 0)
      G = opt(G,'maxlen',200);
      str = display(G);
      sym = 'G';

      [m,n] = size(G);
      for (i=1:n)
         for (j=1:m)
            Gij = peek(G,i,j);
            Gij = set(Gij,'name',sprintf('G%g%g(s)',i,j));
            disp(Gij);
            fprintf('\n');
         end
      end
      diagram(o,'Trf',sym,G,111);
   else
      Gij = peek(G,i,j);
      wij = W{i,j};
      Gij = opt(Gij,'maxlen',200);
      str = display(Gij);
      
      sym = sprintf('G%g%g(s)',i,j);
      symw = sprintf('w%g%g',i,j);
      Gij = set(Gij,'name',sym);    
      disp(Gij);
      
      diagram(o,'Trf',sym,Gij,3111);      
      diagram(o,'Rloc',sym,Gij,3222);
      diagram(o,'Weight',symw,wij,3231);

      o = opt(o,'color','g');
      diagram(o,'Step',sym,Gij,3221);
   end
   heading(o);
end
function o = Trfr(o)                   % Rational Transfer Function    
   assert(0);
   i = arg(o,1);
   j = arg(o,2);

   G = cache(o,'trfr.G');

   Gij = peek(G,i,j);
   Gij = opt(Gij,'maxlen',200);
   str = display(Gij);

   comment = {get(o,{'title',''}),' '};
   for (k=1:size(str,1))
      comment{end+1} = str(k,:);
   end
   message(o,sprintf('rational Transfer Function G(%g,%g)',i,j),comment);
end

%==========================================================================
% Plot Constraint Transfer Matrix H(s)
%==========================================================================

function o = Consd(o)                  % Double Constrained Trf Fct    
%  o = with(o,'view');                 % unwrap view options 
   i = arg(o,1);
   j = arg(o,2);

   G = cache(o,'trfd.G');
   H = cache(o,'consd.H');
   
   if (i == 0 || j == 0)
      H = opt(H,'maxlen',200);
      str = display(H);
      sym = 'H(s)';
      
      [m,n] = size(H);
      for (i=1:n)
         for (j=1:m)
            Hij = peek(H,i,j);
            Hij = set(Hij,'name',sprintf('H%g%g(s)',i,j));
            disp(Hij);
            fprintf('\n');
         end
      end
      diagram(o,'Trf',sym,H,111);
   else
      Gij = peek(G,i,j);
      Hij = peek(H,i,j);
      
      Hij = set(Hij,'name',sprintf('H%g%g(s)',i,j));
      display(Hij);

      Hij = opt(Hij,'maxlen',200);
      str = display(Hij);
      [num,den] = peek(Hij);
      
      Hsym = sprintf('H%g%g(s)',i,j);
      Gsym = sprintf('G%g%g(s)',i,j);

      diagram(o,'Trf', Hsym,Hij,3111);
      diagram(o,'Step',Gsym,Gij,3221);
      if length(num) <= length(den)    % proper Hij(s) ?
         diagram(o,'Step',Hsym,Hij,3221); 
      end
      diagram(o,'Rloc',Hsym,Hij,3222);
   end
   heading(o);
end
function o = Consr(o)                  % Rational Constrained Trf Funct
   assert(0);
   message(o,'Rational Constrained Transfer Matrix Not Yet Implemented!');
   return
   
   i = arg(o,1);
   j = arg(o,2);

   H = cache(o,'consr.H');
   if (i == 0 || j == 0)
      H = opt(H,'maxlen',200);
      str = display(H);
      sym = 'H(s)';
   else
      Hij = peek(H,i,j);
      Hij = opt(Hij,'maxlen',200);
      str = display(Hij);
      sym = sprintf('H(%g,%g)',i,j);
   end

   comment = {get(o,{'title',''}),' '};
   for (k=1:size(str,1))
      comment{end+1} = str(k,:);
   end
   message(o,sprintf('Constrained Transfer Function %s (Rational)',sym),...
                     comment);
end

%==========================================================================
% Plot Linear Part Transfer Matrix L(s)
%==========================================================================

function o = Ls(o)                     % Linear System Trf Matrix      
   i = arg(o,1);
   j = arg(o,2);

   L = cache(o,'consd.L');
   
   if (i == 0 || j == 0)
      L = opt(L,'maxlen',200);
      str = display(L);
      sym = 'L(s)';
      
      [m,n] = size(L);
      for (i=1:m)
         for (j=1:n)
            Lij = peek(L,i,j);
            Lij = set(Lij,'name',sprintf('L%g%g(s)',i,j));
            disp(Lij);
            fprintf('\n');
         end
      end
      diagram(o,'Trf',sym,L,111);
   else
      Lij = peek(L,i,j);
      
      Lij = set(Lij,'name',sprintf('L%g%g(s)',i,j));
      display(Lij);

      Lij = opt(Lij,'maxlen',200);
      str = display(Lij);
      
      Lsym = sprintf('L%g%g(s)',i,j);
      mode = o.iif(i<=2,'Vstep','Step');

      diagram(o,'Trf', Lsym,Lij,3111);
      diagram(o,'Rloc',Lsym,Lij,3222);
      diagram(o,mode,Lsym,Lij,3221);  
   end
   heading(o);
end
function o = LsStepOverview(o)         % L(s) Step Response Overview   
   L = cache(o,'consd.L');             % L(s)
   [m,n] = size(L);
   
   for (i=1:m)
      for (j=1:n)
         mode = o.iif(i<=2,'Vstep','Step');
         sym = sprintf('L%g%g(s)',i,j);
         Lij = peek(L,i,j);
         diagram(o,mode,sym,Lij,[3,2,i,j]);
      end
   end
   heading(o);
end

%==========================================================================
% Plot Menu Plugins
%==========================================================================

function o = Step(o)                   % Step Response                 
   if ~type(o,{'spm'})
      plot(o,'About');
      return
   end
   
   oo = Corasim(o);                    % convert to corasim object
   
   index = arg(o,1);
   t = Time(o);
   u = StepInput(oo,t,index);

   oo = sim(oo,u,[],t);
   plot(oo);
   heading(o,sprintf('Step Response: F%g->y (%s)',index,Title(o)));
end
function o = ForceStep(o)              % Force Step Response           
   if ~type(o,{'spm'})
      plot(o,'About');
      return
   end

   index = arg(o,1);                   % get force component index
   if (index == 0)
      ForceStepOverview(o);
      return
   elseif (index >= 10)
      ForceStepOrbit(o,index/10);
      return
   end
   
   oo = Corasim(o);                    % convert to corasim object      
   Fmax = opt(o,{'Fmax',100});
   t = Time(o);
   u = StepInput(oo,t,index,Fmax);
   
   oo = sim(oo,u,[],t);
   [t,u,y,x] = var(oo,'t,u,y,x');
   
      % plot input signals (forces)
      
   m = size(u,1);
   for (i=1:m)
      sym = sprintf('F%g',i);
      diagram(o,'Force',sym,t,u(i,:),[m 3 3*i-2]);
      set(gca,'Ylim',[0 1.2*Fmax]);
   end

      % plot modes (internal state variables)
   
   modes = opt(o,{'view.modes',5});
   n = size(x,1);
   nx = min(modes,n/2);
   
   if (n/2 <= modes)
      for (i=1:nx)
         sym = sprintf('x%g',i);
         diagram(o,'Mode',sym,t,x(i,:),[nx 3 3*i-1]);
      end
   else
      diagram(o,'Mode','x',t,x,[1 3 2]);
   end
      
      % plot output signals (elongations)
      
   l = size(y,1);
   for (i=1:l)
      sym = sprintf('y%g',i);
      diagram(o,'Elongation',sym,t,y(i,:),[m 3 3*i]);
   end   
   
   heading(o,sprintf('Step Response: F%g->y - %s',index,Title(o)));
end
function o = ForceStepOverview(o)      % Force Step Response Overview  
   if ~type(o,{'spm'})
      plot(o,'About');
      return
   end
      
   B = data(o,'B');
   m = size(B,2);                      % number of inputs
   
   for (index=1:m)   
      oo = Corasim(o);                 % convert to corasim object      
      Fmax = opt(o,{'Fmax',100});
      t = Time(o);
      u = StepInput(oo,t,index,Fmax);

      oo = sim(oo,u,[],t);
      [t,u,y,x] = var(oo,'t,u,y,x');

         % plot output signals (elongations)

      l = size(y,1);
      for (i=1:l)
         sym = sprintf('y%g',i);
         diagram(o,'Elongation',sym,t,y(i,:),[l m i index]);
         title(sprintf('Elongation y%g (F%g)',i,index));
      end   
   end

   heading(o,sprintf('Step Response: F%g->y - %s',index,Title(o)));
end
function o = ForceStepOrbit(o,index)   % Force Step Orbit              
   if ~type(o,{'spm'})
      plot(o,'About');
      return
   end

   oo = Corasim(o);                    % convert to corasim object      
   Fmax = opt(o,{'Fmax',100});
   t = Time(o);
   u = StepInput(oo,t,index,Fmax);
   
   oo = sim(oo,u,[],t);
   [t,u,y,x] = var(oo,'t,u,y,x');
   
      % plot input signals (forces)
      
   m = size(u,1);
   for (i=1:m)
      sym = sprintf('F%g',i);
      diagram(o,'Force',sym,t,u(i,:),[m 3 3*(i-1)+1]);
      set(gca,'Ylim',[0 1.2*Fmax]);
   end
      
      % plot output signals (elongations)
      
   l = size(y,1);
   for (i=1:l)
      sym = sprintf('y%g',i);
      diagram(o,'Elongation',sym,t,y(i,:),[m 3 3*(i-1)+2]);
   end
   
      % plot output orbits (elongations)
      
   diagram(o,'Orbit','y3(y1)',y(1,:),y(3,:),[2 3 3]);
   diagram(o,'Orbit','y2(y1)',y(1,:),y(2,:),[2 3 6]);
   
   heading(o,sprintf('Step Response/Orbit: F%g->y - %s',index,Title(o)));
end

function o = Ramp(o)                   % Ramp Response                 
   if ~o.is(type(o),{'spm'})
      o = [];  return
   end
   
   oo = Corasim(o);                    % convert to corasim object   
   index = arg(o,1);
   t = Time(o);
   u = RampInput(oo,t,index);

   oo = sim(oo,u,[],t);
   plot(oo);
   
   heading(o,sprintf('Ramp Response: F%g->y (%s)',index,Title(o)));
end
function o = ForceRamp(o)              % Force Ramp Response           
   if ~type(o,{'spm'})
      plot(o,'About');
      return
   end

   index = arg(o,1);                   % get force component index
   if (index == 0)
      ForceRampOverview(o);
      return
   elseif (index >= 10)
      ForceRampOrbit(o,index/10);
      return
   end
   
   oo = Corasim(o);                    % convert to corasim object      
   Fmax = opt(o,{'Fmax',100});
   t = Time(o);
   u = RampInput(oo,t,index,Fmax);
   
   oo = sim(oo,u,[],t);
   [t,u,y,x] = var(oo,'t,u,y,x');
   
      % plot input signals (forces)
      
   m = size(u,1);
   for (i=1:m)
      sym = sprintf('F%g',i);
      diagram(o,'Force',sym,t,u(i,:),[m 3 3*i-2]);
      set(gca,'Ylim',[0 1.2*Fmax]);
   end

      % plot modes (internal state variables)
   
   modes = opt(o,{'view.modes',5});
   n = size(x,1);
   nx = min(modes,n/2);
   
   if (n/2 <= modes)
      for (i=1:nx)
         sym = sprintf('x%g',i);
         diagram(o,'Mode',sym,t,x(i,:),[nx 3 3*i-1]);
      end
   else
      diagram(o,'Mode','x',t,x,[1 3 2]);
   end
      
      % plot output signals (elongations)
      
   l = size(y,1);
   for (i=1:l)
      sym = sprintf('y%g',i);
      diagram(o,'Elongation',sym,t,y(i,:),[m 3 3*i]);
   end   
   
   heading(o,sprintf('Step Response: F%g->y - %s',index,Title(o)));
end
function o = ForceRampOverview(o)      % Force Ramp Response Overview  
   if ~type(o,{'spm'})
      plot(o,'About');
      return
   end
      
   B = data(o,'B');
   m = size(B,2);                      % number of inputs
   
   for (index=1:m)   
      oo = Corasim(o);                 % convert to corasim object      
      Fmax = opt(o,{'Fmax',100});
      t = Time(o);
      u = RampInput(oo,t,index,Fmax);

      oo = sim(oo,u,[],t);
      [t,u,y,x] = var(oo,'t,u,y,x');

         % plot output signals (elongations)

      l = size(y,1);
      for (i=1:l)
         sym = sprintf('y%g',i);
         diagram(o,'Elongation',sym,t,y(i,:),[l m (i-1)*m+index]);
         title(sprintf('Elongation y%g (F%g)',i,index));
      end   
   end

   heading(o,sprintf('Step Response: F%g->y - %s',index,Title(o)));
end
function o = ForceRampOrbit(o,index)   % Force Ramp Orbit              
   if ~type(o,{'spm'})
      plot(o,'About');
      return
   end

   oo = Corasim(o);                    % convert to corasim object      
   Fmax = opt(o,{'Fmax',100});
   t = Time(o);
   u = RampInput(oo,t,index,Fmax);
   
   oo = sim(oo,u,[],t);
   [t,u,y,x] = var(oo,'t,u,y,x');
   
      % plot input signals (forces)
      
   m = size(u,1);
   for (i=1:m)
      sym = sprintf('F%g',i);
      diagram(o,'Force',sym,t,u(i,:),[m 3 3*(i-1)+1]);
      set(gca,'Ylim',[0 1.2*Fmax]);
   end
      
      % plot output signals (elongations)
      
   l = size(y,1);
   for (i=1:l)
      sym = sprintf('y%g',i);
      diagram(o,'Elongation',sym,t,y(i,:),[m 3 3*(i-1)+2]);
   end
   
      % plot output orbits (elongations)
      
   diagram(o,'Orbit','y3(y1)',y(1,:),y(3,:),[2 3 3]);
   diagram(o,'Orbit','y2(y1)',y(1,:),y(2,:),[2 3 6]);
   
   heading(o,sprintf('Ramp Response/Orbit: F%g->y - %s',index,Title(o)));
end

function o = MotionRsp(o)              % Motion Response               
   if ~type(o,{'spm'})
      plot(o,'About');
      return
   end
   
   index = arg(o,1);                   % get force component index
   switch index
      case 31
      case 32
      case 33
         Hij = cache(o,'consd.H33');
   end
   
   [num,den] = peek(Hij);
   den = [den 0 0];
   Hij = poke(Hij,NaN,num,den);
   
   Hij = can(touch(Hij));
   display(Hij);
   
      % get motion as input signal
      
   [t,u] = MotionInput(o);
   
   oo = sim(o,u,[],t);
   [t,u,y,x] = var(oo,'t,u,y,x');
   
end
function [t,u] = MotionInput(o)        % Motion Input                  
   [smax,vmax,amax,tj] = opt(with(o,'motion'),'smax,vmax,amax,tj');
   oo = inherit(corasim,o);
   
   oo = data(oo,'smax,vmax,amax,tj',smax,vmax,amax,tj);
   oo = data(oo,'tunit,sunit','s','mm');
   oo.par.title = 'Motion Input';
   
   oo = with(oo,'simu');
   oo = motion(oo,'Brew');
   
   [t,u] = var(oo,'t,a');
end

%==========================================================================
% Plot Output Signals
%==========================================================================

function o = PlotY(o)                  % Plot Output Signals           
   Kms = var(o,{'Kms',1});             % time scaling correction
   ms = Kms*0.001;                     % factor ms/s
   um = 1e-6;
   
   o = corazon(o);                     % use CORAZON plot method
   [t,u,y] = data(o,'t,u,y');
   
   Plot11(o);                          % Elongation 1
   Plot12(o);                          % Elongation 2
   Plot21(o);                          % Elongation 3
   Plot22(o);                          % Input
   
   function Plot11(o)                  % Elongation 1                                              
      subplot(221);
      plot(o,t/ms,y(1,:)/um,'g');
      title('Output (Elongation 1)');
      xlabel('t [ms]');  ylabel('y1 [um]');
      grid(o);
   end
   function Plot12(o)                  % Elongation 2                                              
      subplot(222);
      plot(o,t/ms,y(2,:)/um,'c');
      title('Output (Elongation 2)');
      xlabel('t [ms]');  ylabel('y2 [um]');
      grid(o);
   end
   function Plot21(o)                  % Elongation 3                                              
      subplot(223);
      plot(o,t/ms,y(3,:)/um,'r');
      title('Output (Elongation 3)');
      xlabel('t [ms]');  ylabel('y3 [um]');
      grid(o);
   end
   function Plot22(o)                                                  
      subplot(224);
      plot(o,t/ms,u,'b');
      title('Input (Force)');
      xlabel('t [ms]');  ylabel('F [N]');
      grid(o);
   end
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

