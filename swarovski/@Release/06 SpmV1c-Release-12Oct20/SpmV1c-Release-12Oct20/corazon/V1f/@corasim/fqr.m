function [Gjw,om] = fqr(o,om,i,j)
%
% FQR  Frequency response of transfer function.
%
%		    Gjw = fqr(G,omega)
%		    Gjw = fqr(G,omega,i,j)
%
%      Auto omega:
%
%		    [Gjw,omega] = fqr(G)
%		    [Gjw,omega] = fqr(G,[],i,j)
%
%	    Calculation of complex frequency response of a transfer function 
%      G(s) = num(s(/den(s) (omega may be a vector argument).
%	    The calculations depend on the type as follows:
%
%		     fqr(Gs,omega):  Gs(j*omega)		      (s-domain)
%		     fqr(Hz,omega):  Hz(exp(j*omega*Ts))	(z-domain)
%		     fqr(Gq,Omega):  Gq(j*Omega)		      (q-domain)
%
%      Remarks: system representations in modal form are computed in a 
%      special way to achieve good numerical results for high system orders
%
%          oo = system(o,A,B,C,D)      % let oo be a modal form
%          Fjw = rsp(oo,om,i,j)        % frequency response of Gij(j*om)
%
%      Options:
%         input              input index (default 1)
%         output             output index (default 1)
%
%      Copyright(c): Bluenetics 2020
%
%      See also: CORASIM, SYSTEM, PEEK, TRIM, BODE
%
   if (nargin <= 1) || isempty(om)
      oml = opt(o,{'omega.low',1e-5});
      omh = opt(o,{'omega.high',1e5});
      points = opt(o,{'omega.points',1000});
      om = logspace(log10(oml),log10(omh),points);
   end

   switch o.type
      case {'strf','qtrf'}
         [num,den] = peek(o);
         jw = sqrt(-1)*om;
         Gjw = polyval(num,jw) ./ polyval(den,jw);
         
      case {'ztrf','dss'}
         [num,den] = peek(o);
         T = data(o,'T');
         expjw = exp(sqrt(-1)*om*T);
         Gjw = polyval(num,expjw) ./ polyval(den,expjw);

      case {'szpk','qzpk'}
         [num,den] = peek(o);
         jw = sqrt(-1)*om;
         Gjw = polyval(num,jw) ./ polyval(den,jw);

      case 'css'
         if (nargin < 3)
            i = 1;
         end
         if (nargin < 4)
            j = 1;
         end
         
         oo = Partition(o);
         if ismodal(oo)
            Gjw = Modal(o,om,i,j);
         else
            [num,den] = peek(o,i,j);
            jw = sqrt(-1)*om;
            Gjw = polyval(num,jw) ./ polyval(den,jw);
         end
         
      case {'modal'}
         i = opt(o,{'output',1});
         j = opt(o,{'input',1});
         Gjw = Modal(o,om,i,j);        % frequency response of modal Gij(s)
         
         %[num,den] = peek(o);
         %jw = sqrt(-1)*om;
         %Gjw = polyval(num,jw) ./ polyval(den,jw);

      otherwise
         error('bad type');
   end
end

%==========================================================================
% Frequency Response of a Modal Form
%==========================================================================

function Gjw = Modal(o,om,i,j)         % Frequency Rsp. of a Modal Form
%
% MODAL  Frequency response Gij(j*om) of a modal form refering to transfer
%        function Gij(s) (i-th output, j-th input)
%
%        Partial system:
%
%           z(k)` = v(k) + Bz(k,j)*u(j)
%           v(k)` = -a0(k)*z(k) - a1(k)*v(k) + Bv(k,j)'*u(j)
%           y(i,k) = Cz(i,k)*z(k) + Cv(i,k)*v(k)
%
%           y(i) = y(i,1) + ... + y(i,n) + D*u
%
%        Laplace Transformation:
%
%           s*Z(k) = V(k) + Bz(k,j)*U(j)
%           Z(k) = 1/s * [V(k) + Bz(k,j)*U(j)]
%
%           s*V(k) = -a0(k)*Z(k) - a1(k)*V(k) + Bv(k,j)*U(j)
%           Y(i,k) = Cz(i,k)*Z(k) + Cv(i,k)*V(k)
%
%        Substitute s*Z(k) = V(k) + Bz(k,j)*U(j)
%
%           s^2*V(k) = -a0(k)*[s*Z(k)] - s*a1(k)*V(k) + s*Bv(k,j)*U(j)
%           s^2*V(k) = -a0(k)*[V(k) + Bz(k,j)*U(j)] -
%                      - s*a1(k)*V(k) + s*Bv(k,j)*U(j)
%           [s^2 + a1(k)*s + a0(k)]*V(k) = [s*Bv(k,j) - a0(k)*Bz(k,j)]*U(j)
%
%           V(k) = [s*Bv(k,j)-a0(k)*Bz(k,j)] / [s^2+a1(k)*s+a0(k)] * U(j) 
%
%        Transfer function: V(k) = Fijk(s) * U(j)
%
%           Fijk(s) = [s*Bv(k,j)-a0(k)*Bz(k,j)] / [s^2+a1(k)*s+a0(k)]
%
%           Z(k) = 1/s * [V(k) + Bz(k,j)*U(j)] = 
%                = 1/s * [Fijk(s)*U(j) + Bz(k,j)*U(j)] = 
%                = [Fijk(s) + Bz(k,j)]/s * U(j)
%          
%           Y(i,k) = Cz(i,k)*Z(k) + Cv(i,k)*V(k) =
%                  = {Cz(i,k)/s*[Fijk(s) + Bz(k,j)]+Cv(i,k)*Fijk(s)} * U(j)
%
%        Transfer function: Y(i,k) = Gijk(s) * U(j)
%
%           Fijk(s) = [s*Bv(k,j)-a0(k)*Bz(k,j)] / [s^2+a1(k)*s+a0(k)]
%           Gijk(s) = Cz(i,k)/s * [Fijk(s) + Bz(k,j)] + Cv(i,k) * Fijk(s)
%
%        Total Transfer function
%                     n
%           Gij(s) = Sum{Gijk(s)} + D
%                    k=1
%
   if ~type(o,{'modal'})
      error('modal form expected');
   end
   
   [a0,a1,B,C,D] = data(o,'a0,a1,B,C,D');
   
   n = length(a0);  
   m = size(B,2);                      % number of inputs
   l = size(C,1);                      % number of outputs
   
   if (i < 1 || i > l)
      error('bad output index');
   end
   if (j < 1 || j > m)
      error('bad input index');
   end
   
   i1 = 1:n;  i2 = n+1:2*n;
   Bz = B(i1,:);  Bv = B(i2,:);
   Cz = C(:,i1);  Cv = C(:,i2); 
   
      % loop through all modes
      % Fijk(s) = [s*Bv(k,j)-a0(k)*Bz(k,j)] / [s^2+a1(k)*s+a0(k)]
      % Gijk(s) = Cz(i,k)/s * [Fijk(s) + Bz(k,j)] + Cv(i,k) * Fijk(s)
      %               n
      % Gij(s) = D + Sum{Gijk(s)}
      %              k=1
      
   jw = om*sqrt(-1);
   Gjw = D(i,j);                       % init value of frequency response
   
   for (k=1:n)      
      Fijk = [jw*Bv(k,j) - a0(k)*Bz(k,j)] ./ [jw.*jw + a1(k)*jw + a0(k)];
      Gijk = Cz(i,k)./jw .* [Fijk + Bz(k,j)] + Cv(i,k) * Fijk;
      Gjw = Gjw + Gijk;
   end
end

%==========================================================================
% Helper
%==========================================================================

function oo = Partition(o)             % Partition System Matrices     
   [A,B,C] = data(o,'A,B,C');

   n = floor(length(A)/2);
   if (2*n ~= length(A))
      oo = [];
      return
   end
   
   i1 = 1:n;  i2 = n+1:2*n;
   
   A11 = A(i1,i1);  A12 = A(i1,i2);
   A21 = A(i2,i1);  A22 = A(i2,i2);
  
   B1 = B(i1,:);  B2 = B(i2,:);   
   C1 = C(:,i1);  C2 = C(:,i2);
   
   M = B2;  a0 = -diag(A21);  a1 = -diag(A22);
   omega = sqrt(a0);  zeta = a1./omega/2;
   
   oo = var(o,'A11,A12,A21,A22',A11,A12,A21,A22);
   oo = var(oo,'B1,B2,C1,C2',B1,B2,C1,C2);
   oo = var(oo,'M,a0,a1,omega,zeta',M,a0,a1,omega,zeta);
end

