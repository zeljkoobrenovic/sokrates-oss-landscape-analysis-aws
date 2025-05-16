const https = require('https');
const fs = require('fs');

const config = JSON.parse(fs.readFileSync('/app/analysis-scripts/config-gitlab.json'));
// const secrets = JSON.parse(fs.readFileSync('/app/analysis-scripts/secrets.json'));

const gitRepoPrefix = 'https://gitlab.com/api/v4';
const startDate = config.reposUpdatedAfter;
console.log(startDate);
// const token = 'token ' + secrets.githubToken;

// const headers = {headers: {'user-agent': 'node.js', 'Authorization': token}};
const headers = {headers: {'user-agent': 'node.js'}};

let reposCount = 0;
let reposCountActive = 0;

const shouldIgnore = function (org, repo) {
    let ignore = false;
    config.ignore.forEach(ignoreRule => {
        if (ignoreRule.org === '' || org.match(new RegExp(ignoreRule.org, 'gi'))) {
            if (ignoreRule.repo === '' || repo.match(new RegExp(ignoreRule.repo, 'gi'))) {
                console.log('Ignoring ' + org + ' / ' + repo);
                ignore = true;
                return;
            }
        }
    });

    return ignore;
}

const saveRepositories = function (org, next) {
    let repos = [];
    const download = function (page) {
        const url = 'https://' + org + '/api/v4/projects?per_page=100&page=' + page;
        console.log(url);
        https.get(url, headers, function (response) {
            let data = '';

            response.on('data', (chunk) => {
                data += chunk;
            });

            response.on('end', () => {
                const reposPage = data ? JSON.parse(data) : [];
                if (reposPage.length > 0) {
                    console.log(reposPage.length);
                    repos = repos.concat(reposPage);
                    console.log(repos.length);

                    const githubRepoDataFolder = '/app/analysis-scripts/generated/data/config-repos/';
                    if (!fs.existsSync(githubRepoDataFolder)) fs.mkdirSync(githubRepoDataFolder, {recursive: true});
                    let mappedData = repos.map(repo => {
                        return {
                            name: repo.name,
                            description: repo.description,
                            html_url: repo.web_url,
                            clone_url: repo.http_url_to_repo,
                            size: 0,
                            archived: repo.archived,
                            language: repo.language,
                            created_at: repo.created_at,
                            updated_at: repo.last_activity_at,
                            pushed_at: '',
                            watchers: []
                        }
                    });

                    const activeData = mappedData
                        .filter(repo => repo.language !== null)
                        .filter(repo => !repo.archived)
                        .filter(repo => repo.updated_at >= startDate)
                        .filter(repo => !shouldIgnore(org, repo.name));

                    console.log(activeData.length);

                    fs.writeFileSync(githubRepoDataFolder + org + '-active.json',
                        JSON.stringify(activeData, null, 2));

                    reposCount += reposPage.length;
                    reposCountActive += reposPage
                        .filter(repo => repo.language !== null)
                        .filter(repo => !repo.archived)
                        .filter(repo => repo.updated_at >= startDate)
                        .filter(repo => !shouldIgnore(org, repo.name)).length;

                    download(page + 1);
                } else {
                    next();
                }
            });
        });
    }
    download(1);
}

const orgs = config.gitlabOrgs;

const callProcessing = function () {
    if (orgs.length > 0) {
        saveRepositories(orgs.pop(), () => {
            callProcessing();
        });
    }
    console.log('\nFound ' + reposCount + ' repositories, ' + reposCountActive);
}

callProcessing();

