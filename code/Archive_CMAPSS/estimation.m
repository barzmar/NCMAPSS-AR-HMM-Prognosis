% p0 = 100*rand(1,5);
% model = idpoly(p0);
t50ConcatData =  array_unitData{1}.T50(1:50,1);
for i= 2 : maxUnit
    t50ConcatData = vertcat(t50ConcatData, array_unitData{i}.T50(1:50,1));
end


model_ar = ar(t50ConcatData, 10, 'ls');
