mkdir -p /app/analysis-scripts/generated/payloads/cache

echo "$SOKRATES_CONFIG" > /app/analysis-scripts/config.json

bash run-generate-scripts.sh

aws s3 cp /app/analysis-scripts/generated/payloads s3://sokrates-gallery/_payloads/ --recursive