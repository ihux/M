function [a,b,c,d] = tf2ss(num, den)
%TF2SS	Transfer function to state-space conversion.
%	[A,B,C,D] = TF2SS(NUM,DEN)  calculates the state-space representation:
%		.
%		x = Ax + Bu
%		y = Cx + Du
%
%	of the system:
%			NUM(s) 
%		H(s) = --------
%			DEN(s)
%
%	from a single input.  Vector DEN must contain the coefficients of the 
%	denominator in descending powers of s.  Matrix NUM must contain the 
%	numerator coefficients with as many rows as there are outputs y.  The
%	A,B,C,D matrices are returned in controller canonical form.  This 
%	calculation also works for discrete systems but the numerator must be
%	padded with trailing zeros to make it the same length as the 
%	denominator.

[mnum,nnum] = size(num);
[mden,n] = size(den);
if nnum > n
	errmsg('Error: Numerator cannot be higher order than denominator')
	return
end
if n > nnum
	num = [zeros(mnum,n-nnum) num];
end
if n == 1
	a=0;
	b=0;
	c=0;
	d=num./den;
	return
end
num = num ./ den(1);
den = den ./ den(1);
a = [-den(2:n); eye(n-2,n-1)];
b = eye(n-1,1);
c = num(:,2:n) - num(:,1) * den(2:n);
d = num(:,1);
                                                                                                                                                                                                                                                                                                                                                                                                                              