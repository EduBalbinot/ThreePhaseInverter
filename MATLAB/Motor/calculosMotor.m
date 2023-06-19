clc, clear

s=0.10;                     % Escorregamento
fen = 60;                   % Frequência [Hz]
w= 2 * pi * fen;
In = 2.07;                   % Corrente nominal [I]
Ip = 5;                   % Corrente de partida [I]
Ie = In * Ip ;              % Corrente eficaz [I]
Ipmax= Ie*sqrt(2);          % Corrente de pico máxima [I]
Ipmd = Ipmax/pi;            % Corrente média nas chaves [I]

% Ensaio a Vazio (Delta)

V1vz = 220;                 % Tensão de fase [V]
Ifvz = 0.937;               % Corrente de fase [A]
I1vz = Ifvz/sqrt(3);        % Corrente de linha [A]
Pvz= 87.2;                  % Potência elétrica polifásica total de entrada [W]
q = 3;                      % Numero de fases

% Ensaio rotor bloqueado (Delta)

V1bl = 218;                 % Tensão de fase [V]
Ifbl = 4.078;               % Corrente de fase [A]
I1bl = Ifbl/sqrt(3);        % Corrente de linha [A]
Pbl = 1415;                 % Potência elétrica polifásica total de entrada [W] 
fbl = 60;                   % Frequência do ensaio de rotor bloqueado [Hz]

% Ensaio CC

Vdc = 50;                   % Tensão contínua [V]
Idc = 1.11;                 % Corrente contínua [A]
R1 = Vdc/Idc;               % Resistencia teste cc

% Cálculos

Svz = q*V1vz*I1vz;                  % Potência aparente total de entrada a vazio
Qvz = sqrt(Svz^2-Pvz^2);            % Potência reativa a vazio

Xvz = Qvz/(q*I1vz^2);               % Reatância a vazio

Sbl = q*V1bl*I1bl;                  % Potência aparente total de rotor bloqueado
Qbl = sqrt(Sbl^2-Pbl^2);            % Potência reativa de rotor bloqueado

Xbl = (fen/fbl)*(Qbl/(q*I1bl^2));   % Reatância bloqueado

kX1 = 0.4;                          % Relação X1/X2 -> B(Depende da classe do motor)
k = kX1/(1-kX1);                    

syms X1 X2
eqn = k^2*X2^2+(Xbl*(1-k)-Xvz*(1+k))*X2+Xvz*Xbl == 0;
Xr = roots(double(sym2poly(lhs(eqn))));
X2 = min(Xr);
X1 = k*X2;

Xm = Xvz - X1;
Rbl = Pbl/(q * I1bl^2);
R2 = (Rbl - R1)*((X2+Xm)/Xm)^2;

Lm = Xm/w;
fprintf("R1: %.5f mΩ\n", R1*1000)
fprintf("R2: %.5f mΩ\n", R2*1000)
fprintf("Lm: %.5f H\n", Lm)
fprintf("L1: %.5f H\n", X1/w)
fprintf("L2: %.5f H\n", X2/w)

Xeq =  X1*1i+R1 +((Xm*1i)^-1+(X2*1i+(R2/s))^-1)^-1;
Leq = imag(Xeq)/w;
Req = real(Xeq);

Vf=220/60;
for i = 20:60
Z = sqrt(Req^2+(2*pi*i*Leq)^2)
I(i-19) = i*Vf/Z;
end
plot(20:60, I)

fprintf("Leq: %.5f H\n", Leq)
fprintf("Req: %.5f Ω\n", Req)