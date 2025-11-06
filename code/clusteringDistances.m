for i = 1 : length(total_frmse)
    
    HI = frmse{i};

    Mu = [0.08; 0.2; 0.4];
    Sigma(:,:,1) = 0.1;
    Sigma(:,:,2) = 0.1;
    Sigma(:,:,3) = 0.1;
    PComponents = [0.5,0.25,0.25];
    S = struct('mu', Mu, 'Sigma', Sigma, 'ComponentProportion', PComponents);
    
    gm = fitgmdist(HI, 3, 'Start', S);
    
    idx = cluster(gm, HI);
    
    figure;
    hold on;
    plot(idx, 'LineStyle','none', 'Marker','o');

    idx = modeFilter(idx, 30);
    plot(idx,'LineStyle','none', 'Marker','x')

end