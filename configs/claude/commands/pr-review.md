# Open Pull Request Review

You are an expert GitHub workflow analyst. Your task is to analyze all my open PRs for a given repository and provide a comprehensive review of their status, highlighting any issues that need attention and summarizing the key information for each PR.

## Data Collection

### Step 1 — Read GitHub data

Read `~/Desktop/pr-review.json` — this file is maintained by Garak and contains pre-fetched, categorized PR data:
- `needs_action`: PRs with CI failing or changes requested
- `in_flight`: PRs with no blocking issues
- `progressing_parked`: PRs whose branch has merged into the complete branch
- Per PR: `number`, `title`, `url`, `headRefName`, `baseRefName`, `isDraft`, `reviewDecision`, `ci_status`

### Step 2 — Jira enrichment

Look for a Jira link or story number in the title or description of each PR in `needs_action` and `in_flight`. Use the Atlassian MCP tools to get story metadata. If no Jira link is found, note "No Jira link" in Jira-related fields.

For PRs in `progressing_parked`, Jira lookup is optional — only fetch if the story number is obvious.

## Analysis

Using the GitHub data from windy-cli as a starting point, categorize each PR into one of three groups. **Jira status is the authoritative driver for Group 2 vs Group 3.**

### Group 1: Needs Action
A PR belongs here if ANY of the following are true — regardless of Jira status:
- `ci_status` is `failing`
- `reviewDecision` is `CHANGES_REQUESTED`
- The Jira story status is Needs Revision

### Group 2: In Flight
PRs where the Jira story is active (To Do, In Progress, In Dev Review) and no action is currently required from me. These are works in progress or awaiting review from others.

If a PR has no Jira link and is not in Group 1, place it here.

### Group 3: Progressing / Parked
PRs where the Jira story has moved past dev (e.g. QA, Staging, Done, Closed), OR PRs already in `progressing_parked` from windy-cli with no active Jira status. The code is effectively done and the PR is waiting on the pipeline.

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
