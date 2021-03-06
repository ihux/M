function probability(obj,varargin)
% 
% PROBABILITY  Probability Demos
%
%        Setup demo menu & handle menu callbacks of user defined menu items
%        The function needs creation and setup of a chameo object:
%
%             probability(tensor)         % open menu and add demo menus
%             probability(tensor,'Setup') % add demo menus to existing menu
%             probability(tensor,func)    % handle callbacks
%
%             obj = gfo;               % retrieve obj from menu's user data
%
%        See also   TENSOR, SHELL, MENU, GFO
%
   obj = topic(obj,gcbo);

   [cmd,obj,list,func] = dispatch(obj,varargin,{{'@','invoke'}},'Setup');
   eval(cmd);
   return
end

%==========================================================================
% Setup the Roll Down Menu
%==========================================================================

function Setup(obj)
%
% SETUP       Setup the roll down menu for Alastair
%
   [LB,CB,UD,EN,CHK,CHKR,VI,CHC,CHCR,MF] = shortcuts(obj);

   %men = mount(obj,'<main>',LB,'Probability');
   ob1 = mitem(obj,'Basics');
   men = mitem(ob1);
   
   sub = uimenu(men,LB,'Born Rule');
   itm = uimenu(sub,LB,'Weight Calculation',CB,call('@BornRule'),UD,1);
   itm = uimenu(sub,LB,'Wave Packet 1',CB,call('@BornRule'),UD,2);
   itm = uimenu(sub,LB,'Wave Packet 2',CB,call('@BornRule'),UD,3);
   itm = uimenu(sub,LB,'Probability Distribution',CB,call('@BornRule'),UD,4);
   itm = uimenu(sub,LB,'Odd Split',CB,call('@BornRule'),UD,5);

   sub = uimenu(men,LB,'Chain Operator');
   itm = uimenu(sub,LB,'Chain Operator Basics',CB,call('@ChainOperator'),UD,0);
   itm = uimenu(sub,LB,'Weight Calculation',CB,call('@ChainOperator'),UD,1);
   
   return
end

%==========================================================================
% Evaluate & Echo
%==========================================================================

function Eval(cmd)
%
% EVAL    Evaluate in base work space
%
   fprintf(['>> ',cmd,'\n']);
   evalin('base',cmd);
   return
end

function Echo(line)
%
% ECHO   Echo a line
%
   if (nargin == 0)
      fprintf('%%\n');
   else
      fprintf(['%% ',line,'\n']);
   end
   return
end

function Disp(arg1,arg2)
%
% DISP  Display a text line in window
%
%          Disp;                      % clear screen and initialize
%          Disp('my text');           % display text
%          Disp(obj,'My Heading');    % display a heading
%
   if (nargin == 0)
      cls;
      text(gao,'','position','home');
   elseif (nargin == 1)
      line = arg1;  text(gao,[line,'\n']);
      idx = find(line=='�');  line(idx) = [];
      Echo(line);
   elseif (nargin == 2)
      heading = get(arg1,'task');
      topic(arg1);  Disp(['��',heading]);
   end
   return
end

%==========================================================================
% Born Rule Demos
%==========================================================================
   
