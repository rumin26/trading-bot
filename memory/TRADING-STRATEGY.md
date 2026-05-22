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
2. 75-85% deployed
3. 5-6 positions at a time, max 20% each
4. 10% trailing stop on every position as a real GTC order
5. Cut losers at -7% manually
6. Tighten trail: 7% at +15%, 5% at +20%
7. Never within 3% of current price; never move a stop down
8. Max 3 new trades per week
9. Follow sector momentum
10. Exit a sector after 2 consecutive failed trades
11. Patience > activity — but patience has a floor (rule 12)
12. Anti-Paralysis Deployment Floor: never run >5 consecutive 0-new-position
    sessions (see section below)

## Anti-Paralysis Deployment Floor (rule 12)
Added 2026-05-22 after two consecutive fully-uninvested weeks (7 sessions, 0
trades, 0% deployed) in which six straight "deploy tomorrow" commitments failed.
Discretionary entry gates with no forcing function filter out 100% of trades in
a trending tape; this rule is that forcing function.

- **Trigger:** the account has had 5 consecutive trading sessions with no new
  position opened (count resets to 0 the day any new position is opened).
- **Action on the 5th session:** if ANY candidate in a top-3 momentum sector
  scores >= 7 on the fundamental framework, initiate a 1/3-size starter
  (~6-7% of portfolio) AT-MARKET that session — do NOT wait for a textbook
  pullback. Attach a 10% trailing-stop GTC at fill (rule 4).
- **Scaling:** add to full target size (<=20%) only on a pullback to the
  documented entry level. A starter is a foot in the door, not the full bet.
- **Concurrency:** cap starters at 2 open at once.
- **What this OVERRIDES:** only "wait for the ideal pullback entry."
- **What this does NOT override:** the -7% manual cut, the 10% trailing stop,
  the <=20% max position, the >=2:1 R:R target where achievable, the >=7
  conviction-score gate, and the max-3-new-trades-per-week cap. If literally
  zero top-3-sector candidate scores >=7, document why and the floor pauses one
  session — but the default is to act.

## Entry Checklist (Buy-Side Gate)
- [ ] Specific catalyst with date/trigger?
- [ ] Sector in momentum (YTD leader)?
- [ ] Stop level defined (7-10% below entry)?
- [ ] Target defined (min 2:1 R:R)?
- [ ] Earnings check: if reporting within 5 days, run earnings preview
      scenario analysis BEFORE entering. Do not buy into uncertainty.
- [ ] Conviction score >= 7/10 (score using fundamental framework below)
- [ ] No more than 2 positions in same sector

## Fundamental Scoring (per trade idea)
Score each 1-10 before entry. Minimum average 7 to buy.

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
2. Stocks near breakout with volume confirmation
3. Earnings beats with guidance raises (post-earnings drift)
4. Thematic tailwinds (AI, energy, defense, etc.)
5. Avoid: declining revenue, margin compression, insider selling

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
