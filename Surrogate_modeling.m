function [hyp, covfunc, likfunc] = Surrogate_modeling(x)
    % Train a GP surrogate model for the given input samples `x` using GPML.
    % 
    % Inputs:
    %   x - Input data points for training the surrogate model.
    %   gpml_path (optional) - Path to the GPML library (default location is provided).
    % 
    % Outputs:
    %   hyp     - Optimized hyperparameters for the GP model.
    %   covfunc - Covariance function used in the GP model.
    %   likfunc - Likelihood function used in the GP model.

    mydir = 'C:\Users\legom\Documents\MATLAB\Numerical Design Optimization\Project 3\gpml-matlab-v3.6-2015-07-07\';
    % Add GPML paths
    addpath(mydir(1:end-1))
    addpath([mydir,'cov'])
    addpath([mydir,'doc'])
    addpath([mydir,'inf'])
    addpath([mydir,'lik'])
    addpath([mydir,'mean'])
    addpath([mydir,'prior'])
    addpath([mydir,'util'])

    % Define the function to be sampled
    Stan_dev = @(x) Objective_func(x);
    y = Stan_dev(x);

    % Define the covariance and likelihood functions
    covfunc = {@covMaterniso, 3};
    hyp.cov = [log(0.3); log(0.45)]; % Initial values for length scale and signal variance
    likfunc = @likGauss;
    hyp.lik = log(0.2);  % Initial noise level

    % Maximize the likelihood function to optimize hyperparameters
    hyp = minimize(hyp, @gp, -100, @infExact, [], covfunc, likfunc, x, y);
end
