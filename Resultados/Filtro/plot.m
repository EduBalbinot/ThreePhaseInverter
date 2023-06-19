A = readmatrix ('a.xls');

s = get(0, 'ScreenSize');
figure(1);
set(gcf,'Position', [0 40 s(3) s(4)-120]);

subplot(2,1,1)
plot(A(:,4),A(:,5))
[ymax,idx] = max(A(:,5)); 
xlabel({'Tempo [s]';'(a)'});
ylabel('Tensão [V]');
hold on
plot(A(idx,4), ymax)
xlim([0.30333 0.30345])

subplot(2,1,2)
plot(A(:,4),A(:,6))
xlabel({'Tempo [s]';'(b)'});
ylabel('Tensão [V]')
xlim([0.30333 0.30345])

