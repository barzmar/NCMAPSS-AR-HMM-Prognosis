function matComb = my_combinationGenerator(numberVariables)
varBool = logical([0 1]);
cell_varBool = cell(1, numberVariables);
for i = 1 : numberVariables
    cell_varBool(i) = {varBool};
end
tableComb = combinations(cell_varBool{:});

matComb = table2array(tableComb);
end