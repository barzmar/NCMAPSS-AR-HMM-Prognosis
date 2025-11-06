function alfa = RUL_calc(A_pred, current_state)

%% A: T (instances) vector of NxN transition matrix for future prediction
    N = length(A_pred{1});        % number of states
    T = length(A_pred);  % length of observation sequence
    alfa = zeros(N, T);  % Initialize the alpha matrix

    for i = 1 : N
        alfa(i, 1) = current_state(i);  % Initialize the first column of alpha with initial probabilities
    end

    for t = 2 : T
        alfa(:, t) = current_state(:)' * A_pred{t} ; %* [0 0 1 0]' * A_pred{1}(3,4)
    end

end