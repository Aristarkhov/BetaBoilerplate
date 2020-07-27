
function [dataMap]=fetch_data_mapped_by_tickers(tickersList, startDate, endDate)
    dataMap=containers.Map;
   
    for t=tickersList
        ticker=char(t);
        dataMap(ticker) = fetch_data(ticker, startDate, endDate, '1d');
    end    
end


