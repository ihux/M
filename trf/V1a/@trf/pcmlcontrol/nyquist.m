function [re, im] = nyquist(a,b,c,d,iu,w)
%NYQUIST Nyquist response of continuous-time linear state-space systems.
%	[RE, IM] = NYQUIST(A,B,C,D,iu,W)  calculates the frequency response 
%	of the system:
%		.
%		x = Ax + Bu			     -1
%		y = Cx + Du		G(s) = C(sI-A) B + D
%
%		RE(w) = real(G(jw))     IM(w) = imag(G(jw))
%
%	from the iu'th input.  Vector W must contain the frequencies, in
%	radians, at which the Nyquist response is to be evaluated.  NYQUIST
%	returns matrices RE and IM (in degrees) with as many columns as there
%	are outputs y, and with LENGTH(W) rows.  See LOGSPACE to generate 
%	frequency vectors that are equally spaced logarithmically in frequency.  
%
%	[re, im] = NYQUIST(NUM,DEN,W) calculates the Nyquist response from 
%	the transfer function description  G(s) = NUM(s)/DEN(s)  where NUM and
%	DEN contain the polynomial coefficients in descending powers.
nargs = nargin;
if (nargs == 3) 	% Convert to state space
	w = c;
	[a,b,c,d] = tf2ss(a,b);
	nargs = 6;
	iu = 1;
end
if nargcheck(6,6,nargs)
	return
end
if abcdcheck(a,b,c,d)
	return
end
[no,ns] = size(c);
nw = length(w);

% [t,a] = balance(a);	    % Balance A (uncomment these three lines if you
% b = diag(ones(t)./t) * b; % want BODE to automatically balance your A matrix
% c = c * diag(t);	    % (They have been commented out for speed.)

[p,a] = hess(a);		% Reduce A to Hessenberg form:

%	 Apply similarity transformations from Hessenberg
%	 reduction to B and C:
b = p' * b(:,iu);
c = c * p;
d = d(:,iu);
w = w * sqrt(-1);
g = ltifr(a,b,w);
g = c * g + diag(d) * ones(no,nw);
re = real(g)';
im = imag(g)';

                                                                                                                                                                                                                                                                                                                                                                                                             