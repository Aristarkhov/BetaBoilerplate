load symbols.mat
date1 = '30-Jul-2015';
date2 = '4-Oct-2019';

data=fetch_data_mapped_by_tickers(symbols, date1, date2);
tt=extractTimeSeriesFromDataMap(data,'Close');

%====

returns = tick2ret(tt.Variables);
retMean = mean(returns);
retCov  = cov(returns);

p = Portfolio('AssetMean', retMean, 'AssetCovar', retCov, 'AssetList', tt.Properties.VariableNames);
p = setDefaultConstraints(p);

frt = estimateFrontier(p, 7);

retCorr=corrcoef(returns);
figure('Name', 'Symbols correlation matrix'), heatmap(retCorr, 'Colormap', parula(5), 'ColorbarVisible' ,'on');
ax=gca; ax.XData=tt.Properties.VariableNames; ax.YData=tt.Properties.VariableNames;


