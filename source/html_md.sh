#!/bin/bash
# convert html to ghub markdown

pandoc -f html -t gfm  -s 3a.\ OLS\ Model.nb.html -o model14.md
pandoc -f html -t gfm  -s 3b.\ OLS\ Model.nb.html -o model16.md
pandoc -f html -t gfm  -s 3c.\ OLS\ Model.nb.html -o model17.md
