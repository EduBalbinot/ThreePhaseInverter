function Ma = CSVPWM(A, w, t, theta, phase)
    M1a = SPWM(A, w, t, theta, 0);
    M1b = SPWM(A, w, t, theta, 1);
    M1c = SPWM(A, w, t, theta, 2);
    for i=1:numel(M1a)
        minM(i) = min([M1a(i) M1b(i) M1c(i)]);
        maxM(i) = max([M1a(i) M1b(i) M1c(i)]);
    end
    Ma = (2/sqrt(3))*(A * sin(w * t + theta * phase)-(1/2)*(maxM+minM));
    
    return
end