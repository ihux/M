function [a,b,c,d] = zp2ss(z,p,k)
%ZP2SS	Zero-pole to state-space conversion.
%	[A,B,C,D] = ZP2SS(Z,P,K)  calculates a state-space representation:
%		.
%		x = Ax + Bu
%		y = Cx + Du
%
%	for SIMO systems given a set of pole locations in column vector P,
%	a matrix Z with the zero locations in as many columns as there are
%	outputs, and the gains for each numerator transfer function in
%	vector K.  The A,B,C,D matrices are returned in controller
%	canonical form.

[num,den] = zp2tf(z,p,k);
[a,b,c,d] = tf2ss(num,den);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       