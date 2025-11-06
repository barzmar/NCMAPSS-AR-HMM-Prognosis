clear 
boSaveHmm = true;

targets = [11 12];

cell_all_HI = load("..\dataNew\HealthIndexes\DATASET__PLACEHOLDER\HI_targets11  12_08.mat");
all_HI = cell_all_HI.total_frmse; % Extracting the relevant data from the loaded structure

nHMM = 3;

N = length(all_HI);
all_MOG = cell(N,1);
all_HMM = cell(N,1);

proportionComp = [0.6, 0.9, 1.0];

modeFilterWindow = 3;

%cycling through all units
for i = 1 : N
    n_HI = size(all_HI, 2);
    HI = cell2mat(all_HI(i,1:n_HI));
    HI = movmean(HI, [5 0]);
    L = length(HI);
    likely_state = zeros(L, 1);

    prevIndex = 1;
    for mm = 1 : nHMM
        index = floor(L * proportionComp(mm));
        likely_state(prevIndex:index,1) = mm;
        prevIndex = index;
    end
    
    % for j = 1 : n_HI
    %    Mu(1, j) = mean(HI(1:index1,j),1);
    %    Mu(2, j) = mean(HI(index1:index2,j),1);
    %    Mu(3, j) = mean(HI(index2:index3,j),1);
    % 
    % end
    % 
    % Sigma(:,:,1) = cov(HI(1:index1,:));
    % Sigma(:,:,2) = cov(HI(index1:index2,:));
    % Sigma(:,:,3) = cov(HI(index2:index3,:));

    options = statset('MaxIter',1000);

    

    
    % S = struct('mu', Mu, 'Sigma', Sigma, 'ComponentProportion', proportionComp);
    % 
    % gm = fitgmdist(HI, 3, 'Start', S, 'CovarianceType', 'full', 'Options', options);
    gm = fitgmdist(HI, nHMM, "Start", likely_state, "Options", options);

    idx = cluster(gm, HI);
    
    figure;
    hold on;
    plot(idx, 'LineStyle','none', 'Marker','o');
    
    mon_idx = enforceMonotonic(modeFilter(idx, modeFilterWindow));
    plot(mon_idx,'LineStyle','none', 'Marker','x');
    legend("clustering, no filter", strcat("clustering, mode filter (window = ", num2str(modeFilterWindow), ")  and monotonic"));
    title("Health Indexes (HI) assignement to state/MOG cluster(1->healthy; 3 -> imminent damage");
    ylabel("State");
    xlabel("Window (Time)");
    
    backHI = cell(gm.NumComponents, 1);
    for state = 1 : gm.NumComponents
        backHI{state} = HI(find(mon_idx == state),:);
        
        % postMu = mean(backHI{state});
        % postSigma = var
        gm_post = fitgmdist(HI, nHMM, "Start", mon_idx, "CovarianceType", "full", "Options", options);
        S_single = struct('mu', gm.mu(state, :), 'Sigma', gm.Sigma(:,:,state), 'ComponentProportion', 1);
        gm_single{state}=fitgmdist(backHI{state}, 1, "Start", S_single, "CovarianceType", "full");
        Hmm.B(state,1) = HMM_B(gm_single{state});
    end
    %assigning HMM values
    Hmm.A = HMM_A(idx);

    %save HMMs and MOGs
    all_HMM{i} = Hmm;

    all_MOG{i} = gm_post;




end


% save part

if boSaveHmm 
    folderName = '..\dataNew\HMMandMOG\DATASET__PLACEHOLDER';
    fileName = "HMMandMOG";
    
    if not(exist(folderName, "dir"))
        mkdir(folderName);
    end

    iteration = 0;
    fileName = fullfile(folderName, sprintf('HMMandMOG%s_%02d.mat', num2str(targets), iteration));
        
    % Increment iteration if file already exists
    while exist(fileName, 'file')
        iteration = iteration + 1;
        fileName = fullfile(folderName, sprintf('HMMandMOG%s_%02d.mat', num2str(targets), iteration));
    end
    
    save(fileName, "all_HMM", "all_MOG")
end