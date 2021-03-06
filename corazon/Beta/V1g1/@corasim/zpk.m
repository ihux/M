function [z,p,k,T] = zpk(o,num,den,k,T)
%
% ZPK   Find zeros, poles and K-factor of a rational function
%
%          o = trf(corasim,[5 6],[1 2 3]);
%
%          [z,p,k] = zpk(o)
%          [z,p,k] = zpk(o,num,den)
%          [z,p,k] = zpk(o,poly)
%
%       From a rational transfer function in polynomial form
%
%                    (s-z1)(s-z2)...(s-zn)       num(s)
%          G(s) =  K ---------------------  =  ----------
%                    (s-p1)(s-p2)...(s-pn)       den(s)
%
%       Find zeros, poles and K-factor. Vector den specifies the coeffi-
%       cients of the denominator in descending powers of s.  Matrix num 
%       indicates the numerator coefficients with as many rows as there 
%       are outputs.  
%
%       The zero locations are returned in the columns of matrix Z, with 
%       as many columns as there are rows in NUM.  The pole locations are
%       returned in column vector P, and the gains for each numerator 
%       transfer function in vector K. 
%
%       Create ZPK objects
%
%          oo = zpk(o,num,den)
%          oo = zpk(o,poly)
%
%          oo = zpk(o,z,p,K)           % s-type ZPK (continuous)
%          oo = zpk(o,z,p,K,0)         % sameas above
%
%          oo = zpk(o,z,p,K,T)         % z-type ZPK (discrete)
%          oo = zpk(o,z,p,K,-T)        % q-type ZPK (discrete)
%
%          [z,p,K,T] = zpk(o)          % retriev poles/zeros, K and T
%
%          oo = zpk(o)                 % cast to ZPK type
%
%       Copyright(c): Bluenetics 2020
%
%       See also: CORASIM
%
   switch nargin
      case {0,1}
         if (nargout <= 1)             % cast to ZPK object
            if type(o,{'szpk','zzpk','qzpk'})
               oo = o;                 % nothing left to do
            else
               [num,den] = peek(o);    % first cast to ZPK object
               oo = zpk(o,num,den);
               oo.data.T = o.data.T;
            end
         else                          % nargout >= 2
            if type(o,{'szpk','zzpk','qzpk'})
               z = o.data.zeros;
               p = o.data.poles;
               k = o.data.K;
               T = o.data.T;
            else
               [num,den] = peek(o);
               [z,p,k] = Zpk(o,num,den);
               T = o.data.T;
            end
            return
         end
         
      case 2
         den = 1;
         [z,p,k] = Zpk(o,num,den);
         T = 0;
         
         if (nargout > 1)
            return
         end
         
         oo = Create(o,z,p,k,T);
      case 3
         [z,p,k] = Zpk(o,num,den);
         T = 0;

         if (nargout > 1)
            return
         end

         oo = Create(o,z,p,k,T);
         
      case 4
         z = num;  p = den;
         oo = Create(o,z,p,k,0);
         
      case 5
         z = num;  p = den;
         oo = Create(o,z,p,k,T);
         
      otherwise
         error('up to 5 input args expected');
   end
   
      % copy digits option to outarg

   z = opt(oo,'digits',opt(o,'digits'));
end

%==========================================================================
% Find Zeros, Poles and K-factor
%==========================================================================

function [z,p,k] = Zpk(o,num,den)      % Convert Num/Den to Zero/Pole/K            
   [num,den] = Trim(o,num,den);

   if ~isempty(den)
       coef = den(1);
   else
       coef = 1;
   end
   if coef == 0
      error('denominator has zero leading coefficients');
   end

      % remove leading columns of zeros from numerator
   
   if ~isempty(num)
       while(all(num(:,1)==0) && length(num) > 1)
           num(:,1) = [];
       end
   end
   [ny,np] = size(num);

      % poles
      
   p  = roots(den);

      % zeros and gain
      
   if any(any(isnan(num))) || any(any(isinf(num)))
      error('cannot handle NaNs or INFs');
   end
      
   k = zeros(ny,1);
   linf = inf;
   z = linf(ones(np-1,1),ones(ny,1));
   for i=1:ny
     zz = roots(num(i,:));
     if ~isempty(zz)
        z(1:length(zz),i) = zz;
     end
     ndx = find(num(i,:)~=0);
     if ~isempty(ndx)
        k(i,1) = num(i,ndx(1))./coef; 
     end
   end
end

%==========================================================================
% Helper
%==========================================================================

function oo = Create(o,z,p,K,T)        % Create ZPK Object             
   if (T > 0)
      oo = corasim('zzpk');
   elseif (T < 0)
      oo = corasim('qzpk');
   else
      oo = corasim('szpk');
   end
   
   oo.data.zeros = z;
   oo.data.poles = p;
   oo.data.K = K;
   oo.data.T = T;
   
      % copy verbose option
      
   oo = control(oo,'verbose',control(o,'verbose'));
end
function [num,den] = Trim(o,num,den)
%
% TRIM Trim numerator and denominator to get equal length and perform 
%      consistency checks for proper transfer function.
%
%         [num,den] = Trim(o,num,den)
%
%   returns equivalent transfer function numerator and denominator where
%   length(numc) = LENGTH(den) if the transfer function num/den is proper,
%   otherwise causes an error.
%
   [nn,mn] = size(num);
   [nd,md] = size(den);

      % make sure DEN is a row vector, NUM is assumed to be in rows.
      
   if (nd > 1)
       error('denominator not a row vector');
   elseif (mn > md)
       %error('improper transfer function');
   end

     % make NUM and DEN lengths equal
   
   num = [zeros(nn,md-mn),num];
end
