function [l,m,p] = dlqe(a,g,c,q,r)
%DLQE	Discrete linear quadratic estimator design.
%	For the discrete-time system:
%
%	x[n+1] = Ax[n] + Bu[n] + Gw[n]	    {State equation}
%	z[n]   = Cx[n] + Du[n] +  v[n]	    {Measurements}
%
%	with process noise and measurement noise covariances:
%
%	E{w} = E{v} = 0,  E{ww'} = Q,  E{vv'} = R
%
%	the function DLQE(A,G,C,Q,R) returns the gain matrix L
%	such that the discrete, stationary Kalman filter:
%		      _		*
%	State update: x[n+1] = Ax[n] + Bu[n]
%			    *      _                _
%	Observation update: x[n] = x[n] + L(z[n] - Hx[n] - Du[n])
%
%	produces an LQG optimal estimate of x.
%	[L,M,P] = DLQE(A,G,C,Q,R) returns the gain matrix L, the Riccati
%	equation solution M, and the estimate error covariance after the 
%	measurment update:
%		       *    *
%		P = E{[x-x][x-x]'}

% Use DLQR to calculate estimator gains using duality
[k,s] = dlqr(a',c',g*q*g',r);
m = s';
l = s*c'/(c*s*c' + r);
p = a\(m-g*q*g')/a';

                             