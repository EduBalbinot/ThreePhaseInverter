function [Xta, Xtb, Xtc] = DrawFFT(Ma, Mb, Mc, F, triang, Mf, f, t, xai, xbi, xci, Aon, Bon, Con, normal)
    M = {Ma, Mb, Mc};
    X = {xai, xbi, xci};
    Ao = {Aon, Bon, Con};
    
    if normal 
        for m = 1:length(M)
            for i = 1:length(t)
               if M{m}(i) > triang(i)
                   Xt{m}(i) = 1;
               else
                   Xt{m}(i) = 0;
               end
            end
        end
    else
        for m = 1:length(M)
            o=Ao{m} ;j = 1;
            for i = 1:length(t)
                if j<=length(X{m})
                    if t(i)>X{m}(j)
                        o = -o;
                        j=j+1;
                    end
                else
                    o = Ao{m};
                end
                if o==-1; Xt{m}(i)=-1;
                else Xt{m}(i)=o; end;
                  
            end
        end
    end
    
    [Xta, Xtb, Xtc] = deal(Xt{:});
    Xt = Xta - Xtb;
    Xtt = repmat(Xt, 1, f);
    Y = fft(Xtt);

    P2 = abs(Y/F);
    P1 = P2(1:F/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    F1 =(0:(F/2));
    
    subplot(2,1,1)
    plot(t, Xt)
    xlabel("t(s)")
    xlim([0, t(end)])
    title('PWM')
    subplot(2,1,2)
    plot(F1(1:f*5*(Mf+2)),P1(1:f*5*(Mf+2))) 
    xlabel("f (Hz)")
    title('FFT')
   
        Dv=0; Di=0;
    for i =setdiff(1:length(P1), f+1)
        Dv = Dv + P1(i)^2;
        Z = sqrt(134.54932^2 + (2 * pi * (i-1) * 0.98241)^2);
        Di = Di + (P1(i)/Z)^2;
    end
    
    TDHv = sqrt(Dv)/P1(f+1);
    Z1 = sqrt(134.54932^2 + (2 * pi * f * 0.98241)^2);
    TDHi = sqrt(Dv)/(P1(f+1)/Z1);
    disp(strjoin(["TDHv:  " TDHv]))
    disp(strjoin(["TDHi:  " TDHi]))
return
end