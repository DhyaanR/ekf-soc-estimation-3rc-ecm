function H = jacobian_H(x, I, p)
% Jacobian of measurement h(x,u) wrt x
soc = x(1);

% dOCV/dSOC (for our ocv_model)
dOCV = d_ocv_dsoc(soc);

H = zeros(1,4);
H(1) = dOCV;
H(2) = -1;
H(3) = -1;
H(4) = -1;
end

function d = d_ocv_dsoc(soc)
% derivative of ocv_model(soc)
soc = min(1,max(0,soc));
d = 1.2 - 0.1*(1 - 2*soc);
end
