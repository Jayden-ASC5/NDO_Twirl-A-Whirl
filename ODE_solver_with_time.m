function [psi, t] = ODE_solver_with_time(x, t_final)
    % ODE_solver_with_time integrates the Cart dynamics for a given t_final.
    x0 = [0; 0]; % Initial conditions
    Cart_Dyn = @(t, y) Tilt_a_Whirl_Dynamics(t, y, x); 
    options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
    [t, psi] = ode45(Cart_Dyn, [0 t_final], x0, options);
end
