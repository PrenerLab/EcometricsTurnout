<div class="container-fluid main-container">

<div id="header" class="fluid-row">

<div class="btn-group pull-right">

<span>Code</span> <span class="caret"></span>

  - [Show All Code](#)

  - [Hide All Code](#)

  - 
  - [Download Rmd](#)

</div>

# Models 2017 Election

</div>

<div id="introduction" class="section level2">

## Introduction

This notebook is one of a multiple part series for analyzing csb and
voter data. This notebook accomplishes the building of the OLS model
using the python library `pysal` and the R package `reticulate` to be
able to execute python code in an R notebook.

This notebook fits models using 2017 election data.

</div>

<div id="dependencies" class="section level2">

## Dependencies

<div id="software-versions" class="section level3">

### Software Versions

R Version 3.5.2 RStudio Version 1.2.1330 Python Version 3.7.3 Pysal
Version 2.0.0 Numpy Version 1.15.3

These are the R packages we need:

``` r
library(reticulate) # python interface
```

    There were 14 warnings (use warnings() to see them)

And these are the Python libraries we need:

``` python
import os
import pysal as ps
import numpy as np
```

</div>

</div>

<div id="building-the-ols-models" class="section level2">

## Building the OLS Models

<div id="create-spatial-weights" class="section level3">

### Create Spatial Weights

We’ll use queens weights.

``` python
file = ps.lib.io.open("../data/Spatial/grid/full_17.shp")
w = ps.lib.weights.Queen(file)
```

</div>

<div id="set-variables-for-models" class="section level3">

### Set Variables for Models

We’re going to create 4 models, all with the Density of CSB calls (Calls
per 1000 people) as the dependent variable.

1.  Main Effect (Voter Turnout)
2.  Full Model (Voter Turnout, Population, Non-White Population,
    Poverty, Highschool Diploma)

<!-- end list -->

``` python
# load data
data = ps.lib.io.open("../data/Spatial/grid/full_17.dbf", 'r')

# set Y var
y_name = "csb_dns"

# create Y array, transpose
y = np.array([data.by_col(y_name)]).T 

# define independent vars for each model
me_ind = ["turnout"]
fm_ind = ["turnout", "tot_pop", "nonwht", "pvrty", "hs"]

# create arrays for each model
me = np.array([data.by_col(var) for var in me_ind]).T
fm = np.array([data.by_col(var) for var in fm_ind]).T
```

</div>

</div>

<div id="create-ols-models" class="section level2">

## Create OLS Models

<div id="main-effect" class="section level3">

### Main Effect

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            : full_17.shp
    Weights matrix      :      queens
    Dependent Variable  :     csb_dns                Number of Observations:         206
    Mean dependent var  :    184.9663                Number of Variables   :           2
    S.D. dependent var  :    139.1725                Degrees of Freedom    :         204
    R-squared           :      0.1430
    Adjusted R-squared  :      0.1388
    Sum squared residual: 3402781.435                F-statistic           :     34.0438
    Sigma-square        :   16680.301                Prob(F-statistic)     :   2.091e-08
    S.E. of regression  :     129.152                Log likelihood        :   -1292.661
    Sigma-square ML     :   16518.356                Akaike info criterion :    2589.322
    S.E of regression ML:    128.5238                Schwarz criterion     :    2595.977
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     130.0522834      13.0211719       9.9877556       0.0000000
                 turnout       4.9466948       0.8478055       5.8347045       0.0000000
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            2.493
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2         878.709           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                1           3.160           0.0754
    Koenker-Bassett test              1           0.579           0.4466
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.2208         5.934           0.0000
    Lagrange Multiplier (lag)         1          26.331           0.0000
    Robust LM (lag)                   1           2.065           0.1507
    Lagrange Multiplier (error)       1          31.968           0.0000
    Robust LM (error)                 1           7.702           0.0055
    Lagrange Multiplier (SARMA)       2          34.033           0.0000
    
    ================================ END OF REPORT =====================================

We’ll fit a spatial error model based on the significant LM (error).

</div>

<div id="full-model" class="section level3">

### Full Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            : full_17.shp
    Weights matrix      :      queens
    Dependent Variable  :     csb_dns                Number of Observations:         206
    Mean dependent var  :    184.9663                Number of Variables   :           6
    S.D. dependent var  :    139.1725                Degrees of Freedom    :         200
    R-squared           :      0.2716
    Adjusted R-squared  :      0.2534
    Sum squared residual: 2892359.928                F-statistic           :     14.9121
    Sigma-square        :   14461.800                Prob(F-statistic)     :   1.957e-12
    S.E. of regression  :     120.257                Log likelihood        :   -1275.921
    Sigma-square ML     :   14040.582                Akaike info criterion :    2563.842
    S.E of regression ML:    118.4930                Schwarz criterion     :    2583.810
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     -11.1685982      36.5389956      -0.3056624       0.7601796
                 turnout       6.6307596       0.8614949       7.6968064       0.0000000
                 tot_pop      -0.0005968       0.0074780      -0.0798086       0.9364693
                  nonwht       1.3448328       0.4611069       2.9165311       0.0039438
                   pvrty       0.1105743       1.1005447       0.1004724       0.9200700
                      hs       1.4537246       1.2176880       1.1938400       0.2339547
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER           12.217
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2         998.547           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                5         105.100           0.0000
    Koenker-Bassett test              5          17.752           0.0033
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.0756         2.558           0.0105
    Lagrange Multiplier (lag)         1          17.514           0.0000
    Robust LM (lag)                   1          18.478           0.0000
    Lagrange Multiplier (error)       1           3.749           0.0529
    Robust LM (error)                 1           4.713           0.0299
    Lagrange Multiplier (SARMA)       2          22.227           0.0000
    
    ================================ END OF REPORT =====================================

We’ll fit a lag model based on the significant lag value.

</div>

</div>

<div id="create-spatial-models" class="section level2">

## Create Spatial Models

<div id="main-effect-1" class="section level3">

### Main Effect

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: SPATIALLY WEIGHTED LEAST SQUARES
    ---------------------------------------------------
    Data set            : full_17.shp
    Weights matrix      :      queens
    Dependent Variable  :     csb_dns                Number of Observations:         206
    Mean dependent var  :    184.9663                Number of Variables   :           2
    S.D. dependent var  :    139.1725                Degrees of Freedom    :         204
    Pseudo R-squared    :      0.1430
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     z-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT      43.6001126      28.7830599       1.5147838       0.1298272
                 turnout       5.9832510       0.8301162       7.2077273       0.0000000
                  lambda       0.1460622    
    ------------------------------------------------------------------------------------
    ================================ END OF REPORT =====================================

</div>

<div id="full-model-1" class="section level3">

### Full Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: SPATIAL TWO STAGE LEAST SQUARES
    --------------------------------------------------
    Data set            : full_17.shp
    Weights matrix      :      queens
    Dependent Variable  :     csb_dns                Number of Observations:         206
    Mean dependent var  :    184.9663                Number of Variables   :           7
    S.D. dependent var  :    139.1725                Degrees of Freedom    :         199
    Pseudo R-squared    :      0.3464
    Spatial Pseudo R-squared:  0.3127
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     z-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     -29.8858986      34.3563369      -0.8698802       0.3843659
                 turnout       6.0127342       0.8155525       7.3725897       0.0000000
                 tot_pop      -0.0187805       0.0080363      -2.3369549       0.0194415
                  nonwht       0.7110981       0.4522723       1.5722788       0.1158859
                   pvrty      -0.3945966       1.0333523      -0.3818606       0.7025647
                      hs       1.3994927       1.1368392       1.2310385       0.2183085
               W_csb_dns       0.0875747       0.0191716       4.5679492       0.0000049
    ------------------------------------------------------------------------------------
    Instrumented: W_csb_dns
    Instruments: W_hs, W_nonwht, W_pvrty, W_tot_pop, W_turnout
    ================================ END OF REPORT =====================================

</div>

</div>

</div>
