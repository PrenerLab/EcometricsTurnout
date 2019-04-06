# Models 2016 Election

</div>

<div id="introduction" class="section level2">

## Introduction

This notebook is one of a multiple part series for analyzing csb and
voter data. This notebook accomplishes the building of the OLS and
spatial models using the python library `pysal` and the R package
`reticulate` to be able to execute python code in an R notebook.

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

We’re going to create 4 models, all with the Density of CSB calls (Calls
per 1000 people) as the dependent variable.

1.  Main Effect (Voter Turnout)
2.  Full Model (Voter Turnout, Population, Non-White Population,
    Poverty, Highschool Diploma)

<!-- end list -->

``` python
# load data
data = ps.lib.io.open("../data/Spatial/grid/full_16.dbf", 'r')

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
    Data set            : full_16.shp
    Weights matrix      :      queens
    Dependent Variable  :     csb_dns                Number of Observations:         206
    Mean dependent var  :    180.9742                Number of Variables   :           2
    S.D. dependent var  :    145.9416                Degrees of Freedom    :         204
    R-squared           :      0.1724
    Adjusted R-squared  :      0.1684
    Sum squared residual: 3613507.162                F-statistic           :     42.4980
    Sigma-square        :   17713.270                Prob(F-statistic)     :   5.446e-10
    S.E. of regression  :     133.091                Log likelihood        :   -1298.850
    Sigma-square ML     :   17541.297                Akaike info criterion :    2601.699
    S.E of regression ML:    132.4436                Schwarz criterion     :    2608.355
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT      89.1157022      16.8682244       5.2830517       0.0000003
                 turnout       2.1379001       0.3279468       6.5190456       0.0000000
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            3.339
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2        5346.241           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                1           0.260           0.6102
    Koenker-Bassett test              1           0.020           0.8869
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.2095         5.645           0.0000
    Lagrange Multiplier (lag)         1          12.782           0.0003
    Robust LM (lag)                   1           0.429           0.5123
    Lagrange Multiplier (error)       1          28.805           0.0000
    Robust LM (error)                 1          16.452           0.0000
    Lagrange Multiplier (SARMA)       2          29.234           0.0000
    
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
    Dependent Variable  :     csb_dns                Number of Observations:         206
    Mean dependent var  :    180.9742                Number of Variables   :           6
    S.D. dependent var  :    145.9416                Degrees of Freedom    :         200
    R-squared           :      0.2911
    Adjusted R-squared  :      0.2734
    Sum squared residual: 3095150.108                F-statistic           :     16.4274
    Sigma-square        :   15475.751                Prob(F-statistic)     :   1.423e-13
    S.E. of regression  :     124.402                Log likelihood        :   -1282.901
    Sigma-square ML     :   15025.001                Akaike info criterion :    2577.802
    S.E of regression ML:    122.5765                Schwarz criterion     :    2597.769
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     -20.0375449      39.6345631      -0.5055574       0.6137241
                 turnout       2.8063532       0.3466156       8.0964426       0.0000000
                 tot_pop      -0.0176170       0.0079452      -2.2173300       0.0277265
                  nonwht       0.9172899       0.4788174       1.9157406       0.0568243
                   pvrty      -0.5976954       1.0421371      -0.5735285       0.5669312
                      hs       2.6427846       1.2374191       2.1357231       0.0339179
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER           13.614
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2        5876.267           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                5         127.669           0.0000
    Koenker-Bassett test              5           9.419           0.0935
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.0913         3.004           0.0027
    Lagrange Multiplier (lag)         1           9.792           0.0018
    Robust LM (lag)                   1           4.333           0.0374
    Lagrange Multiplier (error)       1           5.469           0.0194
    Robust LM (error)                 1           0.010           0.9199
    Lagrange Multiplier (SARMA)       2           9.802           0.0074
    
    ================================ END OF REPORT =====================================

We’ll fit a lag model based on the significant lag value.

</div>

</div>

<div id="create-spatial-model" class="section level2">

## Create Spatial Model

<div id="full-model-1" class="section level3">

### Full Model

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: SPATIAL TWO STAGE LEAST SQUARES
    --------------------------------------------------
    Data set            : full_16.shp
    Weights matrix      :      queens
    Dependent Variable  :     csb_dns                Number of Observations:         206
    Mean dependent var  :    180.9742                Number of Variables   :           7
    S.D. dependent var  :    145.9416                Degrees of Freedom    :         199
    Pseudo R-squared    :      0.3357
    Spatial Pseudo R-squared:  0.3003
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     z-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     -28.8232524      38.0027970      -0.7584508       0.4481811
                 turnout       2.5779498       0.3452420       7.4670811       0.0000000
                 tot_pop      -0.0255033       0.0083184      -3.0658842       0.0021703
                  nonwht       0.5578859       0.4827496       1.1556425       0.2478274
                   pvrty      -0.6376353       0.9943271      -0.6412732       0.5213452
                      hs       2.3937722       1.1854206       2.0193442       0.0434515
               W_csb_dns       0.0504442       0.0219234       2.3009346       0.0213953
    ------------------------------------------------------------------------------------
    Instrumented: W_csb_dns
    Instruments: W_hs, W_nonwht, W_pvrty, W_tot_pop, W_turnout
    ================================ END OF REPORT =====================================

</div>

</div>

</div>
