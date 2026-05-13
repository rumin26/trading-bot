---
description: Run midday scan workflow locally
---

Run the midday scan workflow. Same logic as routines/midday.md
but using local .env credentials and without the commit/push step.

1. Read strategy, trade log, today's research
2. Pull positions and orders
3. Cut losers at -7%, cancel their stops
4. Tighten stops on winners (+15% -> 7%, +20% -> 5%)
5. Thesis check — cut broken theses even if not at -7%
6. Optional WebSearch research on sharp movers
7. WhatsApp notification if action taken
