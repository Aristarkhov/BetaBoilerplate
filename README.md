# BetaBoilerplate

Example of smart beta modeling and portfolio optimization using PCA in MATLAB.  
Real-time data retrieving from Yahoo.Finance through REST API

## Running

1. Execute `git clone https://github.com/Aristarkhov/BetaBoilerplate.git`
inside desired directory

2. Execute `main.m` script:

```>> main```

![Possible result screen](https://github.com/Aristarkhov/BetaBoilerplate/blob/master/result.png?raw=true)

## Description

Using S&P500 index as a benchmark, `main.m` script loads symbol data from World Wide Web for given dates and symbols contained in file `symbols.mat`, then outputs correlation   matrix and performs mean-variance Portfolio optimization, outputting   risk-return map and efficient frontier.<br>  
Then Principal Component Analysis is performed to find the optimal   portfolio at a given risk level by explicitly setting and solving  corresponding optimization problem.   

## Limitations

Number of symbols being analysed is a smaller subset of S&P500 index constituents due to the fact that Yahoo.Finance had removed their public API for dataset retrieving, thus blocking any repeated connections for those who do not have API key.
