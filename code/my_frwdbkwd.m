function [final_prob, final_state, best_path] = my_frwdbkwd(A, B, start_prob, HI)
    N = length(A);        % number of states
    T = length(HI);  % length of observation sequence
    
    % Initialize matrices
    alpha   = zeros(N, T);      % highest probability of any path reaching state i at time t
    psi     = zeros(N, T);      % store the state index that gave max probability
    p       = zeros(N, T);       % probability of being in state i 
    
    last_MOG = N-1;
    % --- Initialization (t = 1)
    [~, ~, p(1:last_MOG,1)] = cluster(B, HI(1,:));
    for i = 1:N
        if i == N
            p(i,1) = 0;
        end
        alpha(i,1) = start_prob(i) * p(i,1);
        psi(i,1) = 0;
    end
    alpha(:, 1) = alpha(:,1)./sum(alpha(:,1));


    % --- Recursion (t = 2 to T)
    for t = 2:T
        [~, ~, p(1:last_MOG,t)] = cluster(B, HI(t,:));
        for i = 1:N
            temp = (alpha(:,t-1)' * A(:,i));
            if i == N
                p(i,t) = 0;
            end
            alpha(i,t) = temp * p(i, t);
            psi(i,t) = temp;
        end
        alpha(:, t) = alpha(:,t)./sum(alpha(:,t));
    end
    
    % --- Termination
    final_prob = alpha(:,T);
    [~, final_state] = max(alpha(:,T));
   
    best_path = 0; % not used, to take out after swap with viterbi in RUL_script
    
    % % Display results
    % fprintf('Most likely state sequence:\n');
    % disp(states(best_path));
    % 
    % fprintf('Final probability of sequence: %.4f\n', final_prob);


end