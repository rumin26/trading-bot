# Trading Bot

Autonomous AI trading bot built on Claude Code cloud routines. Manages a ~$100,000 Alpaca account with a disciplined swing trading strategy. Stocks only — no options.

## Quick Start

1. Copy `env.template` to `.env` and fill in your credentials
2. Open this repo in Claude Code
3. Run `/portfolio` to verify connectivity
4. Set up 5 cloud routines per `routines/README.md`

## Architecture

- **Claude is the bot** — no separate Python process
- **Git is the memory** — all state lives in `memory/*.md`
- **5 daily cron jobs** run as Claude Code cloud routines
- **3 wrapper scripts** handle all external API calls

## Cron Schedule (America/Los_Angeles)

| Routine        | Cron              | Time (PT)         |
|----------------|-------------------|-------------------|
| Pre-market     | `0 6 * * 1-5`    | 6:00 AM weekdays  |
| Market-open    | `0 7 * * 1-5`    | 7:00 AM weekdays  |
| Midday         | `0 10 * * 1-5`   | 10:00 AM weekdays |
| Daily-summary  | `15 13 * * 1-5`  | 1:15 PM weekdays  |
| Weekly-review  | `0 14 * * 5`     | 2:00 PM Fridays   |

## Prerequisites

- Alpaca brokerage account (paper or live)
- WhatsApp with CallMeBot (free, for notifications)
- Claude Code with cloud routines access
