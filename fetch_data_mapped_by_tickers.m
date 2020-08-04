
function [dataMap]=fetch_data_mapped_by_tickers(tickersList, startDate, endDate)
    dataMap=containers.Map;
   
    w=waitbar(0, "", 'Name' , 'Fetching aggregate data, please wait');
    progress=0;
    [~, sz] = size(tickersList);
    
    for t=tickersList
        ticker=char(t);
        
        waitbar(progress/sz, w, "Fetching data for symbol: " + t);
        dataMap(ticker) = fetch_data(ticker, startDate, endDate, '1d');
        
        progress=progress+1;
        
    end 
    close(w);
end


