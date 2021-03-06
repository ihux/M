function [mag,phase] = bode(a,b,c,d,iu,w)
%BODE	Bode response of continuous-time linear systems.
%	[MAG,PHASE] = BODE(A,B,C,D,iu,W)  calculates the frequency response 
%	of the system:
%		.
%		x = Ax + Bu			     -1
%		y = Cx + Du		G(s) = C(sI-A) B + D
%
%		mag(w) = abs(G(jw)),    phase(w) = angle(G(jw))
%
%	from the iu'th input.  Vector W must contain the frequencies, in
%	radians, at which the Bode response is to be evaluated.  BODE returns
%	matrices MAG and PHASE (in degrees) with as many columns as there are 
%	outputs y, and with LENGTH(W) rows. 
%
%	[MAG,PHASE] = BODE(NUM,DEN,W) calculates the Bode response from the
%	transfer function description  G(s) = NUM(s)/DEN(s)  where NUM and
%	DEN contain the polynomial coefficients in descending powers.
%
%	See LOGSPACE to generate frequency vectors that are equally spaced
%	logarithmically in frequency. 
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
nw = max(size(w));

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
mag = abs(g)';
phase = (180./pi)*imag(log(g))';

% Comment out the following statement if you don't want the phase to  
% be "fixed".  Note that phase fixing will not always work; it is only a
% "guess" as to whether +-360 should be added to the phase to make it
% more asthetically pleasing.  (See FIXPHASE.M)

phase = fixphase(phase);

% Uncomment the following line for decibels, but be warned that the
% MARGIN function will not work with decibel data.
% mag = 20*log10(mag);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                              