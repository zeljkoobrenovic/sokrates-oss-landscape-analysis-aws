mkdir -p /app/analysis-scripts/generated/payloads/cache

echo "$SOKRATES_CONFIG" > /app/analysis-scripts/config.json

aws secretsmanager get-secret-value --secret-id gitHubToken --query SecretString --output text --region eu-west-1 > /app/analysis-scripts/secrets.json

bash run-generate-scripts.sh

aws s3 cp /app/analysis-scripts/generated/payloads.json s3://sokrates-gallery/_payloads/payloads.json

aws s3 cp /app/analysis-scripts/generated/payloads s3://sokrates-gallery/_payloads/ --recursive