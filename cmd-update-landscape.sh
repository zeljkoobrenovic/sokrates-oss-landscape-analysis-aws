mkdir temp
cd temp

echo "aws s3 cp s3://sokrates-gallery/$LANDSCAPE_NAME/all-reports.zip ."
aws s3 cp s3://sokrates-gallery/$LANDSCAPE_NAME/all-reports.zip .

echo "unzip -q all-reports.zip"
unzip -q all-reports.zip

cp -rf /app/analysis-artifacts/reports/$LANDSCAPE_NAME/* /app/temp

echo "-jar -Xmx40g /app/sokrates-LATEST.jar updateLandscape"
java -jar -Xmx40g /app/sokrates-LATEST.jar updateLandscape

echo "s3 cp _sokrates_landscape/ s3://sokrates-gallery/$LANDSCAPE_NAME/_sokrates_landscape/ --recursive"
pwd
ls -l _sokrates_landscape/
aws s3 cp _sokrates_landscape/ s3://sokrates-gallery/$LANDSCAPE_NAME/_sokrates_landscape/ --recursive