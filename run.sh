echo "$SOKRATES_CONFIG" > /app/analysis-scripts/config.json

bash run-generate-scripts.sh
bash run-execute-scripts.sh

aws aws s3 cp /app/analysis-artifacts/reports/ $AWS_S3_EXPORT_URI --recursive