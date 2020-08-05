
%script_mv_port;  %perform data retrieve and set up return matrix
function [AssetWeights]=constructPortfolioPCA(returns, targetRisk)

wb=waitbar(0, "");
waitbar(0,wb, "Performing PCA on the dataset");

[~, numAct] = size(returns);

numComponents = 10;
[factorLoading,factorReturn,~,~,~,mu] = pca(returns, 'NumComponents', numComponents);

covFactor = cov(factorReturn);

reconstructedReturn = factorReturn*factorLoading' + mu;
unexplainedReturn = returns - reconstructedReturn;

unexplainedCovar = diag(cov(unexplainedReturn));
D = diag(unexplainedCovar);

vRisk = targetRisk*targetRisk; 

meanStockRetn = mean(returns);

optimProb = optimproblem('Description','PCA','ObjectiveSense','max');
wgtAt = optimvar('asset_weight', numAct, 1, 'Type', 'continuous', 'LowerBound', 0, 'UpperBound', 1);
wtFt = optimvar('factor_weight', numComponents, 1, 'Type', 'continuous');

optimProb.Objective = sum(meanStockRetn'.*wgtAt);

optimProb.Constraints.asset_factor_weight = factorLoading'*wgtAt - wtFt == 0;
optimProb.Constraints.risk = wtFt'*covFactor*wtFt + wgtAt'*D*wgtAt <= vRisk;
optimProb.Constraints.budget = sum(wgtAt) == 1;

x0.asset_weight = ones(numAct, 1)/numAct;
x0.factor_weight = zeros(numComponents, 1);
opt = optimoptions("fmincon", "Algorithm","sqp", "Display", "off", ...
    'ConstraintTolerance', 1.0e-8, 'OptimalityTolerance', 1.0e-8, 'StepTolerance', 1.0e-8);
x = solve(optimProb,x0, "Options",opt);
AssetWeights = x.asset_weight;

close(wb);