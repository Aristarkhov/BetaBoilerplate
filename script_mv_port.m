load symbols.mat
date1 = '30-Jul-2017';
date2 = '4-Oct-2019';




data=fetch_data_mapped_by_tickers(symbols, date1, date2);
TimeTableSeries=extractTimeSeriesFromDataMap(data,'Close');
%====calculate moments=====

returns = tick2ret(TimeTableSeries.Variables);
retMean = mean(returns);
retCov  = cov(returns);
retRisk = std(returns);
retCorr=corrcoef(returns);


%====draw correlation matrix heatmap====
figure('Name', 'Symbols correlation matrix'); 
movegui('west');
heatmap(retCorr, 'Colormap', parula(5), 'ColorbarVisible' ,'on');
ax=gca; ax.XData=TimeTableSeries.Properties.VariableNames; 
ax.YData=TimeTableSeries.Properties.VariableNames;


%====fetch bench market data (SP500 market index)=====
bench="^GSPC";
benchData=fetch_data_mapped_by_tickers(bench, date1, date2);
benchTt=extractTimeSeriesFromDataMap(benchData, 'Close');
benchReturns = tick2ret(benchTt.Variables);
benchRetMean = mean(benchReturns);
benchRetRisk = std(benchReturns);

%=======draw risk-return map=====
fig2=figure('Name', 'Risk-return map');
scatter(retRisk, retMean, 6, 'm', 'Filled');
hold on;
scatter(benchRetRisk, benchRetMean, 6, 'g', 'Filled');
movegui('east');

figure(fig2);
for k = 1:length(TimeTableSeries.Properties.VariableNames)
    text(retRisk(k) + 0.0002, retMean(k), TimeTableSeries.Properties.VariableNames(k), 'FontSize', 8);
end
text(benchRetRisk + 0.0002, benchRetMean, 'Benchmark', 'Fontsize', 8);
hold off;
xlabel('Risk as a standard deviation of return of asset');
ylabel('Mean of return by time series');
grid on;





