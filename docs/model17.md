<div class="container-fluid main-container">

<div id="header" class="fluid-row">

<div class="btn-group pull-right">

<span>Code</span> <span class="caret"></span>

  - [Show All Code](#)

  - [Hide All Code](#)

  - 
  - [Download Rmd](#)

</div>

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

``` python
ols_me = ps.model.spreg.OLS(y, me, w=w, name_y=y_name, name_x=me_ind, spat_diag=True, moran=True,
name_w='queens', name_ds='full_17.shp')

print(ols_me.summary)
```

</div>

<div id="population-model" class="section level3">

### Population Model

``` python
ols_pm = ps.model.spreg.OLS(y, pm, w=w, name_y=y_name, name_x=pm_ind, spat_diag=True, moran=True,
name_w='queens', name_ds='full_17.shp')

print(ols_pm.summary)
```

</div>

<div id="combined-model" class="section level3">

### Combined Model

``` python
ols_cm = ps.model.spreg.OLS(y, cm, w=w, name_y=y_name, name_x=cm_ind, spat_diag=True, moran=True,
name_w='queens', name_ds='full_17.shp')

print(ols_cm.summary)
```

</div>

<div id="full-model" class="section level3">

### Full Model

``` python
ols_fm = ps.model.spreg.OLS(y, fm, w=w, name_y=y_name, name_x=fm_ind, spat_diag=True, moran=True,
name_w='queens', name_ds='full_17.shp')

print(ols_fm.summary)
```

</div>

</div>

<div id="rmd-source-code">

LS0tCnRpdGxlOiAiT0xTIE1vZGVsIDIwMTciCm91dHB1dDogaHRtbF9ub3RlYm9vawotLS0KCiMjIEludHJvZHVjdGlvbgpUaGlzIG5vdGVib29rIGlzIG9uZSBvZiBhIG11bHRpcGxlIHBhcnQgc2VyaWVzIGZvciBhbmFseXppbmcgY3NiIGFuZCB2b3RlciBkYXRhLiBUaGlzIG5vdGVib29rIGFjY29tcGxpc2hlcyB0aGUgYnVpbGRpbmcgb2YgdGhlIE9MUyBtb2RlbCB1c2luZyB0aGUgcHl0aG9uIGxpYnJhcnkgYHB5c2FsYCBhbmQgdGhlIFIgcGFja2FnZSBgcmV0aWN1bGF0ZWAgdG8gYmUgYWJsZSB0byBleGVjdXRlIHB5dGhvbiBjb2RlIGluIGFuIFIgbm90ZWJvb2suCgpUaGlzIG5vdGVib29rIGZpdHMgbW9kZWxzIHVzaW5nIDIwMTcgZWxlY3Rpb24gZGF0YS4KCiMjIERlcGVuZGVuY2llcwoKIyMjIFNvZnR3YXJlIFZlcnNpb25zClIgVmVyc2lvbiAzLjUuMgpSU3R1ZGlvIFZlcnNpb24gMS4yLjEzMzAKUHl0aG9uIFZlcnNpb24gMy43LjMKUHlzYWwgVmVyc2lvbiAyLjAuMApOdW1weSBWZXJzaW9uIDEuMTUuMwoKVGhlc2UgYXJlIHRoZSBSIHBhY2thZ2VzIHdlIG5lZWQ6CmBgYHtyIGRlcGVuZGVuY2llc30KbGlicmFyeShyZXRpY3VsYXRlKSAjIHB5dGhvbiBpbnRlcmZhY2UKYGBgCgpBbmQgdGhlc2UgYXJlIHRoZSBQeXRob24gbGlicmFyaWVzIHdlIG5lZWQ6CgpgYGB7cHl0aG9uIGltcG9ydHN9CmltcG9ydCBvcwppbXBvcnQgcHlzYWwgYXMgcHMKaW1wb3J0IG51bXB5IGFzIG5wCmBgYAoKIyMgQnVpbGRpbmcgdGhlIE9MUyBNb2RlbHMKIyMjIENyZWF0ZSBTcGF0aWFsIFdlaWdodHMKV2UnbGwgdXNlIHF1ZWVucyB3ZWlnaHRzLgpgYGB7cHl0aG9ufQpmaWxlID0gcHMubGliLmlvLm9wZW4oIi4uL2RhdGEvU3BhdGlhbC9ncmlkL2Z1bGxfMTcuc2hwIikKdyA9IHBzLmxpYi53ZWlnaHRzLlF1ZWVuKGZpbGUpCgpgYGAKCiMjIyBTZXQgVmFyaWFibGVzIGZvciBNb2RlbHMKV2UncmUgZ29pbmcgdG8gY3JlYXRlIDQgbW9kZWxzLCBhbGwgd2l0aCB0aGUgbnVtYmVyIG9mIENTQiBjYWxscyBhcyB0aGUgZGVwZW5kZW50IHZhcmlhYmxlLgoKMS4gTWFpbiBFZmZlY3QgKFZvdGVyIFR1cm5vdXQpCjIuIFBvcHVsYXRpb24gTW9kZWwgKFBvcHVsYXRpb24pIAozLiBDb21iaW5lZCBNb2RlbCAoVm90ZXIgVHVybm91dCBhbmQgUG9wdWxhdGlvbikKNC4gRnVsbCBNb2RlbCAoVm90ZXIgVHVybm91dCwgUG9wdWxhdGlvbiwgTm9uLVdoaXRlIFBvcHVsYXRpb24sIFBvdmVydHksIEhpZ2hzY2hvb2wgRGlwbG9tYSwgQmFjaGVsb3JzIERlZ3JlZSkKCmBgYHtweXRob259CiMgbG9hZCBkYXRhCmRhdGEgPSBwcy5saWIuaW8ub3BlbigiLi4vZGF0YS9TcGF0aWFsL2dyaWQvZnVsbF8xNy5kYmYiLCAncicpCgojIHNldCBZIHZhcgp5X25hbWUgPSAiY3NiIgoKIyBjcmVhdGUgWSBhcnJheSwgdHJhbnNwb3NlCnkgPSBucC5hcnJheShbZGF0YS5ieV9jb2woeV9uYW1lKV0pLlQgCgojIGRlZmluZSBpbmRlcGVuZGVudCB2YXJzIGZvciBlYWNoIG1vZGVsCm1lX2luZCA9IFsidHVybm91dCJdCnBtX2luZCA9IFsidG90X3BvcCJdCmNtX2luZCA9IFsidHVybm91dCIsICJ0b3RfcG9wIl0KZm1faW5kID0gWyJ0dXJub3V0IiwgInRvdF9wb3AiLCAibm9ud2h0IiwgInB2cnR5IiwgImhzIiwgImJhIl0KCiMgY3JlYXRlIGFycmF5cyBmb3IgZWFjaCBtb2RlbAptZSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gbWVfaW5kXSkuVApwbSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gcG1faW5kXSkuVApjbSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gY21faW5kXSkuVApmbSA9IG5wLmFycmF5KFtkYXRhLmJ5X2NvbCh2YXIpIGZvciB2YXIgaW4gZm1faW5kXSkuVAoKYGBgCgojIyBDcmVhdGUgT0xTIE1vZGVscwojIyMgTWFpbiBFZmZlY3QKYGBge3B5dGhvbn0Kb2xzX21lID0gcHMubW9kZWwuc3ByZWcuT0xTKHksIG1lLCB3PXcsIG5hbWVfeT15X25hbWUsIG5hbWVfeD1tZV9pbmQsIHNwYXRfZGlhZz1UcnVlLCBtb3Jhbj1UcnVlLApuYW1lX3c9J3F1ZWVucycsIG5hbWVfZHM9J2Z1bGxfMTcuc2hwJykKCnByaW50KG9sc19tZS5zdW1tYXJ5KQpgYGAKCiMjIyBQb3B1bGF0aW9uIE1vZGVsCmBgYHtweXRob259Cm9sc19wbSA9IHBzLm1vZGVsLnNwcmVnLk9MUyh5LCBwbSwgdz13LCBuYW1lX3k9eV9uYW1lLCBuYW1lX3g9cG1faW5kLCBzcGF0X2RpYWc9VHJ1ZSwgbW9yYW49VHJ1ZSwKbmFtZV93PSdxdWVlbnMnLCBuYW1lX2RzPSdmdWxsXzE3LnNocCcpCgpwcmludChvbHNfcG0uc3VtbWFyeSkKYGBgCgojIyMgQ29tYmluZWQgTW9kZWwKYGBge3B5dGhvbn0Kb2xzX2NtID0gcHMubW9kZWwuc3ByZWcuT0xTKHksIGNtLCB3PXcsIG5hbWVfeT15X25hbWUsIG5hbWVfeD1jbV9pbmQsIHNwYXRfZGlhZz1UcnVlLCBtb3Jhbj1UcnVlLApuYW1lX3c9J3F1ZWVucycsIG5hbWVfZHM9J2Z1bGxfMTcuc2hwJykKCnByaW50KG9sc19jbS5zdW1tYXJ5KQpgYGAKCiMjIyBGdWxsIE1vZGVsCmBgYHtweXRob259Cm9sc19mbSA9IHBzLm1vZGVsLnNwcmVnLk9MUyh5LCBmbSwgdz13LCBuYW1lX3k9eV9uYW1lLCBuYW1lX3g9Zm1faW5kLCBzcGF0X2RpYWc9VHJ1ZSwgbW9yYW49VHJ1ZSwKbmFtZV93PSdxdWVlbnMnLCBuYW1lX2RzPSdmdWxsXzE3LnNocCcpCgpwcmludChvbHNfZm0uc3VtbWFyeSkKYGBg

</div>

</div>
