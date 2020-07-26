%fetching financial data from the internet

function [data]=fetch_data(ticker, startdate, enddate, freq)
    
    uri_to_get_cookies = matlab.net.URI(['https://finance.yahoo.com/quote/', upper(ticker), '/history'],...
        'period1',  num2str(uint64(posixtime(datetime()-1)), '%.10g'),...
        'period2',  num2str(uint64(posixtime(datetime())), '%.10g'),...
        'interval', freq,...
        'filter', 'history',...
        'frequency', freq,...
        'guccounter', 1);
    
    options = matlab.net.http.HTTPOptions('ConnectTimeout', 20, 'DecodeResponse', 1, 'Authenticate', 0, 'ConvertResponse', 0);
    requestObj = matlab.net.http.RequestMessage();
    [response, ~, ~]  = requestObj.send(uri_to_get_cookies, options);
    
    setCookieFields = response.getFields('Set-Cookie');
    setContentFields = response.getFields('Content-Type');
    if ~isempty(setCookieFields)
       cookieInfos = setCookieFields.convert(uri_to_get_cookies);
       contentInfos = setContentFields.convert();
       requestObj = requestObj.addFields(matlab.net.http.field.CookieField([cookieInfos.Cookie]));
       requestObj = requestObj.addFields(matlab.net.http.field.ContentTypeField(contentInfos));
       requestObj = requestObj.addFields(matlab.net.http.field.GenericField('User-Agent', 'Mozilla/5.0'));
    else
        disp('Error retrieving data. Please check ticker symbol and/or connection parameters.');
        data = [];
        return;
    end
    
    uri = matlab.net.URI(['https://query1.finance.yahoo.com/v7/finance/download/', upper(ticker) ],...
    'period1',  num2str(uint64(posixtime(datetime(startdate))), '%.10g'),...
    'period2',  num2str(uint64(posixtime(datetime(enddate))), '%.10g'),...
    'interval', freq,...
    'events',   'history',...
    'literal');  
    
    [response, ~, ~]  = requestObj.send(uri, options);
    if(~strcmp(response.StatusCode, 'OK'))
        disp('Response was not with OK status :(');
        data = [];
    else
        data = data_string_to_table(response.Body.Data);
    end
end

%Convert data string to table
%Input: dataString -- response string from provider, 
%       first column is considered as date
function [dtable]=data_string_to_table(dataString)
    %splitting response string by lines and comma-separators
    dataString=splitlines(dataString);
    dataString=split(dataString, ',');
    
    %extracting variable names
    variableNames=dataString(1,:);
    dataString(1,:)=[];
    dtable=table(dataString(:,1), dataString(:,2), dataString(:,3), dataString(:,4),...
        dataString(:,5), dataString(:,6), dataString(:,7), 'VariableNames', variableNames);
    
    %Converting columns from strings to datetime and numbers accordingly
    %Convert first column (Date) to datetime
    dtable.(variableNames(1)) = datetime(dtable.(variableNames(1)));
    
    %Convert other columns to numbers
    for i=2:7
        dtable.(variableNames(i)) = str2double(dtable.(variableNames(i)));
    end
    
end