function BornRule(obj)
%      
% BORN-RULE    Born rule demos
%
   Disp(obj,'');
   mode = arg(obj,1);
   switch mode
      case 1
         Echo('Construct a Hilbert space H');
         Echo;
         Eval('H = space([1 3 5; 2 4 6]);         %% our Hilbert space');
         Eval('labels(H)                          %% label matrix');
         Eval('T = operator(H,''>>'');              %% transition operator');
         Eval('psi0 = ket(H,''3'')               %% initial state');     
         Echo
         Echo('Assign a weight to the vector of interest according to Born rule;');
         Echo
         Eval('disp(born(T,psi0,ket(H,''3'')))     %% assign Born weight');
         Eval('disp(born(T,psi0,ket(H,''4'')))     %% assign Born weight');
         Eval('disp(born(T,psi0,ket(H,''5'')))     %% assign Born weight');
         Eval('disp(born(T,psi0,ket(H,''6'')))     %% assign Born weight');
         Echo
         Echo('Define any ket vector of interest:');
         Echo
         Eval('psi = unit(ket(H,''4'')+2*ket(H,''5''))  %% vector of interest');
         Echo
         Eval('W = born(T,psi0,psi); disp(W)        %% assign Born weight');
         Eval('W = born(T*T,psi0,psi); disp(W)      %% assign Born weight');
         Echo
         PlotBornRule(obj,1);                     % graphical display
         return

      case 2
         Eval('H = space([1 4 7; 2 5 8; 3 6 9]);  %% our Hilbert space');
         Eval('labels(H)                          %% label matrix');
         Eval('T = operator(H,''>>'');              %% transition operator');
         Echo
         Eval('V1 = ket(H,''1'');                   %% auxillary vector');     
         Eval('V2 = ket(H,''2'');                   %% auxillary vector');     
         Eval('V3 = ket(H,''3'');                   %% auxillary vector');     
         Eval('V4 = ket(H,''4'');                   %% auxillary vector');     
         Eval('V5 = ket(H,''5'');                   %% auxillary vector');
         Eval('V6 = ket(H,''6'');                   %% auxillary vector');
         Eval('V7 = ket(H,''7'');                   %% auxillary vector');
         Echo
         Eval('psi0 = unit(V1+2*V2+3*V3)          %% initial vector');     
         Echo
         Echo('Assign a weight to the vector of interest according to Born rule;');
         Echo
         Eval('disp(born(T,psi0,V1))              %% assign Born weight');
         Eval('disp(born(T,psi0,V2))              %% assign Born weight');
         Eval('disp(born(T,psi0,V3))              %% assign Born weight');
         Eval('disp(born(T,psi0,V4))              %% assign Born weight');
         Eval('disp(born(T,psi0,V5))              %% assign Born weight');
         Eval('disp(born(T,psi0,V6))              %% assign Born weight');
         Eval('disp(born(T,psi0,V7))              %% assign Born weight');
         Echo
         PlotBornRule(obj,2);                     % graphical display
         return

      case 3
         Eval('H = space([1 4 7; 2 5 8; 3 6 9]);  %% our Hilbert space');
         Eval('labels(H)                          %% label matrix');
         Eval('T = operator(H,''>>'');              %% transition operator');
         Echo
         Eval('V1 = ket(H,''1'');                   %% auxillary vector');     
         Eval('V2 = ket(H,''2'');                   %% auxillary vector');     
         Eval('V3 = ket(H,''3'');                   %% auxillary vector');     
         Eval('V5 = ket(H,''5'');                   %% auxillary vector');
         Eval('V6 = ket(H,''6'');                   %% auxillary vector');
         Eval('V7 = ket(H,''7'');                   %% auxillary vector');
         Echo
         Eval('psi0 = unit(V1+2*V2+3*V3)          %% initial vector');     
         Eval('psi1 = unit(V5+2*V6+3*V7)          %% vector of interest');     
         Echo
         Echo('Assign a weight to the vector of interest according to Born rule;');
         Echo
         Eval('disp(born(T^1,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^2,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^3,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^4,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^5,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^6,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^7,psi0,psi1))          %% assign Born weight');
         Echo
         PlotBornRule(obj,3);                     % graphical display
         return

      case 4
         Echo('Construct a Hilbert space H');
         Echo;
         Eval('H = space([1 3 5; 2 4 6]);         %% our Hilbert space');
         Eval('labels(H)                          %% label matrix');
         Eval('T = operator(H,''>>'');              %% transition operator');
         Eval('V1 = ket(H,''1'');                   %% auxillary vector');     
         Eval('V2 = ket(H,''2'');                   %% auxillary vector');     
         Eval('V3 = ket(H,''3'');                   %% auxillary vector');     
         Eval('psi0 = unit(V1+2*V2+V3)            %% initial state');     
         Echo
         Echo('Construct a decomposition of the Hilbert space');
         Echo
         Eval('S = split(H,labels(H))');
         Echo
         Echo('Calculate probabilities according to the Born rule;');
         Echo
         Eval('p = born(T,psi0,S)                 %% assign Born weight');
         Echo
         PlotBornRule(obj,4,{'[1]','[2]','[3]','[4]','[5]','[6]',''});                     % graphical display
         return

      case 5
         Echo('Construct a Hilbert space H');
         Echo;
         Eval('H = space([1 3 5; 2 4 6]);         %% our Hilbert space');
         Eval('labels(H)                          %% label matrix');
         Eval('T = operator(H,''>>'');              %% transition operator');
         Eval('V1 = ket(H,''1'');                   %% auxillary vector');     
         Eval('V2 = ket(H,''2'');                   %% auxillary vector');     
         Eval('V3 = ket(H,''3'');                   %% auxillary vector');     
         Eval('psi0 = unit(V1+2*V2+V3)            %% initial state');     
         Echo
         Echo('Construct an odd decomposition of the Hilbert space');
         Echo
         Eval('S = split(H,{''1'',{''2'',''4''},''3'',{''5'',''6''}})');
         Echo
         Echo('Calculate probabilities according to the Born rule;');
         Echo
         Eval('p = born(T,psi0,S)                 %% assign Born weight');
         Echo
         PlotBornRule(obj,4,{'[1]','[2,4]','[3]','[5,6]',''});                     % graphical display
         return

   end
   return
