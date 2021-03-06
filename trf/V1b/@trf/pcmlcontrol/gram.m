function g = gram(a,b)
%GRAM	Controllability and observability gramians.
%	GRAM(A,B) returns the controllability gramian:
%
%		Gc = integral {exp(tA)BB'exp(tA')} dt
%
%	GRAM(A',C') returns the observability gramian:
%
%		Go = integral {exp(tA')C'Cexp(tA)} dt

%	J.N. Little 3-6-86

%	Kailath, T. "Linear Systems", Prentice-Hall, 1980.
%	Laub, A., "Computation of Balancing Transformations", Proc. JACC
%	  Vol.1, paper FA8-E, 1980.

[u,s,v] = svd(b);
g = u*lyap(u'*a*u,s*s')*u';
              