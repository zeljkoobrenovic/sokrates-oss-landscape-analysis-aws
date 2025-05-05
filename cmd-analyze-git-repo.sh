mkdir temp

git clone $GIT_REPO_URL temp

cd temp

echo "java -jar -Xmx40g /app/sokrates-LATEST.jar init"
java -jar -Xmx40g /app/sokrates-LATEST.jar init -conventionsFile /app/analysis-scripts/scripts/analysis/sokrates_conventions.json -name "$REPO_NAME" -description "$REPO_DESCRIPTION" -addLink $GIT_REPO_URL 'GitHub Repo' -logoLink "$REPO_LOGO"


echo "java -jar -Xmx40g /app/sokrates-LATEST.jar generateReports"
java -jar -Xmx40g /app/sokrates-LATEST.jar generateReports -timeout 9999

echo "aws s3 cp _sokrates/reports $S3_FOLDER_URI --recursive"
aws s3 cp _sokrates/reports $S3_FOLDER_URI --recursive