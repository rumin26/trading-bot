---
description: Run Friday weekly review workflow locally
---

Run the weekly review workflow. Same logic as routines/weekly-review.md
but using local .env credentials and without the commit/push step.

1. Read full week of trade/research logs + strategy doc
2. Pull Friday close state
3. Compute week metrics, S&P comparison, W/L/open, win rate, profit factor
4. Append full review to WEEKLY-REVIEW.md
5. Update TRADING-STRATEGY.md if rules need changing
6. Send WhatsApp summary
