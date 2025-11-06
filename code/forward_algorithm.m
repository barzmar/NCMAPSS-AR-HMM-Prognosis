function [current_prob, alpha, scale, logProb] = forward_algorithm(A, B, pi, O)
% FORWARD_ALGORITHM  Forward step for a Hidden Markov Model (HMM)
%
% Inputs:
%   A  - State transition matrix (NxN)
%   B  - Emission probability matrix (NxT), where B(i,t) = P(O_t | state i)
%   pi - Initial state probability vector (1xN)
%   O  - Observation sequence (1xT) -- only used for reference
%
% Outputs:
%   alpha   - Scaled forward probabilities (NxT)
%   scale   - Scaling factors for each time step (1xT)
%   logProb - Log-likelihood of the observation sequence

N = size(A,1);  % number of states
T = size(B,2);  % length of observation sequence

alpha = zeros(N, T);
scale = zeros(1, T);

l = length(B);

% --- Initialization ---
alpha(:,1) = pi(:) .* B(:,1);
scale(1) = sum(alpha(:,1));
alpha(:,1) = alpha(:,1) / scale(1);

% --- Induction ---
for t = 2:T
    alpha(:,t) = (A' * alpha(:,t-1)) .* B(:,t);
    scale(t) = sum(alpha(:,t));
    if scale(t) == 0
        scale(t) = eps;  % numerical stability
    end
    alpha(:,t) = alpha(:,t) / scale(t);
end
current_prob = alpha(:, T);
% --- Compute log-likelihood ---
logProb = sum(log(scale + eps));

end