end

%==========================================================================
% Plot Borne Rule
%==========================================================================

function PlotBornRule(obj,mode,xticks)
%
% PLOT-BORN-RULE
%
   Disp(obj,'');
   switch mode
      case 1
         cls;    % clear screen
         
         psi0 = evalin('base','psi0');
         psi = evalin('base','psi');
         T = evalin('base','T');
         
         y0 = psi0+0;  y0 = y0(:);
         y1 = psi+0;  y1 = y1(:);
         
         m = 2;  n = 2;  k = 0; delta = 0.1;
         idx = [1 3 2 4];
         for (j=1:n)
            for (i=1:m)
               k = k+1;
               y = T^(k-1)*psi0+0;  y = y(:);
               subplot(m,n,idx(k));
               hdl = stem((1:length(y0))-delta,y0,'k');  hold on;
               color(hdl,'y');
               stem((1:length(y)),y,'b');  
               stem((1:length(y1))+delta,y1,'r');  
               title(sprintf('born(T^%g,psi0,psi) = %g',k-1,born(T^(k-1),psi0,psi)));
               ylabel(sprintf('psi0 (g), T^%gpsi0 (b), psi (r)',k-1));
               set(gca,'xlim',[0 6]);
               set(gca,'xtick',0:6);
            end
         end
         %xlabel('psi0: gray, T^kpsi0: blue, psi1: red');
         shg;
         return

      case 2
         cls;    % clear screen
         
         psi0 = evalin('base','psi0');
         psi1 = evalin('base','psi1');
         T = evalin('base','T');
         
         y0 = psi0+0;  y0 = y0(:);
         y1 = T*psi0+0;  y1 = y1(:);
         
         m = 3;  n = 2;  k = 0; delta = 0.1;
         idx = [1 3 5 2 4 6];
         for (j=1:n)
            for (i=1:m)
               k = k+1;
               cmd = sprintf('V%g;',k);
               V = evalin('base',cmd);
               v = V+0;    v = v(:);
               subplot(m,n,idx(k));
               hdl = stem((1:length(y0))-delta,y0,'k');  hold on;
               color(hdl,'y');
               stem((1:length(y1)),y1,'b');  
               stem((1:length(v))+delta,v,'r');  
               title(sprintf('born(T,psi0,V%g) = %g',k,born(T,psi0,V)));
               ylabel(sprintf('psi0, T*psi0, V%g',k));
               set(gca,'xlim',[0 10]);
               set(gca,'xtick',0:10);
            end
         end
         shg;
         return
   
      case 3
         cls;    % clear screen
         
         psi0 = evalin('base','psi0');
         psi1 = evalin('base','psi1');
         T = evalin('base','T');
         
         y0 = psi0+0;  y0 = y0(:);
         y1 = psi1+0;  y1 = y1(:);
         
         m = 3;  n = 2;  k = 0; delta = 0.1;
         idx = [1 3 5 2 4 6];
         for (j=1:n)
            for (i=1:m)
               k = k+1;
               y = T^k*psi0+0;  y = y(:);
               subplot(m,n,idx(k));
               hdl = stem((1:length(y0))-delta,y0,'k');  hold on;
               color(hdl,'y');
               stem((1:length(y)),y,'b');  
               stem((1:length(y1))+delta,y1,'r');  
               title(sprintf('born(T^%g,psi0,psi1) = %g',k,born(T^k,psi0,psi1)));
               ylabel(sprintf('psi0, T^%g*psi0, psi1',k));
               set(gca,'xlim',[0 10]);
               set(gca,'xtick',0:10);
            end
         end
         shg;
         return

      case 4
         cls;    % clear screen
         
         psi0 = evalin('base','psi0');
         psi = evalin('base','psi');
         T = evalin('base','T');
         p = evalin('base','p');
         
         y0 = psi0+0;  y0 = y0(:);
         y1 = psi+0;  y1 = y1(:);
         
         m = 2;  n = 1;  k = 0; delta = 0.1;
         idx = [1 2];

         y = T^(k-1)*psi0+0;  y = y(:);
         subplot(2,1,1);
         stem((1:6)-delta,ones(1,6)/6,'g');        hold on;
         hdl = stem((1:length(y0))-delta,y0,'k');  hold on;
         color(hdl,'y');
         stem((1:length(y)),y,'b');  
         title(sprintf('born(T,psi0,psi) = %g',born(T^(k-1),psi0,psi)));
         ylabel(sprintf('psi0 (y), T*gpsi0 (b)'));
         set(gca,'xlim',[0 6]);
         set(gca,'xtick',0:6);

         subplot(2,1,2);
         delta = 0.05;
         stem((1:length(p(:)))+delta,p(:),'m');  hold on;
         ylabel(sprintf('S (g), probability (m)'));
         set(gca,'xlim',[0 length(xticks)],'ylim',[0 1]);
         set(gca,'xtick',1:length(xticks));
         set(gca,'xticklabel',xticks);
         
         %xlabel('psi0: gray, T^kpsi0: blue, psi1: red');
         shg;
         return

   end
   return
