clc, clear
% lc = 50;
% Lc = 0.97e-6;
% Cc = 45e-12;

m = 5.6;
C = 446e-12;
L = 6.5e-6;

Lc = L/m;
Cc = C/m;
tt=m*sqrt(Lc*Cc);

Zo = sqrt(Lc/Cc);
% tr = 27*tt;
tr = 1.5e-6;
tpk = 2.74145*tr;
wo = 2/tpk;

Rf = Zo/2
Lf = Rf/(2*wo)
Cf = 1/(wo^2*Lf)

