function [y,x] = step(a,b,c,d,iu,t)
%STEP	Step response of continuous-time linear systems.
%	Y = STEP(A,B,C,D,iu,T)  calculates the response of the system:
%		.
%		x = Ax + Bu
%		y = Cx + Du
%
%	to a step applied to the iu'th input.  Vector T must be a
%	regularly spaced time vector that specifies the time axis for the
%	step response.  STEP returns a matrix Y with as many columns as there
%	are outputs y, and with LENGTH(T) rows. [Y,X] = STEP(A,B,C,D,iu,T)
%	also returns the state time history.
%
%	Y = STEP(NUM,DEN,T) calculates the step response from the transfer
%	function description  G(s) = NUM(s)/DEN(s)  where NUM and DEN contain
%	the polynomial coefficients in descending powers.
nargs = nargin;
if (nargs == 3) 	% Convert to state space
	t = c;
	iu = 1;
	[a,b,c,d] = tf2ss(a,b);
	nargs = 6;
end
if nargcheck(6,6,nargs)
	return
end
if abcdcheck(a,b,c,d)
	return
end

% The state space model of an integrator is
%       a1=0; b1=1; c1=1; d1=0;
% Remove all inputs except input  iu  and put
% integrator in series with a,b,c,d:
[a2,b2,c2,d2] = series(0,1,1,0,a,b(:,iu),c,d(:,iu));

[y,x] = impulse(a2,b2,c2,0,1,t);

% remove the integrator state
sa = size(a2);
x = x(:,2:sa(1));

                                                                                                                                                                                                                                                                                                           