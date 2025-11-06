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

    %calculation of RUL when penultimate (PU) state is reached in that HMM (constant RUL
    %since it is impossible to rach last state, no MOG of it exists)
    inStatePU = prevState_prob;
    inStatePU(nStates) = 1;
    RULPU(markovModelCounter) = myRUL_iteration(A_inf, inStatePU);
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
                step34 = (1-A(nStates,nStates+1))/RULPU(markovModelCounter);
                Amod = A;
                Amod(nStates,nStates+1) = min(1, A(nStates,nStates+1) + step34 * counterState3);
                Amod(nStates,nStates) = max(0, A(nStates,nStates) - step34 * counterState3)
                adjCurrState_prob = currState_prob' * Amod;
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