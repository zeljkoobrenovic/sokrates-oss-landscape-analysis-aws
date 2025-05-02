cd analysis-scripts/generated/clone-scripts
bash run-all.sh
# or run-all-parallel.sh, to run cloning or repos for multiple organization in parallel

cd ../analysis-scripts
bash run-all.sh

aws s3 sync /app/analysis-artifacts/reports/openai s3://sokrates-gallery/openai_test --delete