if [ -n "$COMMAND" ]; then
  # Check if the command is valid
  if [[ "$COMMAND" != "analyze-github-orgs" && "$COMMAND" != "analyze-git-repo" && "$COMMAND" != "update-landscape" ]]; then
    echo "Invalid command: $COMMAND"
    exit 1
  fi

  # Run the command
  bash run.sh "$COMMAND"

  exit 1
fi
