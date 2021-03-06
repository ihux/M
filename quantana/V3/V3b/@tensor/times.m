function out = times(ob1,ob2)
% 
% TIMES    Tensor multiplication
%
%             S1 = space(tensor,'a','b','c');
%             S2 = space(tensor,1:2);
%
%             A = operator(S1,magic(3));
%             B = operator(S2,magic(2));
%             
%             C = A.*B;   % tensor product of operators: C = A�B
%
   fmt1 = format(ob1);
   
   if isa(ob2,'tensor')
      fmt2 = format(ob2);
   else
      fmt2 = '';
   end
   
   switch [fmt1,fmt2]
      case '#SPACE#SPACE'
         out = space(ob1,ob2);
         return
         
      case '#VECTOR#VECTOR'
         S1 = space(ob1);
         S2 = space(ob2);

         M1 = matrix(ob1);
         M2 = matrix(ob2);

         S = space(S1,S2);
         M = TensorProduct(M1,M2);

         obj = vector(S);          % null vector
         out = vector(obj,M);      % set vector matrix
         return
         
      case {'#OPERATOR#OPERATOR','#OPERATOR#PROJECTOR',...
            '#PROJECTOR#OPERATOR','#PROJECTOR#PROJECTOR'}
         S1 = space(ob1);
         S2 = space(ob2);

         M1 = matrix(ob1);
         M2 = matrix(ob2);

         S = space(S1,S2);
         M = TensorProduct(M1,M2);

         out = matrix(operator(S,0),M);
         out = cast(out);
         return
   end
   return
   
   error('cannot perform tensor product!');
end

%==========================================================================
% Tensor Product
%==========================================================================

function C = TensorProduct(A,B)
%
% TENSOR-PRODUCT  Tensor product of two matrices
%
   [am,an] = size(A);
   [bm,bn] = size(B);
   
   C = sparse(am*bm,an*bn);
   
   for (ai=1:am)                  % regarding rows of am x an A matrix
     for (aj=1:an)                % regarding cols of am x an A matrix
         for (bi=1:bm)            % regarding rows of bm x bn B matrix
            for (bj=1:bn)         % regarding cols of bm x bn B matrix
              i = (ai-1)*bm + bi;
              j = (aj-1)*bn + bj;
              C(i,j) = A(ai,aj) *B(bi,bj);
           end
         end
      end
   end
   return
end