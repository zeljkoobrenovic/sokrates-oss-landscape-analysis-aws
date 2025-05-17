pandoc summary.md -o summary.html \
  --standalone \
  --css=../style.css \
  --metadata title="Sokrates Landscape" \
  --metadata author="GitLab" \
  --metadata date="$(date +%Y-%m-%d)" \
  --metadata description="Sokrates Landscape" \
  --metadata keywords="sokrates, landscape, gitlab, analysis"