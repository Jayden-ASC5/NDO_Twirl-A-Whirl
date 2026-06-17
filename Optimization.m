clc
clear all
% Initialization
max_iterations = 3;     % Maximum number of iterations
tol = 1e-3;             % Convergence tolerance
dataset_size = 200;       % Initial dataset size
nvar = 3;               % Number of design variables

% Bounds for variables
lb = [3 * 2 * pi / 60; 0.1; 0];   % Lower bounds
ub = [8 * 2 * pi / 60; 1.5; 0.3]; % Upper bounds

% Generate initial dataset using LHS
x_uniform = lhsdesign(dataset_size, nvar);
x_dataset = [x_uniform(:, 1) * (ub(1) - lb(1)) + lb(1), ...
             x_uniform(:, 2) * (ub(2) - lb(2)) + lb(2), ...
             x_uniform(:, 3) * (ub(3) - lb(3)) + lb(3)];

% Initialize variables
z0 = mean([lb'; ub'], 1);  % Initial guess (midpoint of bounds)
z_opt_history = [];        % Store optimized points
fval_history = [];         % Store minimized surrogate values

% Iterative Optimization Loop for Maximization
for iter = 1:max_iterations
    fprintf('Iteration %d:\n', iter);
    
    % Define the surrogate function for maximization
    surrogate = @(z) -Surrogate_eval(z, x_dataset);
    
    % Maximize the surrogate model using fmincon
    options = optimoptions(@fmincon, 'Algorithm', 'sqp', ...
        'SpecifyObjectiveGradient', false, ...
        'Display', 'iter', ...
        'Diagnostics', 'on');
    [z_opt, fval] = fmincon(surrogate, z0, [], [], [], [], lb, ub, [], options);
    
    % Convert minimized negative value back to maximized value
    fval = -fval;
    
    % Evaluate the true objective function at the optimized point
    true_fval = Objective_func(z_opt);  % Assuming Objective_func is already positive
    
    % Save optimization history
    z_opt_history = [z_opt_history; z_opt];
    fval_history = [fval_history; true_fval];
    
    % Convergence check
    if iter > 1 && abs(fval_history(end) - fval_history(end-1)) < tol
        fprintf('Converged after %d iterations.\n', iter);
        break;
    end

    % Add the new point to the dataset
    x_dataset = [x_dataset; z_opt];
    
    % Update the initial guess for the next iteration
    z0 = z_opt;
end


% Results
disp('Optimized points:');
disp(z_opt_history);
disp('Objective values:');
disp(fval_history);

