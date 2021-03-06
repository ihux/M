function [a, b] = d2c(phi, gamma, t)
%C2D	Conversion of state space models from discrete to continuous time.
%	[A, B] = D2C(Phi, Gamma, T)  converts the discrete-time system:
%
%		x[n+1] = Phi * x[n] + Gamma * u[n]
%
%	to the continuous-time state-space system:
%		.
%		x = Ax + Bu
%
%	assuming a zero-order hold on the inputs and sample time T.
if nargcheck(3,3,nargin)
	return
end
if abcdcheck(phi,gamma)
	return
end

[m,n] = size(phi);
[m,nb] = size(gamma);
s = real(logm([[phi gamma]; zeros(nb,n) eye(nb)]))/t;
a = s(1:n,1:n);
b = s(1:n,n+1:n+nb);

                                                                                                                                                                                                                                                                                                                                                                                                                                                              