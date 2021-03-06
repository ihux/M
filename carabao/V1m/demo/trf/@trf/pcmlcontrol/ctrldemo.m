echo on
cla
%	This demo shows the use of some of the control system design
%	and analysis tools available in PC-MATLAB.
%
pause % Strike any key to continue.
cla
%	Suppose we start with a plant description in transfer function
%	form:                         2
%				  .2 s  +  .3 s  +  1
%			H(s)  =  -----------------------
%				   2
%				 (s  +  .4 s  +  1) (s + .5)
%
%	We enter the numerator and denominator coefficients separately into 
%	PC-MATLAB:

num = [.2  .3  1];
den1 = [1 .4 1];
den2 = [1 .5];

pause % Strike any key to continue.
cla
%	The denominator polynomial is the product of the two terms. We
%	use convolution to obtain the polynomial product:

den = conv(den1,den2)
pause % Strike any key to continue.
cla
%	We can look at the natural frequencies and damping factors of the
%	plant poles:

[Wn,z] = damp(den)

pause % Strike any key to continue.
cla
%	A root-locus can be obtained by defining a vector of desired
%	gains, and then using RLOCUS:

k = 0:.5:10;
r = rlocus(num,den,k);		%  Working please wait...

pause % Strike any key for plot.
plot(r,'x'), title('Root-locus'),xlabel('Real part'),ylabel('Imag part'),pause
cla
%	The plant may be converted to a state space representation
%		.
%		x = Ax + Bu
%		y = Cx + Du
%
%	using the tf2ss command:

[a,b,c,d] = tf2ss(num,den)
pause % Strike any key to continue.
cla
%	For systems described in state-space or by transfer functions,
%	the step response is found by first defining a time axis and
%	then using the STEP command:

t = 0:.3:15;
y = step(a,b,c,d,1,t);			% Working, please wait...

pause % Strike any key for plot.
plot(t,y),title('Step response'),xlabel('time(sec)'),pause
cla
%	The frequency response is found by defining a logarithmically
%	spaced frequency axis, and then using the BODE command:

     				%			      -1      1
w = logspace(-1,1);		% this is 50 points between 10  and 10

[mag,phase] = bode(a,b,c,d,1,w);	% Working, please wait...

pause % Strike any key for plot.
cla
loglog(w,mag), title('Magnitude response'), xlabel('Radians/s'),pause
semilogx(w,phase), title('Phase response'), xlabel('Radians/s'),pause
cla
%	A linear quadratic regulator could be designed for this plant.
%	For control and state penalties:

r = 1;
q = eye(a)
%	the quadratic optimal gains and the associated Riccati solution are:

[k,s] = lqr(a,b,q,r)			% Working, please wait...
pause % Strike any key to continue.
                                                                                