if [[ -z "${PAYLOAD_ID}" ]]; then
  echo "PAYLOAD_ID not defined"
  exit 1
fi

node /app/analysis-scripts/payload/create-payload-script.js
bash temp-run-payload-analysis.sh

exit 0
