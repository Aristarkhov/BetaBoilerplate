%fetching financial data from the internet

src_fred = fred('https://research.stlouisfed.org/fred2/');

sp500 = fetch(src_fred, 'SP500');

close(src_fred);

