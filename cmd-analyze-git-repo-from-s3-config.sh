
if [[ -z "${S3_PAYLOAD_URI}" ]]; then
  echo "S3_PAYLOAD_URI not defined"
  exit 1
fi

aws s3 cp $S3_PAYLOAD_URI payload.json

cd /app/analysis-scripts/payload/
node create-payload-script

cd /app
bash temp-run-payload-analysis.sh

exit 0
