% Define parameters
x = [6.5*2*pi/60, 0.8, 0.058]; 

% Initialize test parameters
t_final_values = linspace(10,3000,100); % Increasing final times
std_values = zeros(size(t_final_values)); % Store standard deviations

% Loop through different final times
for i = 1:length(t_final_values)
    % Solve ODE for the current final time
    t_final = t_final_values(i);
    
    % Update ODE_solver to take t_final as an argument
    [psi, ~] = ODE_solver_with_time(x, t_final);
    
    % Extract angular velocity 
    angular_velocity = psi(:, 2);
    
    % Compute standard deviation
    std_values(i) = std(angular_velocity);
end

% Plot standard deviation over increasing final times
figure;
plot(t_final_values, std_values, '-o');
xlabel('T Total Non-dimensional time');
ylabel('Standard Deviation of Angular Velocity (rad/s)');
title('Convergence of Standard Deviation of Angular Velocity');
grid on;
