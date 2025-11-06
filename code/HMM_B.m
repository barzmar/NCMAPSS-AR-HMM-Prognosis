function B = HMM_B(gm)
%% create Hidden Markov Model Emission probabilities (based on MOG distribution)

    B = cell(gm.NumComponents, 1); % Initialize B as a cell array

    % For each state of the current signal evaluate the describing MoG
    for s = 1: gm.NumComponents  % 3 is the number of states
        mu = gm.mu;
        Sigma = gm.Sigma;
        B{s} = gmdistribution(mu(s,:), Sigma(:,:,s));
    end

end