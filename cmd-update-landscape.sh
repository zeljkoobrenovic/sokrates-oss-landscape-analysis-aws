aws cp s3://sokrates-gallery/$LANDSCAPE_NAME/all-reports.zip .
mkdir temp
cd temp
unzip all-reports.zip

cp -rf /app/analysis-artifacts/reports/$LANDSCAPE_NAME/* /app/temp/app/analysis-artifacts/reports/$LANDSCAPE_NAME

cd /app/temp/app/analysis-artifacts/reports/$LANDSCAPE_NAME

java -jar -XmX40g /app/sokrates-LATEST.jar updateLandscape

aws cp _sokrates_landscape/ s3://sokrates-gallery/$LANDSCAPE_NAME/_sokrates_landscape/p --recursive