end

%==========================================================================
% Chain Operator
%==========================================================================
   
function ChainOperator(obj)
%      
% CHAIN-OPERATOR    Chain operator rule demos
%
   Disp(obj,'');
   mode = args(obj,1);
   switch mode
      case 0
         Echo('Construct a Hilbert space H');
         Echo;
         Eval('H = space(tensor,[1 3 5; 2 4 6]);  %% our Hilbert space');
         Eval('H = setup(H,''psi0'',vector(H,''3''))');
         Eval('H = setup(H,''psi'',normalize(vector(H,''4'')+2*vector(H,''5'')))');
         Echo
         Eval('labels(H)                          %% label matrix');
         Eval('T = operator(H,''>>'');            %% transition operator');
         Echo
         Echo('Chain operator calculation based on projectors');
         Echo
         Eval('Psi0 = projector(H,''psi0'')       %% initial projector');     
         Eval('P4  = projector(H,''4'')');
         Eval('P56 = projector(H,{''5'',''6''})');
         Echo
         Eval('C1 = chain(T,Psi0,P4,P56)');
         Echo
         Echo('Alternative way: chain operator calculation based on labels');
         Echo
         Eval('C2 = chain(T,''psi0'',''4'',''5,6'');');
         Eval('C2-C1');
         Echo
         Eval('C3 = chain(T,''psi0'',''4'',{''5'',''6''});');
         Eval('C3-C1');
         Echo
         
      case 1
         Echo('Construct a Hilbert space H');
         Echo;
         Eval('H = space(tensor,[1 3 5; 2 4 6]);  %% our Hilbert space');
         Eval('H = setup(H,''psi0'',vector(H,''3''))');
         Eval('H = setup(H,''psi'',normalize(vector(H,''4'')+2*vector(H,''5'')))');
         Echo
         Eval('labels(H)                          %% label matrix');
         Eval('T = operator(H,''>>'');              %% transition operator');
         Eval('psi0 = vector(H,''psi0'')            %% initial state');     
         Echo
         Echo('Assign a weight to the vector of interest according to Born rule;');
         Echo
         Eval('disp(born(T,psi0,vector(H,''3'')))     %% assign Born weight');
         Eval('disp(born(T,psi0,vector(H,''4'')))     %% assign Born weight');
         Eval('disp(born(T,psi0,vector(H,''5'')))     %% assign Born weight');
         Eval('disp(born(T,psi0,vector(H,''6'')))     %% assign Born weight');
         Echo
         Echo('Define any vector of interest:');
         Echo
         Eval('psi = vector(H,''psi'')              %% vector of interest');
         Echo
         Eval('Psi0 = projector(H,''psi0'')');
         Eval('Psi  = projector(H,''psi'')');
         Echo
         Eval('W1 = born(T,psi0,psi); disp(W1)       %% assign Born weight');
         Eval('C1 = chain(T,Psi0,Psi)                %% chain operator');
         Eval('W1 = norm(C1)^2; disp(W1);            %% weight by chain operator');
         Eval('C1 = chain(T,''psi0'',''psi'')            %% chain operator');
         Eval('W1 = norm(C1)^2; disp(W1);            %% weight by chain operator');
         Echo
         Eval('W2 = born(T*T,psi0,psi); disp(W2)     %% assign Born weight');
         Eval('C2 = chain(T*T,Psi0,Psi)              %% chain operator');
         Eval('W2 = norm(C2)^2; disp(W2);            %% weight by chain operator');
         Eval('C2 = chain(T*T,''psi0'',''psi'')          %% chain operator');
         Eval('W2 = norm(C2)^2; disp(W2);            %% weight by chain operator');
         Echo
         PlotChainOperator(obj,1);                     % graphical display
         return

      case 2
         Eval('H = space(tensor,[1 4 7; 2 5 8; 3 6 9]);  %% our Hilbert space');
         Eval('labels(H)                          %% label matrix');
         Eval('T = operator(H,''>>'');              %% transition operator');
         Echo
         Eval('V1 = vector(H,''1'');                %% auxillary vector');     
         Eval('V2 = vector(H,''2'');                %% auxillary vector');     
         Eval('V3 = vector(H,''3'');                %% auxillary vector');     
         Eval('V4 = vector(H,''4'');                %% auxillary vector');     
         Eval('V5 = vector(H,''5'');                %% auxillary vector');
         Eval('V6 = vector(H,''6'');                %% auxillary vector');
         Eval('V7 = vector(H,''7'');                %% auxillary vector');
         Echo
         Eval('psi0 = normalize(V1+2*V2+3*V3)     %% initial vector');     
         Echo
         Echo('Assign a weight to the vector of interest according to Born rule;');
         Echo
         Eval('disp(born(T,psi0,V1))              %% assign Born weight');
         Eval('disp(born(T,psi0,V2))              %% assign Born weight');
         Eval('disp(born(T,psi0,V3))              %% assign Born weight');
         Eval('disp(born(T,psi0,V4))              %% assign Born weight');
         Eval('disp(born(T,psi0,V5))              %% assign Born weight');
         Eval('disp(born(T,psi0,V6))              %% assign Born weight');
         Eval('disp(born(T,psi0,V7))              %% assign Born weight');
         Echo
         PlotChainOperator(obj,2);                     % graphical display
         return

      case 3
         Eval('H = space(tensor,[1 4 7; 2 5 8; 3 6 9]);  %% our Hilbert space');
         Eval('labels(H)                          %% label matrix');
         Eval('T = operator(H,''>>'');              %% transition operator');
         Echo
         Eval('V1 = vector(H,''1'');                %% auxillary vector');     
         Eval('V2 = vector(H,''2'');                %% auxillary vector');     
         Eval('V3 = vector(H,''3'');                %% auxillary vector');     
         Eval('V5 = vector(H,''5'');                %% auxillary vector');
         Eval('V6 = vector(H,''6'');                %% auxillary vector');
         Eval('V7 = vector(H,''7'');                %% auxillary vector');
         Echo
         Eval('psi0 = normalize(V1+2*V2+3*V3)     %% initial vector');     
         Eval('psi1 = normalize(V5+2*V6+3*V7)     %% vector of interest');     
         Echo
         Echo('Assign a weight to the vector of interest according to Born rule;');
         Echo
         Eval('disp(born(T^1,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^2,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^3,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^4,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^5,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^6,psi0,psi1))          %% assign Born weight');
         Eval('disp(born(T^7,psi0,psi1))          %% assign Born weight');
         Echo
         PlotChainOperator(obj,3);                     % graphical display
         return
   end
   return
