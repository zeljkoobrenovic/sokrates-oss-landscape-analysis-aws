bash run-generate-scripts.sh
bash run-execute-scripts.sh

aws s3 sync /app/analysis-artifacts/reports/openai s3://sokrates-gallery/openai_test --delete