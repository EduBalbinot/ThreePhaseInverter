clc, clear
% Ensaio a Vazio

Vlvz = 459;           %Tensão de linha
V1vz = Vlvz/sqrt(3);  %Tensão de fase [V]
I1vz = 34.1;          %Corrente de linha [A]
Pvz= 1.25e3;          %Potência elétrica polifásica total de entrada [W]
q = 3;                % Numero de fases
fen = 60;

% Ensaio rotor bloqueado

Vlbl = 42.3;          %Tensão de linha
V1bl = Vlbl/sqrt(3);  %Tensão de fase [V]
I1bl = 169;           %Corrente de linha [A]
Pbl = 4.44e3;         % Potência elétrica polifásica total de entrada [W] 
fbl = 15;             % Frequência do ensaio de rotor bloqueado [Hz]

% Ensaio CC

R1 = 30.3e-3;         % Resistencia teste cc

% Ensaio de rotor bloqueado em 60 Hz

Vcc = 455;             %Tensão de fase [V]
I1blcc = 725;         %Corrente de linha [A]
Pblcc = 147e3;        % Potência elétrica

% Cálculos

Prot = Pvz - q * I1vz^2* R1;    % Perdas rotacionais

Svz = q*V1vz*I1vz;              % Potência aparente total de entrada a vazio
Qvz = sqrt(Svz^2-Pvz^2);        % Potência reativa a vazio

Xvz = Qvz/(q*I1vz^2);           % Reatância a vazio

Sbl = q*V1bl*I1bl;              % Potência aparente total de rotor bloqueado
Qbl = sqrt(Sbl^2-Pbl^2);        % Potência reativa de rotor bloqueado

Xbl = (fen/fbl)*(Qbl/(q*I1bl^2)); % Reatância bloqueado

kX1 = 0.4;
k = kX1/(1-kX1);

syms X1 X2
eqn = k^2*X2^2+(Xbl*(1-k)-Xvz*(1+k))*X2+Xvz*Xbl == 0;
Xr = roots(double(sym2poly(lhs(eqn))))
X2 = min(Xr);
X1 = k*X2;

Xm = Xvz - X1;
Rbl = Pbl/(q * I1bl^2);
R2 = (Rbl - R1)*((X2+Xm)/Xm)^2;

Pg = Pbl - q * I1bl^2 * R1;         % Potência no entreferro

fprintf("R1: %.5f mΩ\n", R1*1000)
fprintf("R2: %.5f mΩ\n", R2*1000)
fprintf("Xm: %.5f Ω\n", Xm)
fprintf("X1: %.5f Ω\n", X1)
fprintf("X2: %.5f Ω\n", X2)

