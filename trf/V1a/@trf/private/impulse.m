function [y,x] = impulse(a,b,c,d,iu,t)
%IMPULSE Impulse response of continuous-time linear systems.
%	 Y = IMPULSE(A,B,C,D,iu,T)  calculates the response of the system:
%		.
%		x = Ax + Bu
%		y = Cx + Du
%
%	to an impulse applied to the iu'th input.  Vector T must be a
%	regularly spaced time vector that specifies the time axis for the
%	impulse response.  IMPULSE returns a matrix Y with as many columns
%	as there are outputs y, and with LENGTH(T) rows. 
%	[Y,X] = IMPULSE(A,B,C,D,iu,T) also returns the state time history.
%
%	Y = IMPULSE(NUM,DEN,T) calculates the impulse response from the 
%	transfer function description  G(s) = NUM(s)/DEN(s)  where NUM and
%	DEN contain the polynomial coefficients in descending powers.

nargs = nargin;
if (nargs == 3) 	% Convert to state space
	t = c;
	iu = 1;
	[a,b,c] = tf2ss(a,b);
	nargs = 6;
end

if nargcheck(6,6,nargs)
	return
end
if abcdcheck(a,b,c)
	return
end

b = b(:,iu);
dt = t(2)-t(1);
[aa,bb] = c2d(a,b,dt);
n = length(t);
x = ltitr(aa,bb,zeros(n,1),b);
y = x * c.';

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     