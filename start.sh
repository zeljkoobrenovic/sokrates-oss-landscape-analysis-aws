# Clone the repository
git clone https://github.com/zeljkoobrenovic/sokrates-oss-landscape-analysis-aws.git

mv sokrates-oss-landscape-analysis-aws/* .

# Download the Sokrates CLI JAR
curl https://d2bb1mtyn3kglb.cloudfront.net/builds/sokrates-LATEST.jar --output sokrates-LATEST.jar

if [ -n "$COMMAND" ]; then
  if [[ "$COMMAND" != "analyze-github-orgs" && "$COMMAND" != "analyze-git-repo" && "$COMMAND" != "update-landscape" ]]; then
    echo "Invalid command: $COMMAND"
    bash cmd-help.sh
    exit 1
  fi
  bash "cmd-$COMMAND"
else
  bash run.sh
  exit 1
fi
