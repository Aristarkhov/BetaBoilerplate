%fetching financial data from the internet

function [data]=fetch_data
    C=ConnectionProperties;
    src_fred = fred(C.inet_addr);
    data = fetch(src_fred, 'SP500');
    close(src_fred);   
end




