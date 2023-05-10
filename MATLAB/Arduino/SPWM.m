function Ma = SPWM(A, w, t, theta, phase)
    Ma= A * sin(w * t + theta * phase);   % Senoidal 0º
    return
end