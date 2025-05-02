bash run-generate-scripts.sh
bash run-execute-scripts.sh

aws s3 sync /app/analysis-artifacts $AWS_S3_EXPORT_URI --delete