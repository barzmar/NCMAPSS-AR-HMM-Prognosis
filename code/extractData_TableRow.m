function outStruct =  extractData_TableRow(data, tables) 
    
    [startDev, finDev] = findIntervalsSameValue(data, 1, 1);
    [startTest, finTest] = findIntervalsSameValue(data, 2, 1);
    numberDevUnits = length(startDev);
    NumberTestUnits = length(startTest);
    unit = struct.empty(numberDevUnits,0);
    indexDev = 0;
    indexTest = 0;
    indexName = 0;
    flag = false;
    flagTest = false;

    for l = tables
        indexName = l * 3;
        indexTest = indexName - 1;
        indexDev = indexName - 2;
        
        

        for k = 1:1:numberDevUnits 
            temp = data(indexDev).Value(:, startDev(k):finDev(k));
            tempName = data(indexName).Value(:);

            if not(flag)
                unit(k).Value = temp;
                unit(k).Name = tempName;
                
            else
                unit(k).Value = vertcat(unit(k).Value, temp); % Store the extracted data in the output structure
                unit(k).Name = vertcat(unit(k).Name, tempName);
            end
        end
        flag = true;


        for k = 1:1:NumberTestUnits
            temp = data(indexTest).Value(:, startTest(k):finTest(k));

            if not(flagTest)
                unit(k+numberDevUnits).Value = temp;
                unit(k+numberDevUnits).Name = tempName;
            else
                unit(k+numberDevUnits).Value = vertcat(unit(k+numberDevUnits).Value, temp); % Store the extracted data in the output structure
                unit(k+numberDevUnits).Name = vertcat(unit(k+numberDevUnits).Name, tempName);
            end
        end

        flagTest = true;
        
    end
    outStruct = unit;
end
