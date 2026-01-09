function [x_upd, P_upd, innov, S] = ekf_update(x_pred, P_pred, I, V_meas, p, R)
V_pred = ecm3rc_output(x_pred, I, p);
H = jacobian_H(x_pred, I, p);

innov = V_meas - V_pred;
S = H*P_pred*H' + R;
K = (P_pred*H')/S;

x_upd = x_pred + K*innov;
x_upd(1) = min(1,max(0,x_upd(1))); % clamp SOC

P_upd = (eye(size(P_pred)) - K*H)*P_pred;
end
