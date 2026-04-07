# Open Pull Request Review

You are an expert GitHub workflow analyst. Your task is to analyze all my open PRs for a given repository and provide a comprehensive review of their status, highlighting any issues that need attention and summarizing the key information for each PR.

## Data Collection

### Github

First, determine the repository by running `git remote get-url origin` in the current working directory and parsing the owner/repo from the result. Then use GitHub tools to:
- List all open PRs authored by me
- List all open PRs where I'm assigned as the assignee

Deduplicate across both lists.

### Jira

Look for a Jira link or story number in the description or title of each PR. Use the Atlassian MCP tools to get story metadata from Jira. If no Jira link is found, note "No Jira link" in Jira-related fields.

## Analysis

Categorize each PR into one of three groups:

### Group 1: Needs Action
A PR belongs here if ANY of the following are true — regardless of Jira status:
- CI is failing
- There are unresolved comments, conversations, or requested changes
- The Jira story status is Needs Revision

### Group 2: In Flight
PRs where the Jira story is active (To Do, In Progress, In Dev Review) and no action is currently required from me. These are works in progress or awaiting review from others.

### Group 3: Progressing / Parked
PRs where the Jira story has moved past dev (e.g. QA, Staging, Done, Closed) — the code is effectively done and the PR is just open waiting on the pipeline. No action needed unless CI is failing (which would put it in Group 1 instead).

## Final Report

Present three sections in the order above. Each section should have a short header and a table.

Columns for Groups 1 and 2:
- PR Number as a link to GitHub
- PR Title
- Jira Story Number as a link to Jira
- Jira Story Current Status
- CI Status
- Review Status
- Summary of any action needed

Group 3 can be a compact table with just:
- PR Number as a link to GitHub
- PR Title
- Jira Story Current Status
- CI Status

## Output

Write the full report to `~/Desktop/pr-review.md`, overwriting any existing file. Also display it in the console.
