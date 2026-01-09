function x_next = ecm3rc_state_transition(x, I, dt, p)
% x = [soc; v1; v2; v3]
% p: struct with fields R0,R1,C1,R2,C2,R3,C3,Q_As,eta

soc = x(1); v1 = x(2); v2 = x(3); v3 = x(4);

% SOC update (discharge current positive convention)
soc_next = soc - (p.eta * dt / p.Q_As) * I;
soc_next = min(1, max(0, soc_next));

a1 = exp(-dt/(p.R1*p.C1));
a2 = exp(-dt/(p.R2*p.C2));
a3 = exp(-dt/(p.R3*p.C3));

v1_next = a1*v1 + p.R1*(1-a1)*I;
v2_next = a2*v2 + p.R2*(1-a2)*I;
v3_next = a3*v3 + p.R3*(1-a3)*I;

x_next = [soc_next; v1_next; v2_next; v3_next];
end
