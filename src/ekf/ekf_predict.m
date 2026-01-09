function [x_pred, P_pred] = ekf_predict(x, P, I, dt, p, Q)
x_pred = ecm3rc_state_transition(x, I, dt, p);
F = jacobian_F(x, I, dt, p);
P_pred = F*P*F' + Q;
end
