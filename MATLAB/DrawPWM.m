function DrawPWM(Xta, t, c)
    hold on
    plot(t,Xta,'LineWidth', 1, 'Color', c);
    fill(t,[-1 Xta(2:end-1) -1],c,'FaceAlpha',0.5);
    xlim([0, t(end)]);
    hold off;
end