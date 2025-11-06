clear

load("..\dataNew\HMMandMOG\DATASET__PLACEHOLDER\HMMandMOG.mat");
cell_all_HI = load("..\dataNew\HealthIndexes\DATASET__PLACEHOLDER\HI_targets11  12_01.mat");

boSaveRUL = false;

unitHmm = 1; unitHI = 1;
Hmm = all_HMM{unitHmm};
Mog = all_MOG{unitHmm};
HI = cell2mat(cell_all_HI.total_frmse(unitHI, :));

infinity = 10000;
RUL = zeros(infinity, 1);
actualRUL = zeros(length(HI), 1);

maxRUL = length(HI);

filteredHI = movmean(HI, [2 0], 1, "omitmissing");

% calculating transition matrix up to infinity steps away
A_inf = A_prediction(Hmm.A, infinity);

nStates = Mog.NumComponents;

prevState = 1;
currentState = 1;
prevState_prob = zeros(nStates + 1, 1);
currState_prob = zeros(nStates + 1, 1);
currState_prob(1) = 1;
for l = 1 : maxRUL
    if l == 1
        RUL(l) = myRUL_iteration(A_inf, currState_prob);
        currentState = 1;
        adjCurrState_prob = currState_prob;
    else
        [currState_prob, currentState, ~]= my_frwdbkwd(Hmm.A, Mog, adjCurrState_prob, filteredHI(l-1:l,:));
        if prevState == nStates
            counterState3 = counterState3 + 1;
            adjCurrState_prob = currState_prob' * A_inf{counterState3}
        else
            counterState3 = 0;
            adjCurrState_prob = currState_prob';
        end
        RUL(l) = myRUL_iteration(A_inf, adjCurrState_prob);
    end
    prevState = currentState;
    probs(l,:) = adjCurrState_prob;
    
    actualRUL(maxRUL- l + 1) = l - 1;
end

figure;
hold on;
xlim([0, length(actualRUL)])
plot(actualRUL);
plot(RUL);

if boSaveRUL

    foldername = '..\dataNew\RULpredictions\DATASET__PLACEHOLDER';
    filename = "PLACEHOLDERtargets_11_12";
    
    if not(exist(foldername, "dir"))
        mkdir(foldername);
    end
    
    save(strcat(foldername, "\", filename), "RUL", "actualRUL");
end