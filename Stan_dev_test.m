%% Experiment for verifying standard deviation
n = 300;
r2 = 0.8;
alpha1 = 0.058;
w = ones(1,n);
Stan_dev = ones(1,n);

for i = 1:n 
    w(i) = 0.003*i;
    x = [w(i),r2,alpha1];
    Stan_dev(i) = Objective_func(x);
end 

plot(w,Stan_dev)
ylabel('Standard Deviation of Cart Angular Velocity (rad/s)')
xlabel('Ride Angular Velocity (rad/s)')
title('Objective Function evaluation at Different Ride Angular Velocities')