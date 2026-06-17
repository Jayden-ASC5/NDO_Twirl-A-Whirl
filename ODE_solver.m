function [psi, t] = ODE_solver(x)
    % ODE_solver integrates the Cart dynamics from 0 to t_final.
    % 
    % Inputs:
    %   x - Parameters controlling the dynamics of the system
    %
    % Outputs:
    %   psi - Solution to the state over time
    %   t   - Time vector corresponding to each solution point in psi

    t_final = 1000;  % Final time for integration

    x0 = [0; 0];  % Initial conditions for state variables

    %% Define dynamics for the ODE solver
    Cart_Dyn = @(t, y) Tilt_a_Whirl_Dynamics(t, y, x);  

    %% Set ODE solver options for better control (optional)
    options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8); 

    %% Solve the ODE from t = 0 to t = t_final
    [t, psi] = ode45(Cart_Dyn, [0 t_final], x0, options);

    % %% Plotting for debugging
    % plot(t,psi(:,1)) 
    % hold on
    % plot(t,psi(:,2)) 
    % xlabel("time (s)")
    % ylabel('Angular Position and Velocity')
    % title('Cart Angular Position and Velocity')
    % legend('Position (rad)', 'Angular Velocity (rad/s)')
    % hold off
end 