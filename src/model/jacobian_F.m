function F = jacobian_F(x, I, dt, p)
% Jacobian of state transition f(x,u) wrt x
% x = [soc; v1; v2; v3]
a1 = exp(-dt/(p.R1*p.C1));
a2 = exp(-dt/(p.R2*p.C2));
a3 = exp(-dt/(p.R3*p.C3));

F = eye(4);
% soc_next depends on soc only (linear)
F(1,1) = 1;
% v_i_next depends on v_i only
F(2,2) = a1;
F(3,3) = a2;
F(4,4) = a3;
end
