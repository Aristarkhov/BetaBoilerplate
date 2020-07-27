load symbols.mat
date1 = '30-Jul-2015';
date2 = '4-Oct-2016';

data=fetch_data_mapped_by_tickers(symbols, date1, date2);
tt=extractTimeSeriesFromDataMap(data,'Close');

%====

returns = tick2ret(tt.Variables);
retMean = mean(returns);
retCov  = cov(returns);

p = Portfolio('AssetMean', retMean, 'AssetCovar', retCov, 'AssetList', symbols);
p = setDefaultConstraints(p);

frt = estimateFrontier(p, 7);
