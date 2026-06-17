function Stan_dev = Objective_func(x)
    % Objective_func calculates the standard deviation of the cart's
    % angular velocity over time, scaled by a factor of 3 * w.
    %
    % Inputs:
    %   x - Design variables, where:
    %       x(1) = Angular velocity (w)
    %       x(2) = Radial distance (r2)
    %       x(3) = Incline angle (alpha1)
    %
    % Outputs:
    %   Stan_dev - The computed scaled standard deviation of the angular velocity

    % Extract design variables
    w = x(1);
    r2 = x(2);
    alpha1 = x(3);

    %% Computing the cart angle and velocity using the ODE solver
    [psi, T] = ODE_solver(x);

    %% Calculate the mean angular velocity
    Mean_w = (1 / T(end)) * trapz(T, psi(:, 2));

    %% Compute the standard deviation of angular velocity over time
    mean_dev = psi(:, 2) - Mean_w;  % Deviation from the mean
    Stan_dev = 3 * w * sqrt((1 / T(end)) * trapz(T, mean_dev .^ 2));  % Scaled standard deviation

end