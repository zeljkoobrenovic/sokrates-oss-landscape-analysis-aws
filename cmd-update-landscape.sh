mkdir temp
cd temp

aws s3 cp s3://sokrates-gallery/$LANDSCAPE_NAME/all-reports.zip .
unzip all-reports.zip

cp -rf /app/analysis-artifacts/reports/$LANDSCAPE_NAME/* /app/temp/app/analysis-artifacts/reports/$LANDSCAPE_NAME

cd /app/temp/app/analysis-artifacts/reports/$LANDSCAPE_NAME

java -jar -XmX40g /app/sokrates-LATEST.jar updateLandscape

aws cp _sokrates_landscape/ s3://sokrates-gallery/$LANDSCAPE_NAME/_sokrates_landscape/ --recursive