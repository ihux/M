function [k,s] = dlqr(a,b,q,r)
%DLQR	Linear quadratic regulator design for discrete-time systems.
%	[K,S] = DLQR(A,B,Q,R)  calculates the optimal feedback gain matrix K
%	such that the feedback law:
%
%		u = -Kx
%
%	minimizes the cost function:
%
%		J = Sum {x'Qx + u'Ru}
%
%	subject to the constraint equation: 
%		
%		x[n+1] = Ax[n] + Bu[n] 
%                
%	Also returned is S, the steady-state solution to the associated 
%	discrete matrix Riccati equation:
%					  -1
%		0 = S - A'SA + A'SB(R+B'SB) BS'A - Q

if nargcheck(4,4,nargin)
	return
end
if abcdcheck(a,b)
	return
end
[m,n] = size(a);
[mb,nb] = size(b);
[mq,nq] = size(q);
if (m ~= mq) | (n ~= nq) 
	errmsg('A and Q must be the same size')
	return
end
[mr,nr] = size(r);
if (mr ~= nr) | (nb ~= mr)
	errmsg('B and R must be consistent')
	return
end

% eigenvectors of Hamiltonian
[v,d] = eig([a+b/r*b'/a'*q  -b/r*b'/a'; -a'\q  inv(a)']);

d = diag(d);
[d,index] = sort(abs(d));	 % sort on magnitude of eigenvalues
if (~((d(n) < 1) & (d(n+1)>1)))
	errmsg('Can''t order eigenvalues')
	return
end
% select vectors with eigenvalues inside unit circle
chi = v(1:n,index(1:n));
lambda = v((n+1):(2*n),index(1:n));
s = lambda/chi;
k = (r+b'*s*b)\b'*s*a;
                                                                                                                                                                                                                                                                              