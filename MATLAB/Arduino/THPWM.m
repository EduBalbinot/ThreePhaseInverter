function Ma = THPWM(A, w, t, theta, phase)
    k = 0.3;
    C = k * A * sin(3 * w * t);
    Ma = A * sin(w * t + theta * phase) + C;     % Senoidal 0º
return
end