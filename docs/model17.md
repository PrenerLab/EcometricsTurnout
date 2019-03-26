# OLS Model 2017

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

    Warning messages:
    1: In res[i] <- withCallingHandlers(if (tangle) process_tangle(group) else process_group(group),  :
      number of items to replace is not a multiple of replacement length
    2: In res[i] <- withCallingHandlers(if (tangle) process_tangle(group) else process_group(group),  :
      number of items to replace is not a multiple of replacement length
    3: In res[i] <- withCallingHandlers(if (tangle) process_tangle(group) else process_group(group),  :
      number of items to replace is not a multiple of replacement length
    4: In res[i] <- withCallingHandlers(if (tangle) process_tangle(group) else process_group(group),  :
      number of items to replace is not a multiple of replacement length
    5: In res[i] <- withCallingHandlers(if (tangle) process_tangle(group) else process_group(group),  :
      number of items to replace is not a multiple of replacement length
    6: In res[i] <- withCallingHandlers(if (tangle) process_tangle(group) else process_group(group),  :
      number of items to replace is not a multiple of replacement length
    7: In res[i] <- withCallingHandlers(if (tangle) process_tangle(group) else process_group(group),  :
      number of items to replace is not a multiple of replacement length

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

We’re going to create 4 models, all with the number of CSB calls as the
dependent variable.

1.  Main Effect (Voter Turnout)
2.  Population Model (Population)
3.  Combined Model (Voter Turnout and Population)
4.  Full Model (Voter Turnout, Population, Non-White Population,
    Poverty, Highschool Diploma, Bachelors Degree)

<!-- end list -->

``` python
# load data
data = ps.lib.io.open("../data/Spatial/grid/full_17.dbf", 'r')

# set Y var
y_name = "csb"

# create Y array, transpose
y = np.array([data.by_col(y_name)]).T 

# define independent vars for each model
me_ind = ["turnout"]
pm_ind = ["tot_pop"]
cm_ind = ["turnout", "tot_pop"]
fm_ind = ["turnout", "tot_pop", "nonwht", "pvrty", "hs", "ba"]

# create arrays for each model
me = np.array([data.by_col(var) for var in me_ind]).T
pm = np.array([data.by_col(var) for var in pm_ind]).T
cm = np.array([data.by_col(var) for var in cm_ind]).T
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
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    279.6359                Number of Variables   :           2
    S.D. dependent var  :    239.5019                Degrees of Freedom    :         204
    R-squared           :      0.0514
    Adjusted R-squared  :      0.0467
    Sum squared residual:11154881.541                F-statistic           :     11.0487
    Sigma-square        :   54680.792                Prob(F-statistic)     :    0.001052
    S.E. of regression  :     233.839                Log likelihood        :   -1414.951
    Sigma-square ML     :   54149.910                Akaike info criterion :    2833.902
    S.E of regression ML:    232.7013                Schwarz criterion     :    2840.558
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     222.9943129      23.5757506       9.4586305       0.0000000
                 turnout       5.1023174       1.5350118       3.3239598       0.0010520
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            2.493
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          13.118           0.0014
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                1          25.900           0.0000
    Koenker-Bassett test              1          22.793           0.0000
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.4196        11.139           0.0000
    Lagrange Multiplier (lag)         1         208.988           0.0000
    Robust LM (lag)                   1          96.017           0.0000
    Lagrange Multiplier (error)       1         115.502           0.0000
    Robust LM (error)                 1           2.531           0.1117
    Lagrange Multiplier (SARMA)       2         211.519           0.0000
    
    ================================ END OF REPORT =====================================

</div>

<div id="population-model" class="section level3">

### Population Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            : full_17.shp
    Weights matrix      :      queens
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    279.6359                Number of Variables   :           2
    S.D. dependent var  :    239.5019                Degrees of Freedom    :         204
    R-squared           :      0.7167
    Adjusted R-squared  :      0.7153
    Sum squared residual: 3331074.882                F-statistic           :    516.1408
    Sigma-square        :   16328.798                Prob(F-statistic)     :   8.786e-58
    S.E. of regression  :     127.784                Log likelihood        :   -1290.467
    Sigma-square ML     :   16170.266                Akaike info criterion :    2584.934
    S.E of regression ML:    127.1624                Schwarz criterion     :    2591.590
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT      21.6823021      14.4285988       1.5027310       0.1344548
                 tot_pop       0.1687647       0.0074284      22.7187320       0.0000000
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            2.896
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          46.968           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                1           8.330           0.0039
    Koenker-Bassett test              1           4.617           0.0317
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.2801         7.582           0.0000
    Lagrange Multiplier (lag)         1          21.559           0.0000
    Robust LM (lag)                   1           0.052           0.8191
    Lagrange Multiplier (error)       1          51.455           0.0000
    Robust LM (error)                 1          29.948           0.0000
    Lagrange Multiplier (SARMA)       2          51.507           0.0000
    
    ================================ END OF REPORT =====================================

</div>

<div id="combined-model" class="section level3">

### Combined Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            : full_17.shp
    Weights matrix      :      queens
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    279.6359                Number of Variables   :           3
    S.D. dependent var  :    239.5019                Degrees of Freedom    :         203
    R-squared           :      0.7210
    Adjusted R-squared  :      0.7183
    Sum squared residual: 3280479.495                F-statistic           :    262.3315
    Sigma-square        :   16159.998                Prob(F-statistic)     :   5.308e-57
    S.E. of regression  :     127.122                Log likelihood        :   -1288.891
    Sigma-square ML     :   15924.658                Akaike info criterion :    2583.781
    S.E of regression ML:    126.1929                Schwarz criterion     :    2593.765
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT       8.8848071      16.0730146       0.5527779       0.5810237
                 turnout       1.5044564       0.8502464       1.7694358       0.0783226
                 tot_pop       0.1662108       0.0075296      22.0743614       0.0000000
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            3.491
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          41.648           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                2          10.938           0.0042
    Koenker-Bassett test              2           6.263           0.0436
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.2927         7.954           0.0000
    Lagrange Multiplier (lag)         1          21.917           0.0000
    Robust LM (lag)                   1           0.001           0.9760
    Lagrange Multiplier (error)       1          56.185           0.0000
    Robust LM (error)                 1          34.269           0.0000
    Lagrange Multiplier (SARMA)       2          56.186           0.0000
    
    ================================ END OF REPORT =====================================

</div>

<div id="full-model" class="section level3">

### Full Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            : full_17.shp
    Weights matrix      :      queens
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    279.6359                Number of Variables   :           7
    S.D. dependent var  :    239.5019                Degrees of Freedom    :         199
    R-squared           :      0.7596
    Adjusted R-squared  :      0.7523
    Sum squared residual: 2826920.125                F-statistic           :    104.7955
    Sigma-square        :   14205.629                Prob(F-statistic)     :   7.503e-59
    S.E. of regression  :     119.187                Log likelihood        :   -1273.564
    Sigma-square ML     :   13722.913                Akaike info criterion :    2561.128
    S.E of regression ML:    117.1448                Schwarz criterion     :    2584.423
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     -30.5383759     129.8057912      -0.2352620       0.8142473
                 turnout       2.7122301       0.8538964       3.1762988       0.0017292
                 tot_pop       0.1744340       0.0075815      23.0078292       0.0000000
                  nonwht       1.4513684       0.4870045       2.9801951       0.0032396
                   pvrty      -1.5107810       1.3438396      -1.1242272       0.2622709
                      hs       0.1567501       2.0479216       0.0765410       0.9390656
                      ba      -2.3339201       2.9507728      -0.7909522       0.4299136
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER           42.624
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          39.889           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                6          36.315           0.0000
    Koenker-Bassett test              6          20.429           0.0023
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.1572         4.858           0.0000
    Lagrange Multiplier (lag)         1          12.212           0.0005
    Robust LM (lag)                   1           1.904           0.1676
    Lagrange Multiplier (error)       1          16.217           0.0001
    Robust LM (error)                 1           5.909           0.0151
    Lagrange Multiplier (SARMA)       2          18.122           0.0001
    
    ================================ END OF REPORT =====================================

</div>

</div>

</div>
