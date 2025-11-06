function [beta] = backward_algorithm(A, B, scale)
% BACKWARD_ALGORITHM  Backward step for a Hidden Markov Model (HMM)
%
% Inputs:
%   A     - State transition matrix (NxN)
%   B     - Emission probability matrix (NxT), same as used in forward step
%   scale - Scaling factors from the forward algorithm (1xT)
%
% Outputs:
%   beta  - Scaled backward probabilities (NxT)

N = size(A,1);
T = size(B,2);

beta = zeros(N, T);

% --- Initialization ---
beta(:,T) = 1 / scale(T);

% --- Induction ---
for t = T-1:-1:1
    beta(:,t) = (A * (B(:,t+1) .* beta(:,t+1))) / scale(t);
end

end
