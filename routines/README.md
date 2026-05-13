# Cloud Routine Prompts

Paste each `.md` file verbatim into its Claude Code cloud routine. Do NOT paraphrase.

## Cron Schedules (America/Los_Angeles)

| Routine         | File                | Cron              | Time (PT)          |
|-----------------|---------------------|-------------------|--------------------|
| Pre-market      | pre-market.md       | `0 6 * * 1-5`    | 6:00 AM weekdays   |
| Market-open     | market-open.md      | `0 7 * * 1-5`    | 7:00 AM weekdays   |
| Midday          | midday.md           | `0 10 * * 1-5`   | 10:00 AM weekdays  |
| Daily-summary   | daily-summary.md    | `15 13 * * 1-5`  | 1:15 PM weekdays   |
| Weekly-review   | weekly-review.md    | `0 14 * * 5`     | 2:00 PM Fridays    |

## Setup per routine

1. Routines → New Routine
2. Name it (e.g. "Trading bot pre-market")
3. Select your repo, branch: main
4. Add ALL env vars (see env.template)
5. Toggle ON "Allow unrestricted branch pushes"
6. Set cron + timezone: America/Los_Angeles
7. Paste the prompt from the corresponding .md file
8. Save → "Run now" to test
