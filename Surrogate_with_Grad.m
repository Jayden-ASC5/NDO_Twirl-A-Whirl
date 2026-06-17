function [min_surrogate, grad] = Surrogate_with_Grad(x,points)
    % This function calculates the negative heat flux through a heat exchanger
    % and its gradient using the complex-step approximation method.
    %
    % Inputs:
    %   x        - Design variables (coefficients of the Fourier series).
    % Outputs:
    %   min_surrogate - Negative of the surrogate, for minimization purposes.
    %   grad          - Gradient of min_surrogate with respect to design variables.

    %% Calculate the Objective
    surrogate = Surrogate_eval(x,points);
    min_surrogate = -surrogate;  % Negate to transform maximization to minimization

    %% Compute gradient using complex-step approximation
    epsilon = 1e-20;  % Small complex-step size
    grad = zeros(length(x), 1);  % Initialize gradient

    for i = 1:length(x)
        x_step = x;  % Copy the original coefficients
        x_step(i) = x_step(i) + 1i * epsilon;  % Perturb with complex step
        surrogate_step = Surrogate_eval(x_step,points);  % Recalculate flux
        min_surrogate_step = -surrogate_step;

        % Approximate the derivative with the complex-step
        grad(i) = imag(min_surrogate_step) / epsilon;
    end
end