end

%==========================================================================
% Plot Chain Operator Demos
%==========================================================================

function PlotChainOperator(obj,mode)
%
% PLOT-BORN-RULE
%
   Disp(obj,'');
   switch mode
      case 1
         cls;    % clear screen
         
         psi0 = evalin('base','psi0');
         psi = evalin('base','psi');
         T = evalin('base','T');
         
         y0 = psi0+0;  y0 = y0(:);
         y1 = psi+0;  y1 = y1(:);
         
         m = 2;  n = 2;  k = 0; delta = 0.1;
         idx = [1 3 2 4];
         for (j=1:n)
            for (i=1:m)
               k = k+1;
               y = T^(k-1)*psi0+0;  y = y(:);
               subplot(m,n,idx(k));
               hdl = stem((1:length(y0))-delta,y0,'k');  hold on;
               color(hdl,0.9*[1 1 1]);
               stem((1:length(y)),y,'b');  
               stem((1:length(y1))+delta,y1,'r');  
               title(sprintf('born(T^%g,psi0,psi) = %g',k-1,born(T^(k-1),psi0,psi)));
               ylabel(sprintf('psi0 (g), T^%gpsi0 (b), psi (r)',k-1));
               set(gca,'xlim',[0 6]);
               set(gca,'xtick',0:6);
            end
         end
         %xlabel('psi0: gray, T^kpsi0: blue, psi1: red');
         shg;
         return

      case 2
         cls;    % clear screen
         
         psi0 = evalin('base','psi0');
         psi1 = evalin('base','psi1');
         T = evalin('base','T');
         
         y0 = psi0+0;  y0 = y0(:);
         y1 = T*psi0+0;  y1 = y1(:);
         
         m = 3;  n = 2;  k = 0; delta = 0.1;
         idx = [1 3 5 2 4 6];
         for (j=1:n)
            for (i=1:m)
               k = k+1;
               cmd = sprintf('V%g;',k);
               V = evalin('base',cmd);
               v = V+0;    v = v(:);
               subplot(m,n,idx(k));
               hdl = stem((1:length(y0))-delta,y0,'k');  hold on;
               color(hdl,0.9*[1 1 1]);
               stem((1:length(y1)),y1,'b');  
               stem((1:length(v))+delta,v,'r');  
               title(sprintf('born(T,psi0,V%g) = %g',k,born(T,psi0,V)));
               ylabel(sprintf('psi0, T*psi0, V%g',k));
               set(gca,'xlim',[0 10]);
               set(gca,'xtick',0:10);
            end
         end
         shg;
         return
   
      case 3
         cls;    % clear screen
         
         psi0 = evalin('base','psi0');
         psi1 = evalin('base','psi1');
         T = evalin('base','T');
         
         y0 = psi0+0;  y0 = y0(:);
         y1 = psi1+0;  y1 = y1(:);
         
         m = 3;  n = 2;  k = 0; delta = 0.1;
         idx = [1 3 5 2 4 6];
         for (j=1:n)
            for (i=1:m)
               k = k+1;
               y = T^k*psi0+0;  y = y(:);
               subplot(m,n,idx(k));
               hdl = stem((1:length(y0))-delta,y0,'k');  hold on;
               color(hdl,0.9*[1 1 1]);
               stem((1:length(y)),y,'b');  
               stem((1:length(y1))+delta,y1,'r');  
               title(sprintf('born(T^%g,psi0,psi1) = %g',k,born(T^k,psi0,psi1)));
               ylabel(sprintf('psi0, T^%g*psi0, psi1',k));
               set(gca,'xlim',[0 10]);
               set(gca,'xtick',0:10);
            end
         end
         shg;
         return

   end
   return
end
