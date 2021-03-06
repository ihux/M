function z = tzero(a,b,c,d)
%TZERO	Transmission zeros.
%	TZERO(A,B,C,D) returns the transmission zeros of the state-space
%	system:
%		.
%		x = Ax + Bu
%		y = Cx + Du
%
%	Care must be exercised to disregard any large zeros that may
%	actually be at infinity.  It is best to use FORMAT SHORT E so
%	large zeros don't swamp out the display of smaller finite zeros.

% For more information on this algorithm, see:
%   [1] A.J Laub and B.C. Moore, Calculation of Transmission Zeros Using
%   QZ Techniques, Automatica, 14, 1978, p557
%
% For a better algorithm, not implemented here, see:
%   [2] A. Emami-Naeini and P. Van Dooren, Computation of Zeros of Linear 
%   Multivariable Systems, Automatica, Vol. 14, No. 4, pp. 415-430, 1982.
%

if nargcheck(4,4,nargin)
	return
end
if abcdcheck(a,b,c,d)
	return
end
[n,m] = size(b);
[r,n] = size(c);
aa = [a b;c d];

if m == r
	bb = zeros(aa);
	bb(1:n,1:n) = eye(n);
	z = eig(aa,bb);
	z = z(z ~= NaN & z ~= inf); % Punch out NaN's and Inf's
else
	nrm = norm(aa,1);
	if m > r
		aa1 = [aa;nrm*(rand(m-r,n+m)-.5)];
		aa2 = [aa;nrm*(rand(m-r,n+m)-.5)];
	else
		aa1 = [aa nrm*(rand(n+r,r-m)-.5)];
		aa2 = [aa nrm*(rand(n+r,r-m)-.5)];
	end
	bb = zeros(aa1);
	bb(1:n,1:n) = eye(n);
	z1 = eig(aa1,bb);
	z2 = eig(aa2,bb);
	z1 = z1(z1 ~= NaN & z1 ~= inf);	% Punch out NaN's and Inf's
	z2 = z2(z2 ~= NaN & z2 ~= inf);
	nz = length(z1);
	for i=1:nz
		if any(abs(z1(i)-z2) < nrm*sqrt(eps))
			z = [z;z1(i)];
		end
	end
end
                         