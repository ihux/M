function [kerr,serr] = ric(a,b,q,r,k,s)
%	Riccati solution check.
%				  -1
%		0 = SA + A'S - SBR  B'S + Q
serr = s*a+a'*s-s*b/r*b'*s+q
kerr = k - r\b'*s
                                                                                                                                                                                                                                                                                                                                                               