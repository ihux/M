function oo = matrix(o,M)              % Construct Corinthian Matrix   
%
% MATRIX Construct a matrix of rational functions
%
%           o = base(corinth,100)
%
%           on = corinth(o,'number')
%           oo = matrix(on,magic(3))   % create number matrix
%
%           op = corinth(o,'poly')
%           oo = matrix(op,magic(3))   % create polynomial matrix
%
%           or = corinth(o,'ratio')
%           oo = matrix(or,magic(3))   % create rational function matrix
%
%        Copyright(c): Bluenetics 2020
%
%        See also: CORINTH,POLY, MATRIX
%
   if (nargin == 1)                    % casting
      oo = Cast(o);
   elseif (nargin == 2)
      oo = Matrix(o,M);
   else
      error('bad arg list');
   end
   
   oo = can(oo);
   oo = trim(oo);
end

%==========================================================================
% Rational Matrix Construction
%==========================================================================

function oo = Matrix(o,M)              % Construct Rational Matrix     
   [m,n] = size(M);
   if isa(M,'double')
      A = M;  M = {};
      for (i=1:m)
         for (j=1:n)
            M{i,j} = number(o,A(i,j));
         end
      end
   end
   
   if ~iscell(M)
      error('cell array expected (arg2)');
   end
    
      % convert to all polynomials if arg1 is a polynomial
  
   if type(o,{'poly'})
      for (i=1:m)
         for (j=1:n)
            oo = M{i,j};
            switch oo.type
               case 'number'
                  M{i,j} = poly(oo);
               case 'poly'
                  'ok';
               case 'ratio'
                  'ok';                   % data format ok, nothing to change
               otherwise
                  error('implementation');
            end
         end
      end
   end
   
      % convert to rational function matrix if arg1
      % is a ratio object
   
   if type(o,{'ratio'})
      for (i=1:m)
         for (j=1:n)
            oo = M{i,j};
            switch oo.type
               case 'number'
                  M{i,j} = ratio(poly(oo),poly(o,1));
               case 'poly'
                  M{i,j} = ratio(oo,poly(o,1));
               case 'ratio'
                  'ok';                   % data format ok, nothing to change
               otherwise
                  error('implementation');
            end
         end
      end
   end
   
   oo = corinth(o,'matrix');
   oo.data.matrix = M;

      % matrix is cancelled and trimmed, since all matrix elements
      % are cancelled and trimmed

   oo.work.can = true;
   oo.work.trim = true;
end

%==========================================================================
% Cast Corinthian Object To a Matrix of Rational Functions
%==========================================================================

function oo = Cast(o)                  % Cast Corinthian Matrix        
   switch o.type
      case 'number'
         num = poly(o);  den = poly(o,1);
         oo = ratio(o,num,den);        % ratio of two polynomials
         oo = Cast(oo);                % cast ratio to matrix
      case 'poly'
         num = o;  den = poly(o,1);
         oo = ratio(o,num,den);        % ratio of two polynomials
         oo = Cast(oo);                % cast ratio to matrix
      case 'ratio'
         oo = matrix(o,{o});           % cast ratio to matrix
      case 'matrix'
         oo = o;                       % easy :-)
      otherwise
         error('internal')
   end
end
