%Convert data map to timeseries collection object using specified type of quote
%Input:  dataMap   - data map, where ticker symbol is the key and ticker
%                    quotes table is the value
%        priceType - type of price taken into account ("Open", "High", "Low", "Close", "Adj Close")    
function [timeTable] = extractTimeSeriesFromDataMap(dataMap, priceType)
    arguments
        dataMap   containers.Map
        priceType string
    end
    
    timeTable=timetable;
    
    for key = dataMap.keys
        ckey=char(key);
        
        if (isempty(timeTable))
            timeTable = timetable(dataMap(ckey).Date);
        end
        
        timeTable = addvars(timeTable, ...
                            dataMap(ckey).(priceType), ...
                            'NewVariableNames', ckey);        
    end
end
