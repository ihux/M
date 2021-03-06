function o = mul(o,x,y)                % Multiply Two Rational Objects 
%
% MUL   Multiply two rational objects
%
%       1) Multiplying Mantissa
%
%          o = base(rat,100);
%          z = mul(o,[26 19 25 94],[17 28 89])    % multiply two mantissa
%
%       2) Multiplying Objects
%
%          oo = mul(o1,o2)
%
%       Example: polynomial multiplication
%
%          a = corinth([1 5 6])
%          b = corinth([1 2 1])
%          c = corinth([1 7 17 17 6])
%
%          ab = mul(a,b)
%          zero = sub(ab,c)
%
%       See also: CORINTH, SUB, MUL, DIV, COMP
%
   if (nargin == 3)
      o = Mul(o,x,y);
   else
      switch o.type
         case 'number'
            o = MulNumber(o,x);
         case 'poly'
            o = MulPoly(o,x);
         case 'ratio'
            o = MulRatio(o,x);
         case 'matrix'
            o = MulMatrix(o,x);
         otherwise
            error('implermentation restriction!');
      end
   end
end

%==========================================================================
% Multiply Two Mantissa
%==========================================================================

function z = Mul(o,x,y)                % Multiply Mantissa             
   x = trim(o,x);
   y = trim(o,y);

   sign = 1;
   if any(x< 0)
      x = -x;  sign = -sign;
   end
   if any(y<0)
      y = -y;  sign = -sign;
   end
   
   base = o.data.base;
   
   n = length(x);
   z = 0*x;                              % init z
   for (i=1:length(y))
      z = [z 0];                         % shift intermediate result
      t = 0*z;                           % temporary result
      k = length(z);
      
      yi = y(i);  
      carry = 0;
      for (j=1:length(x))
         xj = x(n+1-j); 
         prod = xj * yi + carry;
         
         carry = floor(prod/base);
         remain = prod - carry*base;
         
         t(k) = t(k) + remain;
         k = k-1;
      end
      
      if (k > 0)
         t(k) = carry;
      elseif (carry ~= 0)
         t = [carry t];                % assert(carry == 0);
      end
      z = add(o,z,t);
   end
   z = sign*z;
end

%==========================================================================
% Multiply Two Objects
%==========================================================================

function oo = MulNumber(o1,o2)         % Multiply Rational Numbers     
   if (o1.data.base ~= o2.data.base)
      error('incompatible bases!');
   end
   
   oo = o1;
   oo.data.expo = o1.data.expo + o2.data.expo;
   
   num = mul(o1,o1.data.num,o2.data.num);
   den = mul(o1,o1.data.den,o2.data.den);
   
   [num,den] = can(oo,num,den);        % cancel by common factor cf

   oo.data.num = num;
   oo.data.den = den;
end

%==========================================================================
% Multiply Two Polynomials
%==========================================================================

function oo = MulPoly(o1,o2)           % Multiply Two Polynomials      
   if (o1.data.base ~= o2.data.base)
      error('incompatible bases!');
   end
   assert(isequal(o1.type,'poly') && isequal(o2.type,'poly'));
   oo = corinth(o1,'number');
   
   n1 = length(o1.data.expo)-1;  
   n2 = length(o2.data.expo)-1;
      
   for (k=0:n1+n2)
      coeff{k+1} = oo;
   end
   
   oo = corinth(o1,'poly');
   for (i=0:n1)
      oi = trim(o1,peek(o1,i));
      for (j=0:n2)
         oj = trim(o2,peek(o2,j));
         
         k = i+j;
         ok = mul(oi,oj);

            % add up products
            
         c_k = coeff{k+1};
         ck = add(c_k,ok);
         coeff{k+1} = ck;
      end
   end
   
   for (k=0:n1+n2)
      ok = coeff{k+1};     
      oo = poke(oo,ok,k);
   end
   
   oo = can(oo);
end

%==========================================================================
% Multiply Two Rational Functions
%==========================================================================

function oo = MulRatio(o1,o2)          % Multiply Two Ratios           
   if ~(isequal(o1.type,'ratio') && isequal(o2.type,'ratio'))
      error('two rational objects expected');
   end
   
   [num1,den1,~] = peek(o1);
   [num2,den2,~] = peek(o2);
   
   num = mul(num1,num2);
   den = mul(den1,den2);
   
   oo = poke(corinth(o1,'ratio'),NaN,num,den);
   %oo = can(oo);
end

%==========================================================================
% Multiply Two Rational Matrices
%==========================================================================

function oo = MulMatrix(o1,o2)         % Multiply Two Matrices         
   if ~(isequal(o1.type,'matrix') && isequal(o2.type,'matrix'))
      error('two rational matrices expected');
   end
   
   M1 = o1.data.matrix;
   M2 = o2.data.matrix;
   
   [m1,n1] = size(M1);  [m2,n2] = size(M2);
   
   if (n1 ~= m2)
      error('incompatible sizes for matrix multiplication');
   end
   
   for (i=1:m1)
      for (j=1:n2)
         Mij = ratio(o1,0,1);
         for (k=1:n1)
            M1M2 = mul(M1{i,k},M2{k,j});
            Mij = add(Mij,M1M2);
         end
         M{i,j} = Mij;
      end
   end
   
   oo = corinth(o1,'matrix');
   oo.data.matrix = M;
end
