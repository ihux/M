function [num, den] = ss2tf(a,b,c,d,iu)
%SS2TF	State-space to transfer function conversion.
%	[NUM,DEN] = SS2TF(A,B,C,D,iu)  calculates the transfer function:
%
%			NUM(s)          -1
%		H(s) = -------- = C(sI-A) B + D
%			DEN(s)
%	of the system:
%		.
%		x = Ax + Bu
%		y = Cx + Du
%
%	from the iu'th input.  Vector DEN contains the coefficients of the
%	denominator in descending powers of s.  The numerator coefficients
%	are returned in matrix NUM with as many rows as there are outputs y.

if nargcheck(5,5,nargin)
	return
end
if abcdcheck(a,b,c,d)
	return
end
den = poly(a);
b = b(:,iu);
d = d(:,iu);
[mc,nc] = size(c);
num = ones(mc, nc+1);
for i=1:mc
	num(i,:) = poly(a-b*c(i,:)) + (d(i) - 1) * den;
end
                                                                                                                                                                                                                                                                                          