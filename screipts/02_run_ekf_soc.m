clc; clear; close all;
addpath(genpath(pwd));

% --- Load demo data ---
% Replace with your Synthetic_LiPo data loader later
run("scripts/01_load_demo_data.m"); % should create t, I, V

% --- Parameters (example) ---
p = struct();
p.R0 = 0.02;  p.R1 = 0.01; p.C1 = 2000;
p.R2 = 0.02;  p.C2 = 5000;
p.R3 = 0.05;  p.C3 = 20000;
p.eta = 1.0;

% Nominal capacity for SOC dynamics (A*s)
% Use your cell capacity here: Q_As = Ah*3600
p.Q_As = 2.2*3600;  % example 2.2Ah LiPo

% --- EKF tuning ---
x = [1.0; 0; 0; 0];           % initial SOC=100%
P = diag([1e-3, 1e-2, 1e-2, 1e-2]);

Q = diag([1e-7, 1e-5, 1e-5, 1e-5]); % process noise
R = 1e-4;                            % measurement noise variance (V^2)

soc_est = zeros(size(t));
V_est   = zeros(size(t));

for k = 1:numel(t)
    if k == 1
        dt = t(2)-t(1);
    else
        dt = t(k)-t(k-1);
    end

    [x_pred, P_pred] = ekf_predict(x, P, I(k), dt, p, Q);
    [x, P] = ekf_update(x_pred, P_pred, I(k), V(k), p, R);

    soc_est(k) = x(1);
    V_est(k) = ecm3rc_output(x, I(k), p);
end

assignin("base","soc_est",soc_est);
assignin("base","V_est",V_est);

% Plot
figure; plot(t, soc_est*100); grid on;
xlabel("Time (s)"); ylabel("SOC (%)"); title("EKF SOC Estimate");

figure; plot(t, V, t, V_est); grid on;
xlabel("Time (s)"); ylabel("Voltage (V)");
legend("Measured","EKF Predicted"); title("Voltage: measured vs EKF model");
