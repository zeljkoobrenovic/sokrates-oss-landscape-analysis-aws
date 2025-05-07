const fs = require('fs');

let script = '#!/bin/bash\n\n';

const payload = JSON.parse(fs.readFileSync('/app/payload.json', 'utf8'));

script += 'export COMMAND="' + payload.COMMAND + '"\n';
script += 'export GIT_REPO_URL="' + payload.GIT_REPO_URL + '"\n';
script += 'export S3_FOLDER_URI="' + payload.S3_FOLDER_URI + '"\n';
script += 'export REPO_NAME="' + payload.REPO_NAME + '"\n';
script += 'export REPO_LOGO="' + payload.REPO_LOGO + '"\n';
script += 'export COMMAND="' + payload.COMMAND + '"\n';
script += 'export REPO_DESCRIPTION="' + payload.REPO_DESCRIPTION + '"\n\n';

script += 'bash cmd-analyze-git-repo.sh\n';

fs.writeFileSync('/app/temp-run-payload-analysis.sh', script);
