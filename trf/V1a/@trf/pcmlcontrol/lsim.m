function  [y,x] = lsim(a, b, c, d, u, t, x0)
%LSIM	Simulation of continuous-time linear systems to arbitrary inputs.
%	Y = LSIM(A,B,C,D,U,T)  calculates the time response of the system:
%			.
%			x = Ax + Bu
%			y = Cx + Du
%
%	to input time history U.  Matrix U must have as many columns as 
%	there are inputs, U.  Each row of U corresponds to a new time point,
%	and U must have LENGTH(T) rows. LSIM returns a matrix Y with as many
%	columns as there are outputs y, and with LENGTH(T) rows.
%	[Y,X] = LSIM(A,B,C,D,U,T) also returns the state time history.
%	LSIM(A,B,C,D,U,T,X0) can be used if initial conditions exist.
%
%	Y = LSIM(NUM,DEN,U,T) calculates the time response from the transfer
%	function description  G(s) = NUM(s)/DEN(s)  where NUM and DEN
%	contain the polynomial coefficients in descending powers.
nargs = nargin;
if ((nargs == 4) | (nargs == 5))	% transfer function description 
	if nargs == 5
		x0 = u;
	end
	u = c;
	t = d;
	[m,n] = size(a);
	% Convert to state space
	[a,b,c,d] = tf2ss(a,b);
	nargs = nargs + 2;
	end
end
[ns,nx] = size(a);
if (nargs == 6)
	x0 = zeros(1,ns);
end
if nargcheck(6,7,nargs)
	return
end
if abcdcheck(a,b,c,d)
	return
end
if min(size(u)) == 1
	u = u(:);
end
[a,b] = c2d(a,b,t(2)-t(1));
x = ltitr(a,b,u,x0);
y = x * c.' + u * d.';
                                                                                                                                                                                                               