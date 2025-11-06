% ONLINE PREDICTION

infinity = 10000;


for j = 1 : size(HMM,2)
    hmm = HMM{j};
    A{j, 1} = hmm.A;
    for o = 2 : infinity
        A{j, o} = A{j, o-1} * hmm.A;
    end
end


for i = 1 : length(HealthIndex)
    now =  HealthIndex(i);  %current value
    
    
end