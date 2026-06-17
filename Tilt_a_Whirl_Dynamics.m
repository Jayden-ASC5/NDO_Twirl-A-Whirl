function [ydot] = Tilt_a_Whirl_Dynamics(tau, y, x)
    
    % Initialize ydot as a 2x1 zero matrix to store derivatives
    ydot = zeros(2,1);

    w = x(1,1);
    r2 = x(1,2);
    alpha1 = x(1,3);

    % Constant design parameters
    alpha0 = 0.036;   % Incline angle at theta = 0 (radians)
    r1 = 4.3;         % Distance from the center of the ride to the platform center (meters)
    Q0 = 20;          % Friction coefficient
    g = 9.8;          % Gravitational acceleration (m/s^2)

    % Define eps as a geometry parameter based on r1 and r2
    eps = r1 / (9 * r2);

    % Define incline angle alpha as a function of tau, with alpha1 as the amplitude
    alpha = alpha0 - alpha1 * cos(tau);

    % Define beta as a function of tau, used to create an oscillating angle
    beta = 3 * alpha1 * sin(tau);

    % Define gamma as a scaling factor related to gravitational force and radius
    gamma = (1 / (3 * w)) * sqrt(g / r2);

    % Retrieve the current state variables, psi (angle) and psi_d (angular velocity)
    psi = y(1);        % Current angle of the ride
    psi_d = y(2);      % Current angular velocity of the ride

    % Calculate the derivatives of psi and psi_d
    ydot(1,1) = y(2);   % Derivative of angle (psi) is the current angular velocity (psi_d)
    
    % Second derivative of psi, including friction, geometry, and oscillation effects
    ydot(2,1) = -((gamma / Q0) * psi_d + (eps - (alpha * gamma^2)) * sin(psi) + (beta * gamma^2) * cos(psi));

end
