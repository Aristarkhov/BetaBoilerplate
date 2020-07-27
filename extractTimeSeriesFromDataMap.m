%Convert data map to timeseries collection object using specified parameter
%Input:  dataMap   - data map, where ticker symbol is the key and ticker
%                    quotes table is the value
%        priceType - type of price taken into account ("Open", "High", "Low", "Close", "Adj Close")    
function [timeSeriesCollection] = extractTimeSeriesFromDataMap(dataMap, priceType)
    arguments
        dataMap   containers.Map
        priceType string
    end
    
    timeSeriesCollection=tscollection;
    
    for key = dataMap.keys
        ckey=char(key);
        
        ts=timeseries(dataMap(ckey).(priceType), datestr(dataMap(ckey).Date), 'Name', ckey);
        
        if (isempty(timeSeriesCollection))    
            timeSeriesCollection=tscollection(ts);
        else
            timeSeriesCollection=addts(timeSeriesCollection, ts);
        end
    end
end