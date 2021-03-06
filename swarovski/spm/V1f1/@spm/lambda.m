function [oo,g31,g33] = lambda(o,varargin)  % Spectral Frequency Responses
%
% LAMBDA  Calculate spectral frequency responses lambda(s) for an open
%         loop system. Result is an FQR typed corasim system
%
%            o = with(o,'critical');  
%            sys = system(o,cdx);      % contact related system 
%            l0 = lambda(o,sys);       % spectral frequency transfer system
%
%            l0 = lambda(o);           % implicite call to system(o)
%
%            sys = system(o,cdx);      % get contact relevant system
%            l0 = lambda(o,sys,omega); % calculate spectral FQRs
%
%            [l0,g31,g33] = lambda(o,sys,omega);
%
%         The next two calls return the frequency response (not a CORASIM
%         system), which enables efficient calculation in some algorithms
%
%            ljw = lambda(o,A,B_1,B_3,C_3,T0*omega)
%            ljw = lambda(o,PsiW31,PsiW33,T0*omega)
%
%         Theory:
%
%            sys = system(o,cdx)
%            [A,B_1,B_3,C_3,T0] = var(sys,'A,B_1,B_3,C_3,T0')
%            PsiW31 = psion(o,A,B_1,C_3) % to calculate G31(jw)
%            PsiW33 = psion(o,A,B_3,C_3) % to calculate G33(jw)
%
%            Pjw = psion(o,PsiW31,om*T0)
%            Qjw = psion(o,PsiW33,om*T0)
%
%            m = sqrt(size(Pjw,1))
%            for (k=1:size(Pjw,2))
%               Pjwk = reshape(Pjw(:,k),m,m)
%               Qjwk = reshape(Qjw(:,k),m,m)
%               Ljwk = Pjwk\Qjwk;
%               ljw(1:m,k) = Sort(ljw,eig(Ljwk))
%            end
%
%         Example:
%
%            sys = system(o,cdx)
%            [A,B_1,B_3,C_3,T0] = var(sys,'A,B_1,B_3,C_3,T0')
%            ljw = lambda(o,A,B_1,B_3,C_3,T0*omega)
%
%            PsiW31 = psion(o,A,B_1,C_3) % to calculate G31(jw)
%            PsiW33 = psion(o,A,B_3,C_3) % to calculate G33(jw)
%            l0jw = lambda(o,PsiW31,PsiW33,T0*omega)
%
%       
%         Options:
%            process.contact   contact indices (default: inf (all))
%            omega.low         lower omega (default: 100)
%            omega.high        higher omega (default 1e5)
%            omega.points      number of omega points (default 2000)
%
%         Copyright(c): Bluenetics 2021
%
%         See also: SPM, SYSTEM, PRINCIPAL, LAMBDA
%
   if (nargin == 4)                    % calculate as fast as possible
      PsiW31 = varargin{1};  PsiW33 = varargin{2};  om = varargin{3};  
      oo = Lambda(o,PsiW31,PsiW33,om);
      return
   end
   
      % otherwise do first some overhead
      
   if (nargin <= 1)
      sys = system(o);
   else
      sys = varargin{1};
   end
   
   if (nargin < 3)
      olo = opt(o,{'omega.low',100});
      ohi = opt(o,{'omega.high',1e5});
      points = opt(o,{'omega.points',2000});

      om = logspace(log10(olo),log10(ohi),points);
   else
      om = varargin{2};
   end
   
   if (nargin <= 3)
      [A,B_1,B_3,C_3,T0] = var(sys,'A,B_1,B_3,C_3,T0');
   else
      A = varargin{1};  B_1 = varargin{2};  B_3 = varargin{3};
      C_3 = varargin{4}; om = varargin{5};
      T0 = 1;                           % must be compensated by omega
   end
   
   [PsiW31,Idx] = psion(o,A,B_1,C_3);   % to calculate G31(jw)
   [PsiW33,Idx] = psion(o,A,B_3,C_3);   % to calculate G33(jw)
   
   Om = om(:)' * T0;                    % time normalize
   ljw = Lambda(o,PsiW31,PsiW33,Om);

      % for nargin >= 4 we are done
      
   m = size(B_1,2);  

   if (nargin >= 4)
      ljw = Lambda(o,PsiW31,PsiW33,Om);
      oo = ljw;
      return
   elseif (nargout > 1)
      [ljw,g31jw,g33jw] = Lambda(o,PsiW31,PsiW33,Om);
   else
      ljw = Lambda(o,PsiW31,PsiW33,Om);
   end
   
      % otherwise create a CORASIM system l0(jw) and optionally 
      % g31(jw),g33(jw) 
   
   for (i=1:m)
      l0{i,1} = ljw(i,:);
   end
   oo = fqr(corasim,om,l0);            % FQR typed CORASIM system
   oo = set(oo,'name','l0(jw)','color','yyyr');
   
   if (nargout == 1)
      return                           % return l0
   else   
      for (i=1:m)
         g31{i,1} = g31jw(i,:);
         g33{i,1} = g33jw(i,:);
      end
      g31 = fqr(corasim,om,g31);       % FQR typed CORASIM system
      g31 = set(g31,'name','g31(s)','color','g');
   
      g33 = fqr(corasim,om,g33);       % FQR typed CORASIM system
      g33 = set(g33,'name','g33(s)','color','g');
   end
