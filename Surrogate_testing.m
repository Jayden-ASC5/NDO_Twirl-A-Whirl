% Define ranges for design variables
z1_range = linspace(0.3, 0.8, 50)'; % Range for design variable 1
z2_const = 0.8;         % Constant for design variable 2
z3_const = 0.058;         % Constant for design variable 3

dataset_size = 500;       % Initial dataset size
nvar = 3;               % Number of design variables

% Bounds for variables
lb = [3 * 2 * pi / 60; 0.8; 0.058];   % Lower bounds
ub = [8 * 2 * pi / 60; 0.8; 0.058]; % Upper bounds

% Generate initial dataset using LHS
x_uniform = lhsdesign(dataset_size, nvar);
x_dataset = [x_uniform(:, 1) * (ub(1) - lb(1)) + lb(1), ...
             x_uniform(:, 2) * (ub(2) - lb(2)) + lb(2), ...
             x_uniform(:, 3) * (ub(3) - lb(3)) + lb(3)];

% Preallocate arrays for surrogate and true values
surrogate_values = zeros(size(z1_range));
true_values = zeros(size(z1_range));

% Evaluate surrogate model and true objective function
for i = 1:length(z1_range)
    z = [z1_range(i), z2_const, z3_const]; % Current point
    surrogate_values(i) = Surrogate_eval(z, x_dataset); % Surrogate prediction
    true_values(i) = Objective_func(z);                 % True objective value
end

% Plot the results
figure;
plot(z1_range, surrogate_values, 'b-', 'LineWidth', 1.5); % Surrogate model
hold on;
plot(z1_range, true_values, 'r--', 'LineWidth', 1.5);     % True objective function
xlabel('Design Variable 1 (z1)');
ylabel('Objective Value');
legend('Surrogate Model', 'True Objective Function');
title('Comparison of Surrogate Model and True Objective');
grid on;
hold off;
