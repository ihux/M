function [ab,bb,cb,m,T] = balreal(a,b,c)
%BALREAL  Balanced state-space realization and model reduction.
%	[Ab,Bb,Cb] = BALREAL(A,B,C) returns a balanced state-space realization
%	of the system (A,B,C).
%	[Ab,Bb,Cb,m,T] = BALREAL(A,B,C) also returns a vector M containing the
%	diagonal of the gramian of the balanced realization, and matrix T, the
%	similarity transformation used to convert (A,B,C) to (Ab,Bb,Cb).  If
%	the system (A,B,C) is normalized properly, small elements in gramian M
%	indicate states that can be removed to reduce the model to lower order.

%	J.N. Little 3-6-86

%	See:
%	 1) Moore, B., Principal Component Analysis in Linear Systems:
%	    Controllability, Observability, and Model Reduction, IEEE 
%	    Transactions on Automatic Control, 26-1, Feb. 1981.
%	 2) Laub, A., "Computation of Balancing Transformations", Proc. JACC
%	    Vol.1, paper FA8-E, 1980.

Gc = gram(a,b);
Go = gram(a',c');
R = chol(Gc);
[V,D] = eig(R*Go*R');
T = R'*V*D.^(-.25);
ab = T\a*T;
bb = T\b;
cb = c*T;
if nargout > 3
	m = diag(gram(ab,bb))';
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                  