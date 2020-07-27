
function [dataMap]=fetch_data_mapped_by_tickers(tickersList, startDate, endDate)
    dataMap=containers.Map;
   
    w=waitbar(0, "Fetching aggregate data from the web, please wait");
    progress=0;
    [~, sz] = size(tickersList);
    
    for t=tickersList
        ticker=char(t);
        dataMap(ticker) = fetch_data(ticker, startDate, endDate, '1d');
        
        progress=progress+1;
        waitbar(progress/sz);
        
    end 
    close(w);
end


