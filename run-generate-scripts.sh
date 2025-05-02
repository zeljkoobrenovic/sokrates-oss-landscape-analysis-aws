cd /app/analysis-scripts/github-repos-finder

node get-repos.js

rm /app/analysis-scripts/generated/analysis-scripts/run-analysis-*

node generate-sh-scripts.js
