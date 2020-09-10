echo off
% Demonstration facility.   J.N. Little 10/29/84.

clear
while 1
	demos= ['matdemo '
		'plotdemo'
		'census  '
		'square  '
		'ctheorem'
		'movies  '
		'mesh2   '
		'kronplot'
		'wow     '
		'bench   '
		'fftdemo '
		'filtdemo'
		'ctrldemo'];
	cla
	help demolist
	n = input('Select a demo number: ');
	if ((n <= 0) | (n > 13)) 
		break
	end
	demos = demos(n,:);
	eval(demos)
	clear
end
cla
                                                                                   