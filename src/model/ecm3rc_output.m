function V = ecm3rc_output(x, I, p)
soc = x(1); v1 = x(2); v2 = x(3); v3 = x(4);
V = ocv_model(soc) - I*p.R0 - v1 - v2 - v3;
end
