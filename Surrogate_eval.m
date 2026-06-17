function m = Surrogate_eval(z, points)
    % Surrogate_eval evaluates the surrogate model at the given input 'z'
    % using the provided design points and corresponding objectives.
    %
    % Inputs:
    %   z      - Input design point(s) where the surrogate model is evaluated
    %   points - Matrix of design points used to build the surrogate model
    %
    % Outputs:
    %   m - Predicted output (mean of the GP) at input 'z'

    x = points;
    
    % Add GPML paths
    mydir = 'C:\Users\smith\Documents\MATLAB\Numerical Design Optimization\Project 3\gpml-matlab-v3.6-2015-07-07\';
    addpath(mydir(1:end-1))
    addpath([mydir,'cov'])
    addpath([mydir,'doc'])
    addpath([mydir,'inf'])
    addpath([mydir,'lik'])
    addpath([mydir,'mean'])
    addpath([mydir,'prior'])
    addpath([mydir,'util'])

    % Define the function to be sampled
    Stan_dev = @(x_row) Objective_func(x_row); % Objective function

    % Preallocate the output array for y
    y = zeros(size(x, 1), 1);

    % Loop over rows of x and compute y
    for i = 1:size(x, 1)
        y(i) = Stan_dev(x(i, :)); % Evaluate the function for each row
    end

    % Define the covariance and likelihood functions
    covfunc = {@covMaterniso, 3};
    hyp.cov = [log(0.25); log(0.6)]; % Initial values for length scale and signal variance
    likfunc = @likGauss;
    hyp.lik = log(0.4);  % Initial noise level

    % Maximize the likelihood function to optimize hyperparameters
    hyp = minimize(hyp, @gp, -100, @infExact, [], covfunc, likfunc, x, y);

    % Use the GP to predict the mean value at the input point z
    [m, ~] = gp(hyp, @infExact, [], covfunc, likfunc, x, y, z);
end
