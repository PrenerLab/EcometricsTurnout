<div class="container-fluid main-container">

<div id="header" class="fluid-row">

<div class="btn-group pull-right">

<span>Code</span> <span class="caret"></span>

  - [Show All Code](#)

  - [Hide All Code](#)

  - 
  - [Download Rmd](#)

</div>

# OLS Model 2014

</div>

<div id="introduction" class="section level2">

## Introduction

This notebook is one of a multiple part series for analyzing csb and
voter data. This notebook accomplishes the building of the OLS model
using the python library `pysal` and the R package `reticulate` to be
able to execute python code in an R notebook.

This notebook fits models using 2014 election data.

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

    <pysal.lib.weights.contiguity.Queen object at 0x13471abe0>

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
data = ps.lib.io.open("../data/Spatial/grid/full_14.dbf", 'r')

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
    Data set            : full_14.shp
    Weights matrix      :      queens
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    203.1456                Number of Variables   :           2
    S.D. dependent var  :    180.8104                Degrees of Freedom    :         204
    R-squared           :      0.0993
    Adjusted R-squared  :      0.0948
    Sum squared residual: 6036741.746                F-statistic           :     22.4791
    Sigma-square        :   29591.871                Prob(F-statistic)     :   3.983e-06
    S.E. of regression  :     172.023                Log likelihood        :   -1351.708
    Sigma-square ML     :   29304.572                Akaike info criterion :    2707.415
    S.E of regression ML:    171.1858                Schwarz criterion     :    2714.071
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     134.3890306      18.8136811       7.1431545       0.0000000
                 turnout       3.4908797       0.7362834       4.7412174       0.0000040
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            2.780
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2         125.324           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                1          43.414           0.0000
    Koenker-Bassett test              1          16.509           0.0000
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.3783        10.042           0.0000
    Lagrange Multiplier (lag)         1         177.201           0.0000
    Robust LM (lag)                   1          85.499           0.0000
    Lagrange Multiplier (error)       1          93.866           0.0000
    Robust LM (error)                 1           2.164           0.1413
    Lagrange Multiplier (SARMA)       2         179.365           0.0000
    
    ================================ END OF REPORT =====================================

</div>

<div id="population-model" class="section level3">

### Population Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            : full_14.shp
    Weights matrix      :      queens
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    203.1456                Number of Variables   :           2
    S.D. dependent var  :    180.8104                Degrees of Freedom    :         204
    R-squared           :      0.7244
    Adjusted R-squared  :      0.7231
    Sum squared residual: 1846887.052                F-statistic           :    536.2705
    Sigma-square        :    9053.368                Prob(F-statistic)     :   5.251e-59
    S.E. of regression  :      95.149                Log likelihood        :   -1229.718
    Sigma-square ML     :    8965.471                Akaike info criterion :    2463.437
    S.E of regression ML:     94.6862                Schwarz criterion     :    2470.092
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT       3.9768784      10.8590456       0.3662273       0.7145750
                 tot_pop       0.1287270       0.0055588      23.1575160       0.0000000
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            2.935
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          68.875           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                1          48.579           0.0000
    Koenker-Bassett test              1          23.949           0.0000
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.2536         6.885           0.0000
    Lagrange Multiplier (lag)         1          10.077           0.0015
    Robust LM (lag)                   1           1.045           0.3066
    Lagrange Multiplier (error)       1          42.194           0.0000
    Robust LM (error)                 1          33.162           0.0000
    Lagrange Multiplier (SARMA)       2          43.239           0.0000
    
    ================================ END OF REPORT =====================================

</div>

<div id="combined-model" class="section level3">

### Combined Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            : full_14.shp
    Weights matrix      :      queens
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    203.1456                Number of Variables   :           3
    S.D. dependent var  :    180.8104                Degrees of Freedom    :         203
    R-squared           :      0.7434
    Adjusted R-squared  :      0.7409
    Sum squared residual: 1719853.776                F-statistic           :    294.0261
    Sigma-square        :    8472.186                Prob(F-statistic)     :   1.104e-60
    S.E. of regression  :      92.044                Log likelihood        :   -1222.378
    Sigma-square ML     :    8348.805                Akaike info criterion :    2450.757
    S.E of regression ML:     91.3718                Schwarz criterion     :    2460.740
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     -19.7778219      12.1648171      -1.6258216       0.1055390
                 turnout       1.5610265       0.4031338       3.8722288       0.0001454
                 tot_pop       0.1242083       0.0055025      22.5729150       0.0000000
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            3.658
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          81.829           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                2          77.534           0.0000
    Koenker-Bassett test              2          34.723           0.0000
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.2473         6.750           0.0000
    Lagrange Multiplier (lag)         1           7.745           0.0054
    Robust LM (lag)                   1           1.749           0.1860
    Lagrange Multiplier (error)       1          40.130           0.0000
    Robust LM (error)                 1          34.134           0.0000
    Lagrange Multiplier (SARMA)       2          41.879           0.0000
    
    ================================ END OF REPORT =====================================

</div>

<div id="full-model" class="section level3">

### Full Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            : full_14.shp
    Weights matrix      :      queens
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    269.7524                Number of Variables   :           7
    S.D. dependent var  :    234.9043                Degrees of Freedom    :         199
    R-squared           :      0.8017
    Adjusted R-squared  :      0.7957
    Sum squared residual: 2243647.407                F-statistic           :    134.0513
    Sigma-square        :   11274.610                Prob(F-statistic)     :   4.082e-67
    S.E. of regression  :     106.182                Log likelihood        :   -1249.762
    Sigma-square ML     :   10891.492                Akaike info criterion :    2513.525
    S.E of regression ML:    104.3623                Schwarz criterion     :    2536.820
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     -95.7372304     100.3759138      -0.9537869       0.3413486
                 turnout       1.9905818       0.2963237       6.7175928       0.0000000
                 tot_pop       0.1608798       0.0067989      23.6625263       0.0000000
                  nonwht       1.2123260       0.4249573       2.8528186       0.0047912
                   pvrty      -0.8918964       1.0496971      -0.8496702       0.3965295
                      hs       0.4269430       1.7705648       0.2411338       0.8096997
                      ba      -1.7232138       2.1807416      -0.7901962       0.4303538
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER           37.737
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          31.662           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                6          61.186           0.0000
    Koenker-Bassett test              6          35.163           0.0000
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.2129         6.413           0.0000
    Lagrange Multiplier (lag)         1          11.338           0.0008
    Robust LM (lag)                   1           0.139           0.7093
    Lagrange Multiplier (error)       1          29.723           0.0000
    Robust LM (error)                 1          18.524           0.0000
    Lagrange Multiplier (SARMA)       2          29.862           0.0000
    
    ================================ END OF REPORT =====================================

</div>

</div>

<div id="rmd-source-code">

LS0tCnRpdGxlOiAiT0xTIE1vZGVsIDIwMTQiCm91dHB1dDogaHRtbF9ub3RlYm9vawotLS0KCiMjIEludHJvZHVjdGlvbgpUaGlzIG5vdGVib29rIGlzIG9uZSBvZiBhIG11bHRpcGxlIHBhcnQgc2VyaWVzIGZvciBhbmFseXppbmcgY3NiIGFuZCB2b3RlciBkYXRhLiBUaGlzIG5vdGVib29rIGFjY29tcGxpc2hlcyB0aGUgYnVpbGRpbmcgb2YgdGhlIE9MUyBtb2RlbCB1c2luZyB0aGUgcHl0aG9uIGxpYnJhcnkgYHB5c2FsYCBhbmQgdGhlIFIgcGFja2FnZSBgcmV0aWN1bGF0ZWAgdG8gYmUgYWJsZSB0byBleGVjdXRlIHB5dGhvbiBjb2RlIGluIGFuIFIgbm90ZWJvb2suCgpUaGlzIG5vdGVib29rIGZpdHMgbW9kZWxzIHVzaW5nIDIwMTQgZWxlY3Rpb24gZGF0YS4KCiMjIERlcGVuZGVuY2llcwoKIyMjIFNvZnR3YXJlIFZlcnNpb25zClIgVmVyc2lvbiAzLjUuMgpSU3R1ZGlvIFZlcnNpb24gMS4yLjEzMzAKUHl0aG9uIFZlcnNpb24gMy43LjMKUHlzYWwgVmVyc2lvbiAyLjAuMApOdW1weSBWZXJzaW9uIDEuMTUuMwoKVGhlc2UgYXJlIHRoZSBSIHBhY2thZ2VzIHdlIG5lZWQ6CmBgYHtyIGRlcGVuZGVuY2llc30KbGlicmFyeShyZXRpY3VsYXRlKSAjIHB5dGhvbiBpbnRlcmZhY2UKYGBgCgpBbmQgdGhlc2UgYXJlIHRoZSBQeXRob24gbGlicmFyaWVzIHdlIG5lZWQ6CgpgYGB7cHl0aG9uIGltcG9ydHN9CmltcG9ydCBvcwppbXBvcnQgcHlzYWwgYXMgcHMKaW1wb3J0IG51bXB5IGFzIG5wCmBgYAoKIyMgQnVpbGRpbmcgdGhlIE9MUyBNb2RlbHMKIyMjIENyZWF0ZSBTcGF0aWFsIFdlaWdodHMKV2UnbGwgdXNlIHF1ZWVucyB3ZWlnaHRzLgpgYGB7cHl0aG9ufQpmaWxlID0gcHMubGliLmlvLm9wZW4oIi4uL2RhdGEvU3BhdGlhbC9ncmlkL2Z1bGxfMTQuc2hwIikKdyA9IHBzLmxpYi53ZWlnaHRzLlF1ZWVuKGZpbGUpCgpgYGAKCiMjIyBTZXQgVmFyaWFibGVzIGZvciBNb2RlbHMKV2UncmUgZ29pbmcgdG8gY3JlYXRlIDQgbW9kZWxzLCBhbGwgd2l0aCB0aGUgbnVtYmVyIG9mIENTQiBjYWxscyBhcyB0aGUgZGVwZW5kZW50IHZhcmlhYmxlLgoKMS4gTWFpbiBFZmZlY3QgKFZvdGVyIFR1cm5vdXQpCjIuIFBvcHVsYXRpb24gTW9kZWwgKFBvcHVsYXRpb24pIAozLiBDb21iaW5lZCBNb2RlbCAoVm90ZXIgVHVybm91dCBhbmQgUG9wdWxhdGlvbikKNC4gRnVsbCBNb2RlbCAoVm90ZXIgVHVybm91dCwgUG9wdWxhdGlvbiwgTm9uLVdoaXRlIFBvcHVsYXRpb24sIFBvdmVydHksIEhpZ2hzY2hvb2wgRGlwbG9tYSwgQmFjaGVsb3JzIERlZ3JlZSkKCmBgYHtweXRob259CiMgbG9hZCBkYXRhCmRhdGEgPSBwcy5saWIuaW8ub3BlbigiLi4vZGF0YS9TcGF0aWFsL2dyaWQvZnVsbF8xNC5kYmYiLCAncicpCgojIHNldCBZIHZhcgp5X25hbWUgPSAiY3NiIgoKIyBjcmVhdGUgWSBhcnJheSwgdHJhbnNwb3NlCnkgPSBucC5hcnJheShbZGF0YS5ieV9jb2woeV9uYW1lKV0pLlQgCgojIGRlZmluZSBpbmRlcGVuZGVudCB2YXJzIGZvciBlYWNoIG1vZGVsCm1lX2luZCA9IFsidHVybm91dCJdCnBtX2luZCA9IFsidG90X3BvcCJdCmNtX2luZCA9IFsidHVybm91dCIsICJ0b3RfcG9wIl0KZm1faW5kID0gWyJ0dXJub3V0IiwgInRvdF9wb3AiLCAibm9ud2h0IiwgInB2cnR5IiwgImhzIiwgImJhIl0KCiMgY3JlYXRlIGFycmF5cyBmb3IgZWFjaCBtb2RlbAptZSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gbWVfaW5kXSkuVApwbSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gcG1faW5kXSkuVApjbSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gY21faW5kXSkuVApmbSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gZm1faW5kXSkuVAoKYGBgCgojIyBDcmVhdGUgT0xTIE1vZGVscwojIyMgTWFpbiBFZmZlY3QKYGBge3B5dGhvbn0Kb2xzX21lID0gcHMubW9kZWwuc3ByZWcuT0xTKHksIG1lLCB3PXcsIG5hbWVfeT15X25hbWUsIG5hbWVfeD1tZV9pbmQsIHNwYXRfZGlhZz1UcnVlLCBtb3Jhbj1UcnVlLApuYW1lX3c9J3F1ZWVucycsIG5hbWVfZHM9J2Z1bGxfMTQuc2hwJykKCnByaW50KG9sc19tZS5zdW1tYXJ5KQpgYGAKCiMjIyBQb3B1bGF0aW9uIE1vZGVsCmBgYHtweXRob259Cm9sc19wbSA9IHBzLm1vZGVsLnNwcmVnLk9MUyh5LCBwbSwgdz13LCBuYW1lX3k9eV9uYW1lLCBuYW1lX3g9cG1faW5kLCBzcGF0X2RpYWc9VHJ1ZSwgbW9yYW49VHJ1ZSwKbmFtZV93PSdxdWVlbnMnLCBuYW1lX2RzPSdmdWxsXzE0LnNocCcpCgpwcmludChvbHNfcG0uc3VtbWFyeSkKYGBgCgojIyMgQ29tYmluZWQgTW9kZWwKYGBge3B5dGhvbn0Kb2xzX2NtID0gcHMubW9kZWwuc3ByZWcuT0xTKHksIGNtLCB3PXcsIG5hbWVfeT15X25hbWUsIG5hbWVfeD1jbV9pbmQsIHNwYXRfZGlhZz1UcnVlLCBtb3Jhbj1UcnVlLApuYW1lX3c9J3F1ZWVucycsIG5hbWVfZHM9J2Z1bGxfMTQuc2hwJykKCnByaW50KG9sc19jbS5zdW1tYXJ5KQpgYGAKCiMjIyBGdWxsIE1vZGVsCmBgYHtweXRob259Cm9sc19mbSA9IHBzLm1vZGVsLnNwcmVnLk9MUyh5LCBmbSwgdz13LCBuYW1lX3k9eV9uYW1lLCBuYW1lX3g9Zm1faW5kLCBzcGF0X2RpYWc9VHJ1ZSwgbW9yYW49VHJ1ZSwKbmFtZV93PSdxdWVlbnMnLCBuYW1lX2RzPSdmdWxsXzE0LnNocCcpCgpwcmludChvbHNfZm0uc3VtbWFyeSkKYGBg

</div>

</div>
