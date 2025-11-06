function Hmm = HMM_training(gm, idx)

    A = HMM_A(numLabels,idx);
    
    B = HMM_B(gm,A);

    Hmm.A = A;
    Hmm.B = B; 
end