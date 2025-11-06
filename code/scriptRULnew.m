%% RUL calculation (online)
% this script calculates the RUL, by applying the forward algorithm to the
%  current state and then calculating the mean of the survival function
%
%  S(t) = 1 - F(t)
%
% Since the number of MOGs used does not include the final broken state, it
% is impossible to have an emission of the ultimate state, hence in this
% version of the script the transition Matrix A is applied the amount of
% times the system finds itself in the penultimate state (just before
% breaking, the last MOG). This creates a logarithmic like effect towards
% the end of life.


clear

load("..\dataNew\HMMandMOG\DATASET__PLACEHOLDER\HMMandMOG11  12_11.mat");
cell_all_HI = load("..\dataNew\HealthIndexes\DATASET__PLACEHOLDER\HI_targets11  12_08.mat");

boSaveRUL = false;

unitHmm = 1; unitHI = 8;
Hmm = all_HMM{unitHmm};
Mog = all_MOG{unitHmm};
HI = movmean(cell2mat(cell_all_HI.total_frmse(unitHI, :)), [3 0]);

step = 1;
infinity = 1000;
RUL = zeros(infinity, 3);
actualRUL = zeros(length(HI), 1);

maxRUL = length(HI);

markovModelCounter = 1;

% filteredHI = movmean(HI, [3 0], 1, "omitmissing");

% calculating transition matrix up to infinity steps away


nStates = Mog.NumComponents;
training_hmm = [1, 2, 3, 4, 8];
for hmm = training_hmm
    
    Hmm = all_HMM{hmm};
    A = Hmm.A;
    A_inf = A_prediction(A, infinity);
    [~, ~, B] = cluster(all_MOG{hmm}, HI(:, :));
    B = horzcat(B, zeros(maxRUL,1))';
    prevState = 1;
    currentState = 1;
    prevState_prob = zeros(nStates + 1, 1);
    currState_prob = zeros(nStates + 1, 1);
    currState_prob(1) = 1;
    initial_prob = currState_prob;
    for l = 1 : step : maxRUL
        if l == 1
            RUL(l, markovModelCounter) = myRUL_iteration(A_inf, currState_prob);
            currentState = 1;
            adjCurrState_prob = currState_prob;
            logLikeAlpha = 1;
        else
            [currState_prob, ~, scale, logLikeAlpha]= forward_algorithm(A, B(:,1:l), initial_prob, HI(1:l, :));
            [~, currentState] = max(currState_prob);
            if prevState == nStates
                counterState3 = counterState3 + step;
                adjCurrState_prob = currState_prob' * A_inf{counterState3};
            else
                counterState3 = 0;
                adjCurrState_prob = currState_prob;
            end
            RUL(l, markovModelCounter) = myRUL_iteration(A_inf, adjCurrState_prob);
        end
        prevState = currentState;
        probs(l,:) = adjCurrState_prob;
        
        
        logLikeAlphaArray(l, markovModelCounter) = logLikeAlpha;
    end
    markovModelCounter = markovModelCounter + 1;
end
[~,b] = max(logLikeAlphaArray, [], 2);
actualRUL = linspace(maxRUL, 0, maxRUL);

for RULset = 1 : length(training_hmm)
    figure;
    hold on;
    xlim([0, length(actualRUL)])
    plot(actualRUL);
    plot(RUL(:,RULset), "LineStyle","none", "Marker","o" );
end

if boSaveRUL

    foldername = '..\dataNew\RULpredictions\DATASET__PLACEHOLDER';
    filename = "PLACEHOLDERtargets_11_12";
    
    if not(exist(foldername, "dir"))
        mkdir(foldername);
    end
    
    save(strcat(foldername, "\", filename), "RUL", "actualRUL");
end