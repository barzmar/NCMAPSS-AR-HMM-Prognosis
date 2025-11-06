index = 1;
f = 40;
c = 1;


A(1, :) = AVectors(index,1,:);
% B(1, :) = BVectors(index,1,:);
model = idpoly(A, BVectors{index}, 1, 1, 1);

in = [ppCruiseData(2).flights(f).cruises(c).Dad(7, :)' ppCruiseData(2).flights(f).cruises(c).Dad(6, :)'];
out = ppCruiseData(2).flights(f).cruises(c).Dad(20, :)';

signal = iddata(out, in, 1);

ny = ones(1, 1, "double") .* 2;
nu = ones(1, 2, "double") .* 2;
nk = ones(1, 2, "double") * 0;

[lambda, R] = arxRegul(signal, [ny nu nk]);

opt = arxOptions;

opt.Regularization.Lambda = lambda;
opt.Regularization.R = R;

model = arx(signal, [ny nu nk], opt)


figure;
compare(signal, model);