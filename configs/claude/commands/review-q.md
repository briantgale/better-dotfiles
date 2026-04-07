# Code Review Queue

You are an expert GitHub workflow analyst. Your task is to analyze open pull requests in a given repository where I'm involved as a reviewer, and summarize what needs my attention.

## Performance Rules

- **Prefer `gh` CLI over MCP GitHub tools** — it is significantly faster. Use `gh pr list`, `gh pr view`, `gh api` for all GitHub data.
- **No Jira calls** — do not use Jira at all. Use GitHub data only.
- **Batch where possible** — fetch multiple PRs' data in parallel rather than sequentially.

## Data Collection

### Step 1 — Get the PR list fast

Run in the current working directory:

```bash
git remote get-url origin
```

Parse owner/repo, then use `gh` to get all open PRs where `briantgale` is a requested reviewer:

```bash
gh pr list --repo kipusystems/healthmatters --json number,title,author,baseRefName,reviewRequests,reviews,url,statusCheckRollup --limit 50 | \
  python3 -c "
import json, sys
prs = json.load(sys.stdin)
mine = [p for p in prs if any(r.get('login') == 'briantgale' for r in p.get('reviewRequests', []))]
print(json.dumps(mine, indent=2))
"
```

This gives you title, author, base branch, my review requests, existing reviews, CI status — all in one call.

### Step 2 — Determine my review status per PR

From the `reviews` field in the above output, check if `briantgale` appears as a reviewer with any state (APPROVED, CHANGES_REQUESTED, COMMENTED). This tells you Group 1 vs Group 2 without extra API calls.

### Step 3 — Determine if a PR is "done"

A Group 1 PR should be excluded if the work is already merged to `encounters-core`. To check this, look for a merged PR in the same repo that:
- Targets `encounters-core`
- Has the same head branch name

Do this with:

```bash
gh pr list --repo OWNER/REPO --base encounters-core --state merged --head BRANCH_NAME --json number,mergedAt
```

If a match is found, the PR is considered done and should be excluded from Group 1.

## Analysis

### Group 1: Reviews That Need To Be Done

PRs where I am a requested reviewer, have not yet submitted a review, and the branch has NOT been merged to `encounters-core`.

Split into two sub-tables:

**1a. Core Clinical (encounters-dev)** — PRs targeting the `encounters-dev` branch. Tracked against my goal of providing feedback within 1 business day.

**1b. Other PRs** — All other pending reviews.

### Group 2: Reviews I'm Actively Participating In

PRs where I have already submitted a review or left comments but the PR is still open.

## Final Report

Present tables in this order: Group 1a, Group 1b, Group 2.

Columns for each table:
- PR Number as a link to GitHub
- PR Title
- Author
- CI Status
- My Review Status (Pending, Changes Requested, Approved)
- Summary of any action needed

## Review Log

Maintain a persistent log at `~/Desktop/review-log.csv` to track goal progress over time.

### Log Schema

`pr_number, pr_title, author, assigned_date, first_response_date, business_days_to_respond, reviewed, met_goal`

- `assigned_date`: when I was added as a reviewer
- `first_response_date`: date of my first review submission or comment, or blank if not yet responded
- `business_days_to_respond`: Mon–Fri days between assigned and first response, or blank
- `reviewed`: `true` if I submitted any review or comment, otherwise `false`
- `met_goal`: `true` if `reviewed` is true and `business_days_to_respond` <= 1, otherwise `false`

### Log Update Process

On each run:
1. Query open and recently closed/merged PRs targeting `encounters-dev` where I was a requested reviewer using `gh pr list --state all --base encounters-dev`
2. For each PR not already in the log, append a new row
3. For existing rows where `reviewed` is `false`, check if I've since reviewed — if so, update response fields
4. Do not modify rows where `reviewed` is already `true`

### Goal Summary

- Total reviews logged
- Reviews meeting the 1 business day goal
- Percentage (goal is 75%)
- Pass/fail indicator

## Output

Write the full report to `~/Desktop/review-q.md`, overwriting any existing file. Also display it in the console.
