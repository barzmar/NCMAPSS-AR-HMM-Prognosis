figure;
y = idx;
h = gscatter(HI(:,1),HI(:,2),y);
hold on
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_post,[x0 y0]),x,y);
g = gca;
fcontour(gmPDF,[g.XLim g.YLim], "MeshDensity", 40, "LevelStep", 6)
title('{\bf Scatter Plot and Fitted Gaussian Mixture Contours}')
legend(h,'Model 0','Model1', 'Model2')
hold off