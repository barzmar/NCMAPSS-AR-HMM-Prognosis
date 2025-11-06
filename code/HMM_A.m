function A = HMM_A(idx)
%%create Hidden Markov Model Transition matrix

    numLabels = length(unique(idx)) + 1;
    A = eye(numLabels, numLabels);
    
    % Evaluating a11, a12, a22, a23, a33, a34

    for i = 1 : numLabels
        if i ~= numLabels
            A(i,i+1) = 1 / (sum(idx == i) + 1);
            A(i,i) = 1 - A(i,i+1);
        else
            A(i,i) = 1;
        end
    end
end