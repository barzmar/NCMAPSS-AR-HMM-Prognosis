function m = backWindowMean(y, w)

    for i = w+1 : length(y)
        temp = y(i-w);
        m(i) = (y(i)-temp)/w;
    end
    % plot(m)

end