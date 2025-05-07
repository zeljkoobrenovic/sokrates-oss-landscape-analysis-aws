
if [[ -z "${S3_PAYLOAD_UR}" ]]; then
  echo "PAYLOAD_ID not defined"
  exit 1
fi

aws s3 cp $S3_PAYLOAD_URI payload.json

node /app/analysis-scripts/payload/create-payload-script.js
bash temp-run-payload-analysis.sh

exit 0