end

%==========================================================================
% Lambda Calculation
%==========================================================================

function [ljw,g31jw,g33jw] = Lambda(o,PsiW31,PsiW33,om)
   G31jw = psion(o,PsiW31,om);
   G33jw = psion(o,PsiW33,om);

   m = sqrt(size(PsiW31,2)-3);
   if (m == 1)
      Ljw = G31jw ./ G33jw;
      ljw = Ljw;

      if (nargout > 1)
         g31jw = G31jw;  g33jw = G33jw;
      end
   else
      ljw = zeros(m,length(om));

      kmax = size(G31jw,2);
      for (k=1:kmax)
         G31jwk = reshape(G31jw(:,k),m,m);
         G33jwk = reshape(G33jw(:,k),m,m);
         Ljwk = G33jwk\G31jwk;

         ljw(:,k) = eig(Ljwk);
         if (k > 1)
            ljw(:,k-1:k) = Sort(ljw(:,k-1:k));
         end
         
            % optionally calculate g31(jw), g33(jw)
            % note: ljw = g0jw * g31jw/g33jw
            
         if (nargout > 1)
            g31jwk = eig(G31jwk);
            [~,idx] = sort(abs(g31jwk),'descend');
            g31jw(:,k) = g31jwk(idx);
            
            g33jwk = eig(G33jwk);
            [~,idx] = sort(abs(g33jwk),'descend');
            g33jw(:,k) = g33jwk(idx);
         end
      end
   end
end

%==========================================================================
% Helper
%==========================================================================

function L = Sort(L)                % Sort Tail of FQR              
%
% TAILSORT    Rearrange characteristic frequency responses in order to
%             obtain smooth graphs.
%
   [m,n] = size(L);
   if (n <= 1)
      idx = (1:m)';
      return                        % nothing to sort
   end
   
   one = ones(m,1);
   void = one*inf;
   
   x = L(:,end-1);  y = L(:,end);
   M = abs(y*one' - one*x.');       % magnitude change matrix
   
   px = angle(x);  py = angle(y);
   P = py*one' - one*px.';          % phase difference matrix
   P = abs(mod(P+pi,2*pi) - pi);    % phase change matrix, maps to [0,pi]
   
      % D matrix (deviations) is be a mix of magnitude changes M and
      % phase changes P
      
   D = M/norm(M) + P/norm(P);       % mix them together
   
   idx = void;
   for (l=1:m)
      row = min(D);
      j = min(find(row==min(row))); % target index
      col = D(:,j);
      i = min(find(col==min(col))); % source index

         % note: i-th element moves to j-th position

      idx(j) = i;                   % ith index equals j
      D(i,:) = void';               % ith row out of game
      D(:,j) = void;                % jth column out of game
    end
    L(:,end) = L(idx,end);
end

