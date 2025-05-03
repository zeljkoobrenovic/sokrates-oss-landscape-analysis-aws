echo "$SOKRATES_CONFIG" > /app/analysis-scripts/config.json

aws secretsmanager get-secret-value --secret-id gitHubToken --query SecretString --output text --region eu-west-1 > /app/analysis-script/secrets.json

bash run-generate-scripts.sh
bash run-execute-scripts.sh

aws s3 cp /app/analysis-artifacts/reports/ $AWS_S3_EXPORT_URI --recursive