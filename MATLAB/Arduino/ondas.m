% clear, clc, close all               % Limpa workspace
Mf = 51;                            % Proporção triangular:senoidal
tolerance = 1;                    % Tolerância para evitar chaveamentos curtos
ma = 0.98;                              % Amplitude
f = 60;                             % Frequencia da carrier
Fst = 200;                          % Frequencia de amostragem por periodo da triangular

Fs= Fst * Mf;                       % Frequencia de amostragem por periodo da carrier
F = Fs*Mf;                          % Frequencia de amostragem em Hz
L = F / f;                          % Tamanho do sinal 
Ts = 1 / F;                         % Periodo de amostragem
t = (0:L-1)*Ts;                     % Vetor do tempo

w = 2 * pi * f;                     % w
theta = 2/3 * pi;                   % offset
triang = sawtooth(Mf*2*pi*f*t,1/2); % Triangular

%SPWM   THPWM    CSVPWM   TRPWM
Carrier = 'SPWM';                   % Troque pelas opções acima para mudar de técnica de modulação
eval(strjoin(["Ma = " Carrier "(ma, w, t, theta, 0);"])); %Ma
eval(strjoin(["Mb = " Carrier "(ma, w, t, theta, 1);"])); %Mb
eval(strjoin(["Mc = " Carrier "(ma, w, t, theta, 2);"])); %Mc

% comparação entre a triangular e as senoidais
Divider = floor(length(t)/3000);
while mod(length(t), Divider) ~= 0
    Divider = Divider + 1;
end
xa=0;xb=0;xc=0;ya=0;yb=0;yc=0;
for i = 1:length(t)/Divider:length(t) %separada para ser mais rápido
    a=i+length(t)/Divider-1;
    clc
    disp(strjoin([floor(a/(length(t))*100) "%"]))
    [x1,y1]=polyxpoly(t(i:a),triang(i:a),t(i:a),Ma(i:a));
    [x2,y2]=polyxpoly(t(i:a),triang(i:a),t(i:a),Mb(i:a));
    [x3,y3]=polyxpoly(t(i:a),triang(i:a),t(i:a),Mc(i:a));
    xa = [xa; x1];
    xb = [xb; x2];
    xc = [xc; x3];
    ya = [ya; y1];
    yb = [yb; y2];
    yc = [yc; y3];
end

[xai, xbi, xci, Xto, Aon, Bon, Con] = calculos(t, triang, tolerance, ya, yb, yc,xa, xb, xc);

fftType = false; %calcular a fft sem os cortes da 
% figure(1)
[Xta, Xtb, Xtc] = DrawFFT(Ma, Mb, Mc, F, triang, Mf, f, t, xai, xbi, xci, Aon, Bon, Con, fftType);
% figure(3)
% DrawFFT(Ma, Mb, Mc, F, triang, Mf, f, t, xai, xbi, xci, Aon, Bon, Con, 1);

%   plotar as curvas
s = get(0, 'ScreenSize');
figure(2);
set(gcf,'Position', [0 40 s(3) s(4)-120]);
subplot(4,1,1);
hold on;
plot(t,triang,'k');
plot(t,Ma,'r');
plot(t,Mb,'g');
plot(t,Mc,'b');
eval(strjoin(["plot(xai(:,1)," Carrier "(ma, w, xai(:,1)', theta, 0), 'ro', 'MarkerSize', 3, 'MarkerFaceColor', 'r')"]));
eval(strjoin(["plot(xbi(:,1)," Carrier "(ma, w, xbi(:,1)', theta, 1), 'go', 'MarkerSize', 3, 'MarkerFaceColor', 'g')"]));
eval(strjoin(["plot(xci(:,1)," Carrier "(ma, w, xci(:,1)', theta, 2), 'bo', 'MarkerSize', 3, 'MarkerFaceColor', 'b')"]));
xlim([0, t(end)]);
ylim([-1.1, 1.1]);
hold off;
subplot(4,1,2);
DrawPWM(Xta, t, 'r');
ylabel("Ma")
subplot(4,1,3);
DrawPWM(Xtb, t, 'g');
ylabel("Mb")
subplot(4,1,4);
DrawPWM(Xtc, t, 'b');
ylabel("Mc")
xlabel("t(s)")

XtoS = arduinoStruct(Xto, Aon, Bon, Con);
