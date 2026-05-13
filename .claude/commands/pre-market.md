---
description: Run pre-market research workflow locally
---

Run the pre-market research workflow. Same logic as routines/pre-market.md
but using local .env credentials and without the commit/push step.

1. Read memory/TRADING-STRATEGY.md, tail of TRADE-LOG.md, tail of RESEARCH-LOG.md
2. bash scripts/alpaca.sh account && positions && orders
3. Research via WebSearch for: oil, S&P futures, VIX, catalysts, earnings, economic calendar, sector momentum, held tickers
4. Write dated entry to memory/RESEARCH-LOG.md
5. Silent notification unless urgent
