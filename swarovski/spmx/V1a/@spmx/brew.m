function oo = brew(o,varargin)         % SPMX Brew Method               
%
% BREW   Brew data
%
%           oo = brew(o);                   % brew all
%
%           oo = brew(o,'Eigen')            % brew eigen values
%           oo = brew(o,'Normalize')        % brew time scaled system
%           oo = brew(o,'Partial')          % brew partial matrices
%           oo = brew(p,'TrfMatrix')        % brew transfer matrix
%
%        
   [gamma,oo] = manage(o,varargin,@Brew,@Eigen,@Normalize,@Partial,...
                                  @TrfMatrix);
   oo = gamma(oo);
end              

%==========================================================================
% Brew All
%==========================================================================

function oo = Brew(o)                  % Brew All                     
   oo = o;
   oo = Normalize(oo);                 % first normalize the system
end

function oo = Eigen(o)
   oo = o;                             % copy to out arg
   A = data(oo,'A');
   
   ev = eig(A);                        % eigenvalues (EV)
   i = 1:length(ev);                   % EV index 
   x = real(ev);                       % real value
   y = imag(ev);                       % imag value
   [~,idx] = sort(abs(imag(ev)));
   
      % store calculated stuff in cache
      
   oo = cache(oo,'eigen.index',i);
   oo = cache(oo,'eigen.real',x);
   oo = cache(oo,'eigen.imag',y);
end

%==========================================================================
% Partial and Normalizing
%==========================================================================

function oo = Partial(o)               % Normalize System              
   [A,B,C] = get(o,'system','A,B,C');

   n = floor(length(A)/2);
   i1 = 1:n;  i2 = n+1:2*n;
   
   A11 = A(i1,i1);  A12 = A(i1,i2);
   A21 = A(i2,i1);  A22 = A(i2,i2);
  
   B1 = B(i1,:);  B2 = B(i2,:);   
   C1 = C(:,i1);  C2 = C(:,i2);
  
   oo = var(o,'A11,A12,A21,A22',A11,A12,A21,A22);
   oo = var(oo,'B1,B2,C1,C2',B1,B2,C1,C2);
end
function oo = Normalize(o)             % Normalize System              
   T0 = opt(o,{'brew.T0',1e-3});       % normalization time constant

      % normalize system
      
   [A,B,C] = get(o,'system','A,B,C');

   n = floor(length(A)/2);
   i1 = 1:n;  i2 = n+1:2*n;
   
   A(i2,i1) = T0*T0*A(i2,i1);
   A(i2,i2) = T0*A(i2,i2);
   B(i2,:)  = T0*B(i2,:);
   C(:,i1) = C(:,i1)*T0;
   
      % refresh system
      
   oo = set(o,'system','A,B,C,T0',A,B,C,T0);
      
      % update simulation parameters
      
   oo = opt(oo,'simu.tmax',opt(o,'simu.tmax')/T0);
   oo = opt(oo,'simu.dt',opt(o,'simu.dt')/T0);
   
      % set time scale correction for plot routines
      
   oo = var(oo,'Kms',1/T0);
end

%==========================================================================
% Transfer Matrix
%==========================================================================

function oo = TrfMatrix(o)             % Transfer Matrix               
   [A,B,C] = get(o,'system','A,B,C');
   n = length(A)/2;  [m,l] = size(C*B);
   
   for (i=1:m)
      for (j=1:l)
         Gij = trffct(o,i,j);
         G{i,j} = Gij;
Gij = set(trf(Gij{1},Gij{2}),'title',sprintf('G%d%d(s)',i,j));
can(Gij)
      end
   end
   oo = var(o,'G',G);
end
