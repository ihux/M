%   Filename:  Anschleifen_Init

%Parameter f�r Kugelanschleifen Dezember 2013 FRAN

%Modell:
%Eine Kugel/Zylinder/Kegel/W�rfel/quadratische Pyramide/Fase wird mit konstanter Vorschubgeschwindigkeit
%angeschliffen. Das System hat eine Nachgiebigkeit die vor allem auch vom
%Lagewinkel abh�ngt.
%Bsp: r=10mm / Stiftteilung 30mm / 20-stiftiger Apparat/ Schleifkraft ca. 10kN
%Das Preston Gesetz kommt zur Anwendung.
%Die inhomogene DGL 1. Ordnung wird mit Simulink gel�st.
% -------------------------------
% Define the  geometry
% -------------------------------
r = 10e-3          %m  Radius Kugel/Zylinder/Kegel; halbe Kantenl�nge von Quadrat
gamma = 90         %�  Vollwinkel der Kegelspitze/Pyramidenspitze/Fasenwinkel
gamma_rad = gamma*pi/180                    %  gamma in Radianten umwandeln
alpha = 90         %�  Lagewinkel (0.1�=Platteln, 90�=Randeln)
alpha_rad = alpha*pi/180                    %  alpha in Radianten umwandeln
n = 20             %[] Stiftanzahl pro Apparat (H1000: Apparatl�nge 600mm)
Fmax = 10000       %N  Maximalkraft Aufsatz
E = 210e9          %Pa E-Modul Stift (Stahl 210e-9, Alu 80e-9)
D = 2*r*0.75       %m  Stiftdurchmesser
L = 40e-3          %m  Stiftl�nge
% -------------------------------
% Define System Stiffness
% -------------------------------
f2 = 0.5e-3                     %m    Systemverformung Aufsatz bei Maximalkraft
c1 = Fmax/f2/n                  %N/m  Steifigkeit des Aufsatzes bezogen auf EINEN EINZELNEN Stift.
c2 = (3*E*(D^4)*pi)/(64*(L^3)*sin(alpha_rad))    %N/m Steifigkeit des auskragenden Stiftes
kf = 1/((1/c1)+(1/c2))          %N/m  Gesamtsteifigkeit
% -------------------------------
% Preston Parameterkeit
% -------------------------------
kp = 0.2e-9        % m2/N  Preston Konstante
vs = 10            % m/s   Scheibengeschwindigkeit
my = 0.2           % []    Reibbeiwert Scheibe - Glas
% -------------------------------
% Machinenparameter
% -------------------------------
vz = 2e-3          % m/s   Vorschubgeschwindigkeit
% -------------------------------
% Constants
% -------------------------------
a = (2*r*pi)/(kp*vs)                        %  Konstante a
b = pi/(kp*vs)                              %  Konstante b
c = pi/((tan((pi-gamma_rad)/2)^2)*kp*vs)    %  Konstante c
d = r^2*pi/(kp*vs)                          %  Konstante d
f = 4/((tan((pi-gamma_rad)/2)^2)*kp*vs)     %  Konstante f
g = r^2*4/(kp*vs)                           %  Konstante g
h = 4*r/((tan((pi-gamma_rad)/2)^2)*kp*vs)   %  Konstante h