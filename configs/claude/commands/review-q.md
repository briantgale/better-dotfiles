# Code Review Queue

You are an expert code review analyst. Your task is to analyze my open pull request review queue and summarize what needs my attention.

## Data Source

All PR data comes from `~/Desktop/review-requests.json`, written by `windy-cli review-requests`. Read that file — do not make any `gh` or GitHub API calls.

The file has this shape:

```json
{
  "generated_at": "<ISO8601 timestamp>",
  "repo": "owner/repo",
  "pending": [...],
  "participating": [...],
  "done": [...],
  "recently_merged": [...]
}
```

**Open PR fields** (`pending`, `participating`, `done`):
- `number`, `title`, `url`, `author`
- `headRefName`, `baseRefName`, `isDraft`
- `ci_status` — `"passing"`, `"failing"`, `"pending"`, or `"none"`
- `pr_created_at`, `my_first_review_at`, `my_last_review_at`
- `needs_attention` — true if I am currently a requested reviewer

**Merged PR fields** (`recently_merged`):
- `number`, `title`, `url`, `author`
- `headRefName`, `baseRefName`
- `pr_created_at`, `merged_at`
- `my_first_review_at`, `my_last_review_at`

## Grouping

- **Group 1** (needs action): PRs in `pending` — I have not yet submitted a review
- **Group 2** (participating): PRs in `participating` — I have submitted a review and am still a requested reviewer
- PRs in `done` are excluded from the report tables

Split Group 1 into two sub-tables:
- **1a. Core Clinical** — PRs where `baseRefName == "encounters-dev"`
- **1b. Other PRs** — all other pending PRs

## Report Tables

Present tables in order: Group 1a, Group 1b, Group 2.

Columns:
- PR Number (as a link to `url`)
- PR Title
- Author
- CI Status
- My Review Status (`Pending`, `Changes Requested`, `Approved`)
- Action needed

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

Source PRs for the log come from:
- `pending` and `participating` where `baseRefName == "encounters-dev"`
- `recently_merged` where `baseRefName == "encounters-dev"`

On each run:
1. For each source PR not already in the log, append a new row
2. For existing rows where `reviewed` is `false`, check if `my_first_review_at` is now present — if so, update response fields
3. Do not modify rows where `reviewed` is already `true`

### Goal Summary

- Total reviews logged
- Reviews meeting the 1 business day goal
- Percentage (goal is 75%)
- Pass/fail indicator

## Output

Write the full report to `~/Desktop/review-q.md`, overwriting any existing file. Also display it in the console.
