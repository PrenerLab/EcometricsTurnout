# Models 2014 Election

</div>

<div id="introduction" class="section level2">

## Introduction

This notebook is one of a multiple part series for analyzing csb and
voter data. This notebook accomplishes the building of the OLS and
spatial models using the python library `pysal` and the R package
`reticulate` to be able to execute python code in an R notebook.

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
file = ps.lib.io.open("../data/Spatial/grid/full_14.shp")
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
data = ps.lib.io.open("../data/Spatial/grid/full_14.dbf", 'r')

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
    Data set            : full_14.shp
    Weights matrix      :      queens
    Dependent Variable  :     csb_dns                Number of Observations:         206
    Mean dependent var  :    131.7398                Number of Variables   :           2
    S.D. dependent var  :    123.5542                Degrees of Freedom    :         204
    R-squared           :      0.2891
    Adjusted R-squared  :      0.2857
    Sum squared residual: 2224606.958                F-statistic           :     82.9763
    Sigma-square        :   10904.936                Prob(F-statistic)     :   7.816e-17
    S.E. of regression  :     104.427                Log likelihood        :   -1248.884
    Sigma-square ML     :   10799.063                Akaike info criterion :    2501.769
    S.E of regression ML:    103.9185                Schwarz criterion     :    2508.425
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT      51.5485435      11.4208684       4.5135398       0.0000108
                 turnout       4.0714349       0.4469618       9.1091347       0.0000000
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            2.780
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2       12270.943           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                1         208.778           0.0000
    Koenker-Bassett test              1          10.811           0.0010
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.1409         3.836           0.0001
    Lagrange Multiplier (lag)         1           6.876           0.0087
    Robust LM (lag)                   1           0.000           0.9872
    Lagrange Multiplier (error)       1          13.029           0.0003
    Robust LM (error)                 1           6.153           0.0131
    Lagrange Multiplier (SARMA)       2          13.029           0.0015
    
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
    Dependent Variable  :     csb_dns                Number of Observations:         206
    Mean dependent var  :    131.7398                Number of Variables   :           6
    S.D. dependent var  :    123.5542                Degrees of Freedom    :         200
    R-squared           :      0.3657
    Adjusted R-squared  :      0.3499
    Sum squared residual: 1984866.081                F-statistic           :     23.0664
    Sigma-square        :    9924.330                Prob(F-statistic)     :   2.928e-18
    S.E. of regression  :      99.621                Log likelihood        :   -1237.139
    Sigma-square ML     :    9635.272                Akaike info criterion :    2486.279
    S.E of regression ML:     98.1594                Schwarz criterion     :    2506.246
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     -31.2234931      31.0720602      -1.0048736       0.3161719
                 turnout       4.4794567       0.4659821       9.6129376       0.0000000
                 tot_pop      -0.0055720       0.0062040      -0.8981212       0.3702009
                  nonwht       0.6371235       0.3855218       1.6526264       0.0999759
                   pvrty      -0.2925951       0.8058544      -0.3630868       0.7169235
                      hs       1.9573975       0.9759533       2.0056262       0.0462438
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER           13.639
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2       12313.873           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                5         308.167           0.0000
    Koenker-Bassett test              5          15.866           0.0072
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Moran's I (error)              0.0557         2.031           0.0423
    Lagrange Multiplier (lag)         1           4.786           0.0287
    Robust LM (lag)                   1           2.906           0.0883
    Lagrange Multiplier (error)       1           2.035           0.1537
    Robust LM (error)                 1           0.154           0.6946
    Lagrange Multiplier (SARMA)       2           4.940           0.0846
    
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
    Data set            : full_14.shp
    Weights matrix      :      queens
    Dependent Variable  :     csb_dns                Number of Observations:         206
    Mean dependent var  :    131.7398                Number of Variables   :           7
    S.D. dependent var  :    123.5542                Degrees of Freedom    :         199
    Pseudo R-squared    :      0.3865
    Spatial Pseudo R-squared:  0.3729
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     z-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT     -38.8143847      30.3875385      -1.2773126       0.2014919
                 turnout       4.3362549       0.4581174       9.4653788       0.0000000
                 tot_pop      -0.0124818       0.0070728      -1.7647500       0.0776058
                  nonwht       0.3545911       0.4034572       0.8788816       0.3794655
                   pvrty      -0.1800538       0.7832742      -0.2298733       0.8181902
                      hs       1.9383758       0.9458116       2.0494311       0.0404200
               W_csb_dns       0.0403313       0.0217457       1.8546836       0.0636414
    ------------------------------------------------------------------------------------
    Instrumented: W_csb_dns
    Instruments: W_hs, W_nonwht, W_pvrty, W_tot_pop, W_turnout
    ================================ END OF REPORT =====================================

</div>

</div>

</div>
