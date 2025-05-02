cd analysis-scripts/github-repos-finder

node get-repos.js

rm ../generated/analysis-scripts/run-analysis-*

node generate-sh-scripts.js
