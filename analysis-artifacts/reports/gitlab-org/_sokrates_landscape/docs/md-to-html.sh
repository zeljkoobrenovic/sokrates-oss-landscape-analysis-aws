pandoc summary.md \
  -o summary.html \
  --standalone \
  --metadata date="$(date +%Y-%m-%d)"