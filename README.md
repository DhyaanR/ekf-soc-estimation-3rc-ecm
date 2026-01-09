EKF-BASED SOC ESTIMATION USING 3RC ECM
====================================

OVERVIEW
--------
This repository implements a State-of-Charge (SOC) estimation algorithm using an
Extended Kalman Filter (EKF) for a Li-ion battery modeled with a 3RC Equivalent
Circuit Model (ECM).

The EKF estimates SOC in real time using terminal voltage and current measurements,
while capturing battery dynamics through three RC polarization branches.

The implementation is written in MATLAB and is suitable for Battery Management
System (BMS) algorithm development, validation, and future Simulink integration.


KEY FEATURES
------------
- Extended Kalman Filter (EKF) based SOC estimation
- 3RC Equivalent Circuit Model (ECM)
- Exact discrete-time RC state propagation
- Analytical Jacobians for EKF
- Modular MATLAB code structure
- Easy extension to OCV lookup tables and SOH estimation


BATTERY MODEL
-------------

STATE VECTOR
------------
x = [ SOC  v1  v2  v3 ]^T

Where:
SOC : State of Charge (0 to 1)
v1  : RC branch 1 polarization voltage
v2  : RC branch 2 polarization voltage
v3  : RC branch 3 polarization voltage


STATE EQUATIONS (DISCRETE-TIME)
-------------------------------
SOC dynamics:
SOC(k+1) = SOC(k) - (eta * dt / Q) * I(k)

RC polarization dynamics:
v1(k+1) = a1 * v1(k) + R1 * (1 - a1) * I(k)
v2(k+1) = a2 * v2(k) + R2 * (1 - a2) * I(k)
v3(k+1) = a3 * v3(k) + R3 * (1 - a3) * I(k)

Where:
a_i = exp( -dt / (Ri * Ci) )


MEASUREMENT EQUATION
--------------------
V(k) = OCV( SOC(k) ) - I(k)*R0 - v1(k) - v2(k) - v3(k)


EKF FORMULATION
---------------

NONLINEAR STATE EQUATION
-----------------------
x(k+1) = f( x(k), u(k) )


NONLINEAR MEASUREMENT EQUATION
------------------------------
V(k) = h( x(k), u(k) )


PREDICTION STEP
---------------
x_hat(k|k-1) = f( x_hat(k-1), u(k) )

P(k|k-1) = F(k) * P(k-1) * F(k)' + Q


UPDATE STEP
-----------
K(k) = P(k|k-1) * H(k)' * inv( H(k) * P(k|k-1) * H(k)' + R )

x_hat(k) = x_hat(k|k-1) + K(k) * ( V_meas(k) - V_hat(k) )

P(k) = ( I - K(k) * H(k) ) * P(k|k-1)


JACOBIANS
---------

STATE JACOBIAN (F)
------------------
F = [ 1    0    0    0
      0   a1    0    0
      0    0   a2    0
      0    0    0   a3 ]


MEASUREMENT JACOBIAN (H)
-----------------------
H = [ dOCV_dSOC  -1  -1  -1 ]

Where:
dOCV_dSOC = derivative of OCV with respect to SOC


REPOSITORY STRUCTURE
--------------------
ekf-soc-estimation-3rc-ecm/
|
|-- README.md
|-- scripts/
|   |-- 01_load_demo_data.m
|   |-- 02_run_ekf_soc.m
|   |-- 03_plot_results.m
|
|-- src/
|   |-- model/
|   |   |-- ecm3rc_state_transition.m
|   |   |-- ecm3rc_output.m
|   |   |-- jacobian_F.m
|   |   |-- jacobian_H.m
|   |
|   |-- ekf/
|   |   |-- ekf_predict.m
|   |   |-- ekf_update.m
|   |
|   |-- utils/
|       |-- ocv_model.m
|       |-- clamp.m
|
|-- docs/
    |-- ekf_math.md


HOW TO RUN
----------
1. Open MATLAB
2. Set the repository root as the current folder
3. Run the EKF SOC estimation script:

scripts/02_run_ekf_soc


OUTPUTS
-------
- Estimated SOC trajectory
- Predicted terminal voltage
- Voltage tracking comparison plots
- SOC estimate over time

All outputs are kept in the MATLAB workspace for interactive analysis.


ASSUMPTIONS
-----------
- Discharge current is positive
- Coulombic efficiency eta = 1
- Battery nominal capacity Q is known
- OCV is modeled as a smooth function of SOC
- Temperature effects are not included


POSSIBLE EXTENSIONS
-------------------
- OCV(SOC) lookup table with numerical derivative
- Joint SOC-SOH estimation
- Temperature-dependent ECM parameters
- Unscented Kalman Filter (UKF)
- Simulink real-time implementation


REQUIREMENTS
------------
- MATLAB


AUTHOR
------
Dhyaan Radhakrishnamurthy
M.Eng Electrical & Computer Engineering, University of Ottawa
LinkedIn: https://www.linkedin.com/in/dhyaan-r-83b0a9198/
