### About

This project provides a template you can use to analyze, with [Sokrates](https://sokrates.dev), all source code of all repositories in any GitHub organization.

### Create Docket Image

<pre>docker build -t sokrates-landscape .</pre>

### Running

<pre style="white-space: normal">docker run -e AWS_ACCESS_KEY_ID=<ID> -e AWS_SECRET_ACCESS_KEY=<SECRET_KEY> -e SOKRATES_CONFIG=<JSON string of config.json file> sokrates-landscape</pre>

### The Concept

The project analyzes all repositories in given GitHub organizations. For each repository, it creates a detailed project report. It puts all reports in a folder, where you can run `sokrates updateLandscape` command to create a landscape overview of the whole organization (volume, project trends, team topologies...).

### How the Analysis Works?

The analysis works in several steps:

- ***Step 1: discovering active GitHub repositories***
  - the Node.js script **analysis-scripts/github-repos-finder/get-repos.js** connects to the GitHub API and gets the list of all repositories. The script filters the list of repositories by the last push date, ignoring the repositories that have not been updated recently (you can configure the threshold date in **analysis-scripts/config.json**). The script also ignores archived repositories.
  - The script stores filtered lists of repositores as JSON files in **analysis-scripts/generated/data**, to be used by the next step.
- ***Step 2: generating clone, analysis and pull request download Bash scripts***
  - the Node.js script **analysis-scripts/github-repos-finder/generate-sh-scripts.js** takes the lists of repositores from the **analysis-scripts/generated/data** folder and generate three types of scripts in the following folders:
    - **analysis-scripts/generated/clone-scripts**/
      - Bash scripts for cloning and zipping the source code repositories for later analyses.
    - **analysis-scripts/generated/analysis-scripts**/
      - Bash scripts for analyses of stored repositores. 
    - **analysis-scripts/generated/pull-requests-scripts**/
      - Bash scripts for downloading GitHub pull request data, and creating static HTML reports.
- ***Step 3: running the clone scripts***
  - Running the **analysis-scripts/generated/clone-scripts**/ bash scripts that:
    - **clone** repositores
    - **clean** them (e.g., removing typical binaries) 
    - **extract Git history** needed to Sokrates analyses 
    - **delete the .git folder** to save space, 
    - **zips** the cleaned folder
    - **stores the zipped file** in the **analysis-artifacts/archived-repos/** folders
- ***Step 4: running the analysis scripts***
    - Running the **analysis-scripts/generated/analysis-scripts**/ bash scripts that:
    - **take zipped repos** from **analysis-artifacts/archived-repos/** unzip them in a temporary folder 
    - **run sokrates analysis** (**sokrates init** and **sokrates generateReports** commands) 
    - **copies the analysis results** in the **analysis-artifacts/reports/** folders
    - remove the temporary folders
- ***Step 5: copying the reports to an S3 folder***
    - **copies the analysis results** in an S3 folder (s3://sokrate-gallery)
