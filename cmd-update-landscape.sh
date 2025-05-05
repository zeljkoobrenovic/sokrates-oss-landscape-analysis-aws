mkdir temp
cd temp

echo "aws s3 cp s3://sokrates-gallery/$LANDSCAPE_NAME/all-reports.zip ."
aws s3 cp s3://sokrates-gallery/$LANDSCAPE_NAME/all-reports.zip .

echo "unzip -q all-reports.zip"
unzip -q all-reports.zip

cp -rf /app/analysis-artifacts/reports/$LANDSCAPE_NAME/* /app/temp/app/analysis-artifacts/reports/$LANDSCAPE_NAME

cd /app/temp/app/analysis-artifacts/reports/$LANDSCAPE_NAME

echo "-jar -Xmx40g /app/sokrates-LATEST.jar updateLandscape"
java -jar -Xmx40g /app/sokrates-LATEST.jar updateLandscape

echo "aws s3 cp _sokrates_landscape/ s3://sokrates-gallery/$LANDSCAPE_NAME/_sokrates_landscape/ --recursive"
aws s3 cp _sokrates_landscape/ s3://sokrates-gallery/$LANDSCAPE_NAME/_sokrates_landscape/ --recursive