function Ma = TRPWM(A, w, t, theta, phase)
    Ma= A * asin(sin(w * t + theta * phase));   % Senoidal 0º
    for i=1:numel(Ma)
        if Ma(i)>0.98
            Ma(i)=0.98;
        end
        if Ma(i)<-0.98
            Ma(i)=-0.98;
        end
    end
    return
end