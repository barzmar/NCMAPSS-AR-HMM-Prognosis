function outStruct = extractData(k, data) 
    distinctValues = unique(data.Datasets(1).Value(1, :));
    numDistinct = length(distinctValues);
    dataLength = length(data.Datasets(1,1).Value(1,:));

unit = struct.empty();




j=2;
count = 1;
fin = zeros([1, numDistinct]);
samples = zeros([1, numDistinct]);
for i= distinctValues
    while ((data.Datasets(1,1).Value(1,j) == i) && (i ~= distinctValues(numDistinct)))
        j = j +1;
    end
    if i == 1
        start = 1;
    else
        start = fin(count-1)+1;
    end
    
    if i == distinctValues(numDistinct)
        fin(i) = dataLength;
    else
        fin(i) = j-1; % Store the count of occurrences for the current distinct value
    end
    
    unit(count).Value = data.Datasets(1).Value(:,start:fin(count));
    samples(i) = count;
    
    count = count +1;
end



