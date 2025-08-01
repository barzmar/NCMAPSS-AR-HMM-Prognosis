function [detrendAndDiffed, detrended, diffed] = detrendAndDiff(inData)
    detrended = detrend(inData);
    diffed = diff(inData);

    detrendAndDiffed = diff(detrended);
end