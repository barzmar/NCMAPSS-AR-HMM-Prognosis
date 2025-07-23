function [indexStart, indexEnd] = findIntervalsSameValue(data, table, row)

    distinctValues = unique(data(table).Value(row, :));
    numDistinct = length(distinctValues);
    dataLength = length(data(table).Value(row,:));
    
    j=1;
    temp = 0;
    count = 1;
    fin = zeros([1, numDistinct]);
    start = zeros([1, numDistinct]);
    samples = zeros([1, numDistinct]);
    for i = distinctValues   
        while ((data(table).Value(row,j) == i) && (i ~= distinctValues(numDistinct)))
            j = j +1;
        end
        if count == 1
            temp = 1;
        else
            temp = fin(count-1)+1;
        end
        start(count) = temp; 

        if i == distinctValues(numDistinct)
            fin(count) = dataLength;
        else
            fin(count) = j-1; % Store the count of occurrences for the current distinct value
        end
        
        count = count +1;
    end
    indexStart = start;
    indexEnd = fin;
end