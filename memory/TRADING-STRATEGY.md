# Trading Strategy

## Mission
Beat the S&P 500 over the challenge window. Stocks only — no options, ever.

## Capital & Constraints
- Starting capital: ~$100,000
- Platform: Alpaca
- Instruments: Stocks ONLY
- PDT limit: 3 day trades per 5 rolling days (account < $25k)

## Core Rules
1. NO OPTIONS — ever
2. **60-85% deployed** (floor raised from 75% — see Deployment Escalation)
3. 5-6 positions at a time, max 20% each
4. 10% trailing stop on every position as a real GTC order
5. Cut losers at -7% manually
6. Tighten trail: 7% at +15%, 5% at +20%
7. Never within 3% of current price; never move a stop down
8. Max 3 new trades per week
9. Follow sector momentum
10. Exit a sector after 2 consecutive failed trades
11. Patience > activity — but patience has a hard floor (rules 12-13)
12. Anti-Paralysis Floor: see Deployment Escalation section
13. **Individual stocks required**: at least 2 of 5-6 positions must be
    individual stocks, not ETFs. ETF-only portfolios fail the mission
    (can't beat S&P by owning S&P sectors at 1:1 weight).

## Deployment Escalation (replaces old rule 12)
The bot proved over 3 weeks (11 flat sessions) that discretionary gates
with no forcing function produce 0% deployment in a trending tape.
This escalation ladder ensures capital gets deployed progressively.

### Tier 1 — Normal Entry (conviction ≥ 7)
- Full-size position (15-20% of portfolio)
- Must pass all Entry Checklist items
- Preferred path — use this when the setup exists

### Tier 2 — Starter Entry (conviction ≥ 6.0, Momentum ≥ 7)
- 1/3-size position (~6-7% of portfolio, ~$6-7k)
- Attach 10% trailing-stop GTC at fill
- Scale to full size ONLY on pullback to entry AND conviction ≥ 7
- Max 3 concurrent starters
- **Available anytime** — do NOT wait for a paralysis trigger.
  If a good name in a top-3 sector scores 6.0+ with strong momentum,
  take the starter. The old 6.5/Mom≥8 bar was still too restrictive.

### Tier 3 — Forced Deployment (>3 sessions with <30% deployed)
- If the portfolio has been <30% deployed for 3+ consecutive sessions:
  MUST open at least one new position that session
- Pick the best available from top-3 sectors, minimum score 5.5
- Size: 1/3 starter (~$6-7k) with 10% trailing stop
- Document why the score is below 6.0 if applicable
- This is a HARD rule — no exceptions, no "deploy tomorrow"

### Tier 4 — Emergency Deployment (>5 sessions with <30% deployed)
- Deploy 3 positions at once to reach ≥40% invested
- Use top-3 sector ETFs if no individual stocks qualify
- Each gets 10% trailing stop GTC
- This is a circuit breaker — it should never trigger if Tiers 2-3
  are being used properly

### What these tiers override:
- The ≥7 conviction gate (for starters and forced entries)
- The "wait for ideal pullback" bias
- The ≥2:1 R:R target (for starters only)

### What they do NOT override:
- -7% manual cut, 10% trailing stop, ≤20% max position
- Max 3 new trades per week
- Full ≥7 gate for scaling starters to full size
- Earnings proximity check (no entry day before earnings)

## Promote Starters Aggressively
- A starter that is +5% or more from entry gets promoted to full size
  (add to reach 15-20%) WITHOUT requiring a pullback to entry.
  The old rule (promote only on pullback) guaranteed starters stayed
  small forever in a trending tape.
- A starter at +10% gets trail tightened to 7% (same as rule 6 at +15%,
  but earlier for starters since the position is smaller).

## Individual Stock Selection
The bot has been hiding in ETFs. Individual stocks are required to beat
the benchmark. When screening individual stocks:
1. Start with the top-3 sector ETF holdings — look at the top-5 names
   in each ETF for individual stock ideas
2. Score the individual name, not just the sector
3. Individual stocks with score ≥ 6.5 in a top-3 sector qualify as
   starters — they don't need the full ≥7 gate
4. Preferred: names with upcoming catalysts (earnings beat + guidance
   raise, product launch, regulatory approval, contract win)

## Entry Checklist (Buy-Side Gate — Full Size)
- [ ] Specific catalyst with date/trigger?
- [ ] Sector in momentum (YTD leader)?
- [ ] Stop level defined (7-10% below entry)?
- [ ] Target defined (min 2:1 R:R)?
- [ ] Earnings check: if reporting within 5 days, run earnings preview
      scenario analysis BEFORE entering. Do not buy into uncertainty.
- [ ] Conviction score >= 7/10 (score using fundamental framework below)
- [ ] No more than 2 positions in same sector

## Entry Checklist (Starter — Abbreviated)
- [ ] Top-3 sector? (or strong thematic tailwind)
- [ ] Conviction score >= 6.0?
- [ ] Stop level defined?
- [ ] Not reporting earnings within 3 days?
- [ ] Would not be 3rd position in same sector?

## Fundamental Scoring (per trade idea)
Score each 1-10 before entry. Full-size minimum average 7. Starter minimum 6.0.

| Factor | Question |
|--------|----------|
| Moat | Does it have durable competitive advantage? |
| Valuation | Is it cheap vs. peers and history? |
| Momentum | Is price + sector trend in your favor? |
| Catalyst | Is there a specific near-term trigger? |
| Risk/Reward | Is R:R >= 2:1 with defined stop? |

## Thesis Documentation (mandatory for every position)
When entering a trade, document in TRADE-LOG.md:
- Thesis statement (1 sentence: why this, why now)
- 3 key pillars supporting the trade
- 2-3 risks that would invalidate
- Target exit price and timeline
- What would make you cut early (besides -7% stop)

## Catalyst Awareness
- Track upcoming earnings dates for all held positions
- Track macro events (FOMC, CPI, PPI, jobs) for the week
- Never enter a new position the day before its earnings report
- Flag any held position reporting within 3 days in midday scan

## Idea Generation Framework
When searching for new trades, screen by:
1. Sector momentum leaders (top 3 sectors YTD)
2. **Top holdings within leading sector ETFs** (XLB, XLI, XLE, etc.)
3. Stocks near breakout with volume confirmation
4. Earnings beats with guidance raises (post-earnings drift)
5. Thematic tailwinds (AI, energy, defense, infrastructure, etc.)
6. Avoid: declining revenue, margin compression, insider selling

## Sector & Market Research (weekly)
Every Friday in the weekly review, assess:
- Sector rotation: which sectors are gaining/losing relative strength?
- Competitive dynamics: for held positions, who is gaining share?
- Valuation context: are our names cheap/expensive vs. sector peers?
- Thematic alignment: are the macro trends still supporting our positions?
Use sector overview framework to identify new rotation opportunities.
When a sector drops from top-3 to bottom-3, exit all positions in it.

## Comparable Company Awareness
Before entering any individual stock (not ETF), check:
- How does it trade vs. peers? (P/E, EV/EBITDA relative to sector median)
- Is it a leader or laggard in its competitive set?
- Is it gaining or losing market share?
A stock trading at 2x its sector multiple needs exceptional catalyst justification.

## Performance Accountability
- If the bot underperforms S&P by >5% over any 2-week rolling window,
  the weekly review must diagnose why and propose a concrete fix
- "Waiting for the perfect setup" is not an acceptable diagnosis —
  the deployment escalation exists to prevent this
- The goal is to be IN the market with disciplined risk management,
  not to avoid the market with perfect analysis
