# BetaBoilerplate

Example of smart beta modeling and portfolio optimization using PCA in MATLAB.  
Real-time data retrieving from Yahoo.Finance through REST API

## Running

1. Execute `git clone https://github.com/Aristarkhov/BetaBoilerplate.git`
inside desired directory

2. Execute `main.m` script

## Description

`main.m` script loads symbol data from World Wide Web for given dates and symbols contained in file `symbols.mat`, then outputs correlation   matrix and performs mean-variance Portfolio optimization, outputting   risk-return map and efficient frontier for downloaded asset data and   timeframe.<br>  
Then Principal Component Analysis is performed to find the optimal   portfolio at a given risk level by explicitly setting and solving the   optimization problem.  