---
description: Run market-open execution workflow locally
---

Run the market-open execution workflow. Same logic as routines/market-open.md
but using local .env credentials and without the commit/push step.

1. Read today's RESEARCH-LOG entry (if missing, run pre-market first)
2. Re-validate planned trades with fresh quotes
3. Run buy-side gate on each planned order
4. Execute approved buys + place 10% trailing stops
5. Log trades to TRADE-LOG.md
6. ClickUp notification if trades placed
