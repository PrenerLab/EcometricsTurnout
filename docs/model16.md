<div class="container-fluid main-container">

<div id="header" class="fluid-row">

<div class="btn-group pull-right">

<span>Code</span> <span class="caret"></span>

  - [Show All Code](#)

  - [Hide All Code](#)

  - 
  - [Download Rmd](#)

</div>

# OLS Model 2016

</div>

<div id="introduction" class="section level2">

## Introduction

This notebook is one of a multiple part series for analyzing csb and
voter data. This notebook accomplishes the building of the OLS model
using the python library `pysal` and the R package `reticulate` to be
able to execute python code in an R notebook.

This notebook fits models using 2016 election data.

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

    There were 21 warnings (use warnings() to see them)

And these are the Python libraries we need:

    /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/pysal/model/spvcm/abstracts.py:10: UserWarning: The `dill` module is required to use the sqlite backend fully.
      from .sqlite import head_to_sql, start_sql

</div>

</div>

<div id="building-the-ols-models" class="section level2">

## Building the OLS Models

<div id="create-spatial-weights" class="section level3">

### Create Spatial Weights

We’ll use queens weights.

``` python
file = ps.lib.io.open("../data/Spatial/grid/full_16.shp")
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
data = ps.lib.io.open("../data/Spatial/grid/full_16.dbf", 'r')

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
    Data set            : full_16.shp
    Weights matrix      :      queens
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    269.7524                Number of Variables   :           2
    S.D. dependent var  :    234.9043                Degrees of Freedom    :         204
    R-squared           :      0.2319
    Adjusted R-squared  :      0.2281
    Sum squared residual: 8688916.209                F-statistic           :     61.5830
    Sigma-square        :   42592.727                Prob(F-statistic)     :    2.35e-13
    S.E. of regression  :     206.380                Log likelihood        :   -1389.219
    Sigma-square ML     :   42179.205                Akaike info criterion :    2782.437
    S.E of regression ML:    205.3758                Schwarz criterion     :    2789.093
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT      98.2840639      26.1569869       3.7574689       0.0002240
                 turnout       3.9907284       0.5085360       7.8474841       0.0000000
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            3.339
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          67.695           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                1          24.321           0.0000
    Koenker-Bassett test              1          11.374           0.0007
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.4092        10.872           0.0000
    Lagrange Multiplier (lag)         1         185.056           0.0000
    Robust LM (lag)                   1          75.588           0.0000
    Lagrange Multiplier (error)       1         109.863           0.0000
    Robust LM (error)                 1           0.394           0.5300
    Lagrange Multiplier (SARMA)       2         185.451           0.0000
    
    ================================ END OF REPORT =====================================

</div>

<div id="population-model" class="section level3">

### Population Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            : full_16.shp
    Weights matrix      :      queens
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    269.7524                Number of Variables   :           2
    S.D. dependent var  :    234.9043                Degrees of Freedom    :         204
    R-squared           :      0.7274
    Adjusted R-squared  :      0.7260
    Sum squared residual: 3083916.641                F-statistic           :    544.2785
    Sigma-square        :   15117.238                Prob(F-statistic)     :   1.749e-59
    S.E. of regression  :     122.952                Log likelihood        :   -1282.526
    Sigma-square ML     :   14970.469                Akaike info criterion :    2569.053
    S.E of regression ML:    122.3539                Schwarz criterion     :    2575.708
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT      14.3907445      13.8994204       1.0353485       0.3017319
                 tot_pop       0.1664542       0.0071348      23.3297769       0.0000000
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            2.900
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          37.351           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                1          16.341           0.0001
    Koenker-Bassett test              1           9.728           0.0018
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.3076         8.308           0.0000
    Lagrange Multiplier (lag)         1          22.631           0.0000
    Robust LM (lag)                   1           0.026           0.8724
    Lagrange Multiplier (error)       1          62.083           0.0000
    Robust LM (error)                 1          39.478           0.0000
    Lagrange Multiplier (SARMA)       2          62.109           0.0000
    
    ================================ END OF REPORT =====================================

</div>

<div id="combined-model" class="section level3">

### Combined Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            : full_16.shp
    Weights matrix      :      queens
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    269.7524                Number of Variables   :           3
    S.D. dependent var  :    234.9043                Degrees of Freedom    :         203
    R-squared           :      0.7652
    Adjusted R-squared  :      0.7629
    Sum squared residual: 2656269.924                F-statistic           :    330.7446
    Sigma-square        :   13085.074                Prob(F-statistic)     :   1.348e-64
    S.E. of regression  :     114.390                Log likelihood        :   -1267.151
    Sigma-square ML     :   12894.514                Akaike info criterion :    2540.301
    S.E of regression ML:    113.5540                Schwarz criterion     :    2550.285
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     -37.7200814      15.8212852      -2.3841351       0.0180404
                 turnout       1.7209689       0.3010361       5.7168196       0.0000000
                 tot_pop       0.1522223       0.0070894      21.4716712       0.0000000
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            3.980
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          19.714           0.0001
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                2          53.238           0.0000
    Koenker-Bassett test              2          35.032           0.0000
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.3368         9.125           0.0000
    Lagrange Multiplier (lag)         1          20.306           0.0000
    Robust LM (lag)                   1           0.641           0.4232
    Lagrange Multiplier (error)       1          74.399           0.0000
    Robust LM (error)                 1          54.735           0.0000
    Lagrange Multiplier (SARMA)       2          75.041           0.0000
    
    ================================ END OF REPORT =====================================

</div>

<div id="full-model" class="section level3">

### Full Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            : full_16.shp
    Weights matrix      :      queens
    Dependent Variable  :         csb                Number of Observations:         206
    Mean dependent var  :    269.7524                Number of Variables   :           2
    S.D. dependent var  :    234.9043                Degrees of Freedom    :         204
    R-squared           :      0.2319
    Adjusted R-squared  :      0.2281
    Sum squared residual: 8688916.209                F-statistic           :     61.5830
    Sigma-square        :   42592.727                Prob(F-statistic)     :    2.35e-13
    S.E. of regression  :     206.380                Log likelihood        :   -1389.219
    Sigma-square ML     :   42179.205                Akaike info criterion :    2782.437
    S.E of regression ML:    205.3758                Schwarz criterion     :    2789.093
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT      98.2840639      26.1569869       3.7574689       0.0002240
                 turnout       3.9907284       0.5085360       7.8474841       0.0000000
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            3.339
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2          67.695           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                1          24.321           0.0000
    Koenker-Bassett test              1          11.374           0.0007
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.4092        10.872           0.0000
    Lagrange Multiplier (lag)         1         185.056           0.0000
    Robust LM (lag)                   1          75.588           0.0000
    Lagrange Multiplier (error)       1         109.863           0.0000
    Robust LM (error)                 1           0.394           0.5300
    Lagrange Multiplier (SARMA)       2         185.451           0.0000
    
    ================================ END OF REPORT =====================================

</div>

</div>

<div id="rmd-source-code">

LS0tCnRpdGxlOiAiT0xTIE1vZGVsIDIwMTYiCm91dHB1dDogaHRtbF9ub3RlYm9vawotLS0KCiMjIEludHJvZHVjdGlvbgpUaGlzIG5vdGVib29rIGlzIG9uZSBvZiBhIG11bHRpcGxlIHBhcnQgc2VyaWVzIGZvciBhbmFseXppbmcgY3NiIGFuZCB2b3RlciBkYXRhLiBUaGlzIG5vdGVib29rIGFjY29tcGxpc2hlcyB0aGUgYnVpbGRpbmcgb2YgdGhlIE9MUyBtb2RlbCB1c2luZyB0aGUgcHl0aG9uIGxpYnJhcnkgYHB5c2FsYCBhbmQgdGhlIFIgcGFja2FnZSBgcmV0aWN1bGF0ZWAgdG8gYmUgYWJsZSB0byBleGVjdXRlIHB5dGhvbiBjb2RlIGluIGFuIFIgbm90ZWJvb2suCgpUaGlzIG5vdGVib29rIGZpdHMgbW9kZWxzIHVzaW5nIDIwMTYgZWxlY3Rpb24gZGF0YS4KCiMjIERlcGVuZGVuY2llcwoKIyMjIFNvZnR3YXJlIFZlcnNpb25zClIgVmVyc2lvbiAzLjUuMgpSU3R1ZGlvIFZlcnNpb24gMS4yLjEzMzAKUHl0aG9uIFZlcnNpb24gMy43LjMKUHlzYWwgVmVyc2lvbiAyLjAuMApOdW1weSBWZXJzaW9uIDEuMTUuMwoKVGhlc2UgYXJlIHRoZSBSIHBhY2thZ2VzIHdlIG5lZWQ6CmBgYHtyIGRlcGVuZGVuY2llc30KbGlicmFyeShyZXRpY3VsYXRlKSAjIHB5dGhvbiBpbnRlcmZhY2UKYGBgCgpBbmQgdGhlc2UgYXJlIHRoZSBQeXRob24gbGlicmFyaWVzIHdlIG5lZWQ6CgpgYGB7cHl0aG9uIGltcG9ydHN9CmltcG9ydCBvcwppbXBvcnQgcHlzYWwgYXMgcHMKaW1wb3J0IG51bXB5IGFzIG5wCmBgYAoKIyMgQnVpbGRpbmcgdGhlIE9MUyBNb2RlbHMKIyMjIENyZWF0ZSBTcGF0aWFsIFdlaWdodHMKV2UnbGwgdXNlIHF1ZWVucyB3ZWlnaHRzLgpgYGB7cHl0aG9ufQpmaWxlID0gcHMubGliLmlvLm9wZW4oIi4uL2RhdGEvU3BhdGlhbC9ncmlkL2Z1bGxfMTYuc2hwIikKdyA9IHBzLmxpYi53ZWlnaHRzLlF1ZWVuKGZpbGUpCgpgYGAKCiMjIyBTZXQgVmFyaWFibGVzIGZvciBNb2RlbHMKV2UncmUgZ29pbmcgdG8gY3JlYXRlIDQgbW9kZWxzLCBhbGwgd2l0aCB0aGUgbnVtYmVyIG9mIENTQiBjYWxscyBhcyB0aGUgZGVwZW5kZW50IHZhcmlhYmxlLgoKMS4gTWFpbiBFZmZlY3QgKFZvdGVyIFR1cm5vdXQpCjIuIFBvcHVsYXRpb24gTW9kZWwgKFBvcHVsYXRpb24pIAozLiBDb21iaW5lZCBNb2RlbCAoVm90ZXIgVHVybm91dCBhbmQgUG9wdWxhdGlvbikKNC4gRnVsbCBNb2RlbCAoVm90ZXIgVHVybm91dCwgUG9wdWxhdGlvbiwgTm9uLVdoaXRlIFBvcHVsYXRpb24sIFBvdmVydHksIEhpZ2hzY2hvb2wgRGlwbG9tYSwgQmFjaGVsb3JzIERlZ3JlZSkKCmBgYHtweXRob259CiMgbG9hZCBkYXRhCmRhdGEgPSBwcy5saWIuaW8ub3BlbigiLi4vZGF0YS9TcGF0aWFsL2dyaWQvZnVsbF8xNi5kYmYiLCAncicpCgojIHNldCBZIHZhcgp5X25hbWUgPSAiY3NiIgoKIyBjcmVhdGUgWSBhcnJheSwgdHJhbnNwb3NlCnkgPSBucC5hcnJheShbZGF0YS5ieV9jb2woeV9uYW1lKV0pLlQgCgojIGRlZmluZSBpbmRlcGVuZGVudCB2YXJzIGZvciBlYWNoIG1vZGVsCm1lX2luZCA9IFsidHVybm91dCJdCnBtX2luZCA9IFsidG90X3BvcCJdCmNtX2luZCA9IFsidHVybm91dCIsICJ0b3RfcG9wIl0KZm1faW5kID0gWyJ0dXJub3V0IiwgInRvdF9wb3AiLCAibm9ud2h0IiwgInB2cnR5IiwgImhzIiwgImJhIl0KCiMgY3JlYXRlIGFycmF5cyBmb3IgZWFjaCBtb2RlbAptZSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gbWVfaW5kXSkuVApwbSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gcG1faW5kXSkuVApjbSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gY21faW5kXSkuVApmbSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gZm1faW5kXSkuVAoKYGBgCgojIyBDcmVhdGUgT0xTIE1vZGVscwojIyMgTWFpbiBFZmZlY3QKYGBge3B5dGhvbn0Kb2xzX21lID0gcHMubW9kZWwuc3ByZWcuT0xTKHksIG1lLCB3PXcsIG5hbWVfeT15X25hbWUsIG5hbWVfeD1tZV9pbmQsIHNwYXRfZGlhZz1UcnVlLCBtb3Jhbj1UcnVlLApuYW1lX3c9J3F1ZWVucycsIG5hbWVfZHM9J2Z1bGxfMTYuc2hwJykKCnByaW50KG9sc19tZS5zdW1tYXJ5KQpgYGAKCiMjIyBQb3B1bGF0aW9uIE1vZGVsCmBgYHtweXRob259Cm9sc19wbSA9IHBzLm1vZGVsLnNwcmVnLk9MUyh5LCBwbSwgdz13LCBuYW1lX3k9eV9uYW1lLCBuYW1lX3g9cG1faW5kLCBzcGF0X2RpYWc9VHJ1ZSwgbW9yYW49VHJ1ZSwKbmFtZV93PSdxdWVlbnMnLCBuYW1lX2RzPSdmdWxsXzE2LnNocCcpCgpwcmludChvbHNfcG0uc3VtbWFyeSkKYGBgCgojIyMgQ29tYmluZWQgTW9kZWwKYGBge3B5dGhvbn0Kb2xzX2NtID0gcHMubW9kZWwuc3ByZWcuT0xTKHksIGNtLCB3PXcsIG5hbWVfeT15X25hbWUsIG5hbWVfeD1jbV9pbmQsIHNwYXRfZGlhZz1UcnVlLCBtb3Jhbj1UcnVlLApuYW1lX3c9J3F1ZWVucycsIG5hbWVfZHM9J2Z1bGxfMTYuc2hwJykKCnByaW50KG9sc19jbS5zdW1tYXJ5KQpgYGAKCiMjIyBGdWxsIE1vZGVsCmBgYHtweXRob259Cm9sc19mbSA9IHBzLm1vZGVsLnNwcmVnLk9MUyh5LCBmbSwgdz13LCBuYW1lX3k9eV9uYW1lLCBuYW1lX3g9Zm1faW5kLCBzcGF0X2RpYWc9VHJ1ZSwgbW9yYW49VHJ1ZSwKbmFtZV93PSdxdWVlbnMnLCBuYW1lX2RzPSdmdWxsXzE2LnNocCcpCgpwcmludChvbHNfZm0uc3VtbWFyeSkKYGBg

</div>

</div>
