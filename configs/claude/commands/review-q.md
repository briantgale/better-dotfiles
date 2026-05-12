# Code Review Queue

You are an expert code review analyst. Your task is to provide a unified view of my PR landscape — both my own open PRs and incoming review requests.

## Data Source

PR data is stored by `windy-cli` at `~/.windy-cli/<owner>-<repo>.json`. To find the correct file:
1. Run `git remote get-url origin` to get the remote URL
2. Extract `<owner>` and `<repo>` (strip `.git` suffix if present)
3. Read `~/.windy-cli/<owner>-<repo>.json`

Do not make any `gh` or GitHub API calls — all data comes from this file.

The file has this shape:

```json
{
  "repo": "owner/repo",
  "pr_review": {
    "generated_at": "<ISO8601 timestamp>",
    "pull_requests": [...]
  },
  "review_requests": {
    "generated_at": "<ISO8601 timestamp>",
    "pull_requests": [...],
    "recently_merged": [...]
  }
}
```

### `pr_review.pull_requests` fields (my own PRs):
- `number`, `title`, `url`
- `headRefName`, `baseRefName`, `isDraft`
- `reviewDecision` — `"APPROVED"`, `"CHANGES_REQUESTED"`, `"REVIEW_REQUIRED"`, or `null`
- `merge_state` — `"MERGEABLE"`, `"BLOCKED"`, `"UNKNOWN"`
- `ci_status` — `"passing"`, `"failing"`, `"pending"`, or `"none"`
- `reviews` — array of `{author, state}` where state is `"APPROVED"`, `"CHANGES_REQUESTED"`, `"COMMENTED"`
- `state` — `"needs_action"` or `"in_flight"`

### `review_requests.pull_requests` fields (incoming reviews):
- `number`, `title`, `url`, `author`
- `headRefName`, `baseRefName`, `isDraft`
- `ci_status` — `"passing"`, `"failing"`, `"pending"`, or `"none"`
- `pr_created_at`, `my_first_review_at`, `my_last_review_at`
- `needs_attention` — true if I am currently a requested reviewer
- `state` — `"pending"`, `"participating"`, or `"done"`

### `review_requests.recently_merged` fields:
- `number`, `title`, `url`, `author`
- `headRefName`, `baseRefName`
- `pr_created_at`, `merged_at`
- `my_first_review_at`, `my_last_review_at`

---

## Section 1: My Open PRs

### 1a. Needs Action

PRs from `pr_review.pull_requests` where `state == "needs_action"`.

Columns:
- PR Number (link to `url`)
- PR Title
- CI Status
- Review Decision
- Action needed (e.g., "CI failing", "Changes requested by X")

### 1b. In Flight

Remaining PRs from `pr_review.pull_requests` (not needs_action).

Use Jira enrichment: extract the story number from the PR title and use Atlassian MCP tools to get the current story status. Use Jira status to sub-categorize:
- **Active** — story is To Do, In Progress, or In Dev Review
- **Progressing / Parked** — story has moved past dev (QA, Staging, Done, Closed), or the PR branch has merged into a release branch

If no Jira link is found, place in Active.

Columns:
- PR Number (link to `url`)
- PR Title
- Jira Status
- CI Status
- Review Decision

---

## Section 2: Incoming Review Requests

### 2a. Core Clinical (encounters-dev)

PRs from `review_requests.pull_requests` where `state == "pending"` AND `baseRefName == "encounters-dev"`.

### 2b. Other Pending

PRs from `review_requests.pull_requests` where `state == "pending"` AND `baseRefName != "encounters-dev"`.

### 2c. Participating

PRs from `review_requests.pull_requests` where `state == "participating"`.

PRs where `state == "done"` are excluded from the report tables.

Columns for 2a, 2b, 2c:
- PR Number (link to `url`)
- PR Title
- Author
- CI Status
- My Review Status (`Pending`, `Changes Requested`, `Approved`)
- Action needed

---

## Review Log

Maintain a persistent log at `~/Desktop/review-log.csv` tracking 1-business-day review goal progress for Core Clinical (`encounters-dev`) PRs.

### Log Schema

`pr_number, pr_title, author, assigned_date, first_response_date, business_days_to_respond, reviewed, met_goal`

- `assigned_date`: use `pr_created_at` as a proxy
- `first_response_date`: `my_first_review_at`, or blank if not yet reviewed
- `business_days_to_respond`: Mon–Fri days between `assigned_date` and `first_response_date`, or blank
- `reviewed`: `true` if `my_first_review_at` is present, otherwise `false`
- `met_goal`: `true` if `reviewed` is true and `business_days_to_respond` <= 1, otherwise `false`

### Log Update Process

Source PRs for the log come from `review_requests.pull_requests` (all states) and `review_requests.recently_merged`, filtered to **only** those where `baseRefName == "encounters-dev"`.

**CRITICAL: Never add a PR to the log unless its `baseRefName` is exactly `"encounters-dev"`.** PRs targeting `main`, feature branches, or any other base branch do not belong in this log.

**Goal tracking window starts 2026-04-01.** Only add PRs where `pr_created_at` is on or after 2026-04-01. PRs created before that date are excluded from the log even if they target `encounters-dev`.

On each run:
1. For each source PR not already in the log, append a new row (subject to the date and branch filters above)
2. For existing rows where `reviewed` is `false`, check if `my_first_review_at` is now present — if so, update response fields
3. Do not modify rows where `reviewed` is already `true`

### Goal Summary

- Total PRs logged (denominator — all logged PRs, not just reviewed)
- PRs meeting the 1 business day goal
- Percentage = met_goal / total logged (goal is 75%)
- Pass/fail indicator

**The denominator is always total logged PRs.** Unreviewed PRs count against the goal — ignoring a PR should never improve the percentage.

---

## Output

Write the full report to `~/Desktop/review-q.md`, overwriting any existing file. Also display it in the console.
