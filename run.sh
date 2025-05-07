if [ -n "$COMMAND" ]; then
  # Check if the command is valid
  if [[ "$COMMAND" != "analyze-github-orgs" && "$COMMAND" != "analyze-git-repo" && "$COMMAND" != "init-landscape"  && "$COMMAND" != "update-landscape"  && "$COMMAND" != "get-payloads"   && "$COMMAND" != "analyze-git-repo-from-s3-config" ]]; then
    echo "Invalid command: $COMMAND"
    bash "cmd-help.sh"
    exit 1
  fi

  # Run the command
  bash "cmd-$COMMAND.sh"

  exit 0
fi

exit 1
