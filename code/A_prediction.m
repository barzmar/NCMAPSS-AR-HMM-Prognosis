function A_0 = A_prediction(A, infinity)
    %%creeating transition prediction matrix

    A_0 = cell(infinity,1);

    A_0{1} = A; %initialize first cell for next step prediction

    for t = 2 : infinity
        A_0{t} = A_0{t-1} * A;
    end


end