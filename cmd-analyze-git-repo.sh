# Description: This script analyzes a GitHub repository using Sokrates and uploads the reports to an S3 bucket.
# Parameters via environment variables:
# - $GIT_REPO_URL: The URL of the GitHub repository to analyze.
# - $S3_FOLDER_URI: The S3 URI where the reports will be uploaded.
# - $REPO_NAME: The name of the repository.
# - $REPO_DESCRIPTION: The description of the repository.
# - $REPO_LOGO: The URL of the logo for the repository.

mkdir temp

git clone $GIT_REPO_URL temp

cd temp

echo "java -jar -Xmx40g /app/sokrates-LATEST.jar extractGitHistory"
java -jar -Xmx40g /app/sokrates-LATEST.jar extractGitHistory

echo "java -jar -Xmx40g /app/sokrates-LATEST.jar init"
java -jar -Xmx40g /app/sokrates-LATEST.jar init -conventionsFile /app/analysis-scripts/scripts/analysis/sokrates_conventions.json -name "$REPO_NAME" -description "$REPO_DESCRIPTION" -addLink $GIT_REPO_URL 'GitHub Repo' -logoLink "$REPO_LOGO"


echo "java -jar -Xmx40g /app/sokrates-LATEST.jar generateReports"
java -jar -Xmx40g /app/sokrates-LATEST.jar generateReports -timeout 9999

echo "aws s3 cp _sokrates/reports $S3_FOLDER_URI --recursive"
aws s3 cp _sokrates/reports $S3_FOLDER_URI --recursive