%Description: class storing connection provider settings and properties
classdef ConnectionProperties
    properties (Constant)
        url_cookies = 'https://finance.yahoo.com/quote/'
        url_quotes  = 'https://query1.finance.yahoo.com/v7/finance/download/'
        user_agent  = 'Mozilla/5.0'
    end
end
