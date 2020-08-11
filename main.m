load symbols.mat
startDate = '30-Jul-2016';
endDate = '4-Feb-2019';


data=fetch_data_mapped_by_tickers(symbols, startDate, endDate);
timeTableSeries=extractTimeSeriesFromDataMap(data,'Close');

%====calculate moments====

returns = tick2ret(timeTableSeries.Variables);
retMean = mean(returns);
retCov  = cov(returns);
retRisk = std(returns);
retCorr=corrcoef(returns);


%====draw correlation matrix heatmap====
figure('Name', 'Symbols correlation matrix'); 
movegui('west');
heatmap(retCorr, 'Colormap', parula(5), 'ColorbarVisible' ,'on');
ax=gca; ax.XData=timeTableSeries.Properties.VariableNames; 
ax.YData=timeTableSeries.Properties.VariableNames;


%====fetch bench market data (SP500 market index)====
bench="^GSPC";
benchData=fetch_data_mapped_by_tickers(bench, startDate, endDate);
benchTt=extractTimeSeriesFromDataMap(benchData, 'Close');
benchReturns = tick2ret(benchTt.Variables);
benchRetMean = mean(benchReturns);
benchRetRisk = std(benchReturns);

%====draw risk-return map====
fig2=figure('Name', 'Risk-return map');
scatter(retRisk, retMean, 6, 'm', 'Filled');
hold on;
scatter(benchRetRisk, benchRetMean, 10, 'g', 'Filled');
movegui('east');

figure(fig2);
for k = 1:length(timeTableSeries.Properties.VariableNames)
    text(retRisk(k) + 0.0002, retMean(k), timeTableSeries.Properties.VariableNames(k), 'FontSize', 8);
end
text(benchRetRisk + 0.0002, benchRetMean, 'Benchmark', 'Fontsize', 8);
xlabel('Risk as a standard deviation of return of asset');
ylabel('Mean of return by time series');
grid on;



%====estimate efficient portfolios====
p = Portfolio('AssetMean', retMean, 'AssetCovar', retCov, 'AssetList',...
              timeTableSeries.Properties.VariableNames);
p = setDefaultConstraints(p);
frontwts = estimateFrontier(p, 20);

[estimRisk, estimReturn] = estimatePortMoments(p, frontwts);
plot(estimRisk,estimReturn,'bo-');


%====perform PCA and then construct portfolio with a target risk equal
%to the one of benchmark====
Weights = constructPortfolioPCA(returns, benchRetRisk);
[pq, pr] = estimatePortMoments(p, Weights);
figure(fig2);
hold on;
scatter(pq, pr, 20, 'go', 'Filled');
text(pq + 0.0003, pr, 'PCA ', 'Fontsize', 9);



