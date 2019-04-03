#!/bin/bash
# convert html to ghub markdown

cd docs

pandoc -f html -t gfm  -s 3a.\ Models_14.nb.html -o models_md/model_14.md
pandoc -f html -t gfm  -s 3b.\ Models_16.nb.html -o models_md/model_16.md
pandoc -f html -t gfm  -s 3c.\ Models_17.nb.html -o models_md/model_17.md
