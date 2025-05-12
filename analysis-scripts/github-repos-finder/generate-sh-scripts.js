const fs = require('fs');

const config = JSON.parse(fs.readFileSync('/app/analysis-scripts/config.json'));

const runAnalysisLinePrefix = 'bash /app/analysis-scripts/scripts/analysis/run-analysis-from-zip.sh ';
const cloneAndDownloadLinePrefix = 'bash /app/analysis-scripts/scripts/git/clone-and-zip.sh ';

let envVariables = '';

envVariables += 'export SOKRATES_JAR_PATH="/app/sokrates-LATEST.jar"\n';
envVariables += 'export SOKRATES_GITHUB_URL="' + config.githubCloneUrl + '"\n';
envVariables += 'export SOKRATES_JAVA_OPTIONS="' + config.javaOptions + '"\n';

const payloads = [];

function getToday() {
    const today = new Date();
    const yyyy = today.getFullYear();
    let mm = today.getMonth() + 1;
    let dd = today.getDate();

    if (dd < 10) dd = '0' + dd;
    if (mm < 10) mm = '0' + mm;

    return yyyy + '-' + mm + '-' + dd;
}

const todayString = getToday();

envVariables += 'export SOKRATES_ANALYSIS_DATE="' + todayString + '"\n';

const cloneScriptsFolder = '/app/analysis-scripts/generated/clone-scripts/';
const analysisScriptsFolder = '/app/analysis-scripts/generated/analysis-scripts/';
const payloadsFolder = '/app/analysis-scripts/generated/payloads/';

if (!fs.existsSync(cloneScriptsFolder)) fs.mkdirSync(cloneScriptsFolder, {recursive: true});
if (!fs.existsSync(analysisScriptsFolder)) fs.mkdirSync(analysisScriptsFolder, {recursive: true});

let cloneAllScript = '';
let cloneAllScriptParallel = '';
let analyzeAllScript = '';

const ignoreRepos = [];

function notIgnored(org, repo) {
    let notIgnored = true;

    console.log(org + ' ' + repo.name);

    ignoreRepos.forEach(ignore => {
        if (ignore.org === org && ignore.repo === repo.name) {
            notIgnored = false;
            return;
        }
    })

    return notIgnored;
}

function createAnalysisScripts(org, activeRepos) {
    let runAnalysisScript = envVariables + '\n';
    const analysisScriptFileName = 'run-analysis-' + org + '.sh';
    const scriptPath = analysisScriptsFolder + 'run-analysis-' + org + '.sh';
    console.log(scriptPath);

    activeRepos.forEach(repo => {
        let description = repo.description ? repo.description : " ";
        description = description.replace(/\)/g, "&rpar;");
        description = description.replace(/\(/g, "&lpar;");
        description = description.replace(/\'/g, "&apos;");
        const line = runAnalysisLinePrefix + "'"
            + org + "' '"
            + repo.name + "' '"
            + repo.clone_url + "' '"
            + description + "' '"
            + repo.pushed_at + "'";
        runAnalysisScript += line + "\n";
        fs.writeFileSync(scriptPath, runAnalysisScript + '\n' +
            'cd /app/analysis-artifacts/reports/' + org + '\n' +
            'java -jar $SOKRATES_JAVA_OPTIONS $SOKRATES_JAR_PATH updateLandscape\n\n' +
            'zip -q -r /app/analysis-artifacts/reports/' + org + '/all-reports.zip ' + '/app/analysis-artifacts/reports/' + org + '\n'
        );
    });

    analyzeAllScript += 'bash ' + analysisScriptFileName + '\n';
    fs.writeFileSync(analysisScriptsFolder + 'run-all.sh', analyzeAllScript);
}

function createCloneAndZipScripts(org, activeRepos) {
    let cloneAndZipScript = envVariables + '\n';

    const cloneScriptFileName = 'clone-and-zip-' + org + '.sh';
    const scriptPath = cloneScriptsFolder + 'clone-and-zip-' + org + '.sh';
    console.log(scriptPath);

    activeRepos.forEach(repo => {
        const line = cloneAndDownloadLinePrefix + "'" + org + "' '" + repo.name + "' '" + repo.pushed_at + "'";
        cloneAndZipScript += line + "\n";
        fs.writeFileSync(scriptPath, cloneAndZipScript);
    });

    cloneAllScript += 'bash ' + cloneScriptFileName + '\n';
    cloneAllScriptParallel += 'bash ' + cloneScriptFileName + ' &\n';
    fs.writeFileSync(cloneScriptsFolder + 'run-all.sh', cloneAllScript);
    fs.writeFileSync(cloneScriptsFolder + 'run-all-parallel.sh', cloneAllScriptParallel);
}

const payloadsWrapper = {
    payloads: [],
    finalPayloads: []
}

const payloadsIdsWrapper = {
    payloads: [],
    finalPayloads: []
}

function createPayloadsJson(org, activeRepos) {
    activeRepos.forEach(repo => {
        let description = repo.description ? repo.description : " ";
        description = description.replace(/\)/g, "&rpar;");
        description = description.replace(/\(/g, "&lpar;");
        description = description.replace(/\'/g, "&apos;");
        let id = org + ' / ' + repo.name;
        const payload = {
            "COMMAND": "analyze-git-repo",
            "GIT_REPO_URL": repo.clone_url,
            "S3_FOLDER_URI": "s3://sokrates-gallery/" + org + '/' + repo.name,
            "REPO_NAME": id,
            "REPO_LOGO": "https://avatars.githubusercontent.com/" + org,
            "REPO_DESCRIPTION": description
        };
        payloadsWrapper.payloads.push(payload);
        payloadsIdsWrapper.payloads.push(org + '/' + repo.name);
        fs.mkdirSync(payloadsFolder + '/cache/' + org, {recursive: true});
        fs.writeFileSync(payloadsFolder + '/cache/' + org + '/' + repo.name, JSON.stringify(payload, null, 2));
    });
    payloadsWrapper.finalPayloads.push({
        "COMMAND": "init-landscape",
        "S3_FOLDER_URI": "s3://sokrates-gallery/" + org,
        "LANDSCAPE_NAME": org
    });
    payloadsIdsWrapper.finalPayloads.push(org);
    fs.writeFileSync(payloadsFolder + '/payloads.json', JSON.stringify(payloadsWrapper, null, 2));
    fs.writeFileSync(payloadsFolder + '/payload_ids.json', JSON.stringify(payloadsIdsWrapper, null, 2));
}

const createScripts = function (org) {
    const reposFile = '/app/analysis-scripts/generated/data/config-repos/' + org + "-active.json";
    if (!fs.existsSync(reposFile)) {
        console.log(reposFile + ' does not exist.');
        return;
    }
    const activeRepos = JSON.parse(fs.readFileSync(reposFile, 'utf8'))
        .filter(repo => notIgnored(org, repo));

    createCloneAndZipScripts(org, activeRepos);
    createAnalysisScripts(org, activeRepos);
    createPayloadsJson(org, activeRepos);
}

const orgs = config.githubOrgs;

orgs.forEach(org => createScripts(org));
