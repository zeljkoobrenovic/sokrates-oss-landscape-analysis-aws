mkdir temp
cd temp

echo "aws s3 cp $S3_FOLDER_URI ."
aws s3 cp $S3_FOLDER_URI . --recursive
rm all-reports.zip

echo "zip -q -r all-reports.zip ."
zip -q -r all-reports.zip .

echo "aws s3 cp all-reports.zip S3_FOLDER_URI/all-reports.zip"
aws s3 cp all-reports.zip $S3_FOLDER_URI/all-reports.zip

if [[ -z "${LANDSCAPE_NAME}" ]]; then
  echo "Not using a pre-defined landscapoe settings"
else
  if [ -d /app/analysis-artifacts/$LANDSCAPE_NAME/_sokrates_landscape/ ]; then
    rm -rf _sokrates_landscape
    mkdir _sokrates_landscape
    cp -r /app/analysis-artifacts/$LANDSCAPE_NAME/_sokrates_landscape/ _sokrates_landscape/
  fi
fi


echo "-jar -Xmx40g /app/sokrates-LATEST.jar updateLandscape"
java -jar -Xmx40g /app/sokrates-LATEST.jar updateLandscape

echo "aws s3 cp _sokrates_landscape/ $S3_FOLDER_URI/_sokrates_landscape/ --recursive"
aws s3 cp _sokrates_landscape/ $S3_FOLDER_URI/_sokrates_landscape/ --recursive