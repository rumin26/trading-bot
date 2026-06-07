# Trading Strategy

> **Version 2.0 — institutional rewrite.** This document replaces the prior
> "Deployment Escalation" framework. The core change: capital is deployed as a
> function of *opportunity and market regime*, never as a function of elapsed
> time. The forcing functions that mandated buying after N idle sessions have
> been removed and replaced with a mechanical, signal-driven entry rule plus
> portfolio-level risk controls. See **Appendix A** for the rationale and the
> sources this document is grounded in.

---

## 1. Mission

Generate risk-adjusted returns that beat the S&P 500 total-return index over the
challenge window. Stocks only — no options, ever; no crypto. The benchmark is
fully invested, so any cash we hold is a deliberate, defended decision, not a
default.

---

## 2. Operating Account & Mechanical Constraints

The strategy executes in a single account. These constraints are structural and bound everything below.

- **Cash account, long-only.** No margin, no leverage, no short selling. Every
  buy must be covered by *settled* cash at the time of purchase.
- **T+1 settlement.** Proceeds from a sale settle one business day after the
  trade. Unsettled proceeds cannot fund a new purchase without risking a
  **good-faith violation**, and buying-then-selling before paying with settled
  funds risks a **freeriding violation** (prohibited under Reg T). This makes the
  natural cadence position/swing trading, *not* intraday recycling of capital.
- **Pattern Day Trader rule does not apply.** PDT is a margin-account concept;
  this is a cash account. Separately, FINRA eliminated the $25,000 PDT minimum
  effective 4 June 2026, replacing it with intraday-margin standards for *margin*
  accounts — irrelevant here. The binding constraint is settlement, above, not
  PDT.
- **Capital.** Strategy is capital-agnostic; sizing rules below are expressed as
  percentages of current account equity (E). The account must be funded before
  any entry — an empty account deploys nothing.
- **Instrument whitelist.** Common stocks and ETFs only. No options, futures,
  crypto, or leveraged/inverse ETFs.

---

## 3. Portfolio Construction

| Parameter | Rule |
|-----------|------|
| Core positions | 5–6 names when fully deployed |
| Max single position | 20% of E (concentration cap) |
| Max per sector | 2 positions |
| Individual-stock floor | ≥ 2 of the held names must be single stocks, not ETFs |
| Gross exposure | Regime-conditioned target (Section 4) — not a fixed floor |

**Why the individual-stock floor exists.** A book of sector ETFs held at index
weight cannot, by construction, beat the index — it *is* the index minus fees.
Alpha requires single-name selection. ETFs are permitted as liquid expressions
of a sector view or as a temporary holding while a single-name thesis is built,
but the book must always carry at least two researched individual names.

---

## 4. Deployment Logic (replaces the Escalation Ladder)

Deployment is governed by two independent questions asked every session:
**(a) what does the market regime allow, and (b) what setups actually qualify?**
Capital is never deployed because time has passed.

### 4.1 Market Regime Filter (sets the *ceiling*)

Assess the regime from the S&P 500 (or a broad proxy) before any entry:

- **Risk-on** — index above its 200-day moving average, broad participation,
  volatility subdued. → Gross-exposure *target* 60–85%.
- **Neutral** — index near its 200-day MA, mixed breadth, or rising volatility.
  → Gross-exposure *target* 30–60%.
- **Risk-off / crash-guard** — index below 200-day MA, or a sharp decline
  followed by a high-volatility rebound. → Gross-exposure *target* ≤ 30%; new
  entries paused; manage existing positions only.

The risk-off rebound case is deliberate: momentum strategies suffer their worst,
most persistent drawdowns precisely in "panic" states — after a market decline,
when volatility is high, contemporaneous with the rebound (Daniel & Moskowitz,
*Momentum Crashes*). We will not chase strength into that environment.

### 4.2 Entry Trigger (decides whether to *act*)

Within the regime ceiling, a position is opened **whenever, and only when**, a
candidate passes the Entry Gate (Section 6) *and* portfolio risk budget remains
(Section 5) *and* the portfolio is not in a de-risk state (Section 8).

This dissolves the old paralysis problem without forcing bad trades:

- **If a name passes the gate and budget exists, the bot MUST act.** "Waiting
  for a better setup" is not permitted — hesitation in the presence of a
  qualifying, budgeted setup is a process failure flagged in the weekly review.
- **If no name passes the gate, holding cash is the correct outcome** — not a
  failure, and never a reason to buy something sub-threshold. There is no rule
  anywhere in this document that forces a purchase below the conviction gate.

The distinction the old ladder missed: *skipping a qualifying setup* is the error
to prevent; *finding no qualifying setup* is information, and the right response
to it is patience, not a forced trade.

### 4.3 Turnover Cap

Maximum **3 new positions opened per rolling 7-day window.** This is a brake on
overtrading, not a quota — there is no minimum.

---

## 5. Risk Budgeting & Position Sizing

Sizing is risk-based, not notional-based. Each position is sized so that being
stopped out costs a fixed, known fraction of equity — and more volatile names
therefore get *smaller* dollar allocations.

**Definitions**

- `R` = risk per trade = **0.75% of E** (full position) / **0.40% of E**
  (starter). This is the dollars lost if the initial stop is hit.
- `ATR` = 14-day Average True Range of the candidate (Wilder).
- Initial stop distance = `min(2.5 × ATR, 8% of entry price)`. The ATR term
  adapts the stop to each name's volatility; the 8% cap is a hard catastrophe
  backstop so a high-volatility name can never carry an oversized stop.

**Position size**

```
Shares = (R × E) / (initial stop distance in $)
Dollar size = Shares × entry price
```

Then apply two caps, taking the smaller:
1. **Concentration cap:** dollar size ≤ 20% of E.
2. **Settled-cash cap:** dollar size ≤ available settled cash.

**Portfolio open-risk cap.** The sum of `R` across all open positions must not
exceed **5% of E**. This single rule governs how many positions can coexist:
roughly 5–7 full positions, consistent with the 5–6 target, and it prevents the
book from quietly accumulating more total risk than intended.

This framework intentionally unifies the stop and the size — the same ATR figure
that places the stop also determines the share count — eliminating the prior
redundancy between a "10% trailing stop" and a separate "-7% manual cut."

---

## 6. Entry Gates

A candidate is scored on the framework in Section 7, then must clear the
checklist for its tier. Earnings proximity is a hard veto in both tiers.

### 6.1 Full Position — Gate

- [ ] Conviction score ≥ **7.0 / 10**
- [ ] Specific, dated catalyst or clearly defined trigger
- [ ] Candidate's sector is a current relative-strength leader (top-3 YTD)
- [ ] Initial stop defined per Section 5; reward-to-risk ≥ 2:1 to a defined target
- [ ] **Earnings veto:** not reporting within 5 trading days; if it is, run a
      pre-earnings scenario analysis and do not enter into binary uncertainty
- [ ] Would not become a 3rd position in the same sector
- [ ] Portfolio open-risk budget available (Section 5)

### 6.2 Starter Position — Gate

A starter is a deliberately smaller, lower-conviction position (`R` = 0.40% of E,
~6–8% notional). It is **available whenever it qualifies** — not gated on any
paralysis trigger, and not gated on the passage of time.

- [ ] Conviction score ≥ **6.0 / 10**
- [ ] Sector in top-3 by relative strength, or a clearly identified thematic tailwind
- [ ] Initial stop defined per Section 5
- [ ] **Earnings veto:** not reporting within 3 trading days
- [ ] Would not become a 3rd position in the same sector
- [ ] Max **3 concurrent starters**
- [ ] Portfolio open-risk budget available

### 6.3 Promoting a Starter to Full Size

A starter is promoted (added to, up to full size and the 20% cap) when **either**:
1. It is **+5% or more** from the average entry and its sector remains a leader, **or**
2. It pulls back toward entry **and** its conviction score now reads ≥ 7.0.

Promotion still requires open-risk budget. The added shares are sized by the same
risk formula in Section 5 against the *current* price and ATR.

---

## 7. Conviction Scoring

Score each factor 1–10, then take the **weighted** average. Factors are weighted
because they are not equally informative and they sometimes conflict (a strong
momentum name is rarely statistically cheap); equal-weighting them produces mushy
mid-scores. **Full-size threshold ≥ 7.0; starter threshold ≥ 6.0.**

| Factor | Weight | Question |
|--------|:------:|----------|
| Momentum | 30% | Is price trend *and* sector relative strength in our favor? |
| Catalyst | 25% | Is there a specific, near-term, identifiable trigger? |
| Risk/Reward | 20% | Is R:R ≥ 2:1 to a defensible target with a defined stop? |
| Moat | 15% | Durable competitive advantage / pricing power? |
| Valuation | 10% | Reasonable vs. peers and own history given the growth? |

**Scoring discipline.** Score the *individual name*, not just its sector. The
score must be recorded *before* entry in `TRADE-LOG.md`. There is no provision to
"document why the score is below threshold and buy anyway" — a sub-threshold
score means no trade.

### 7.1 Comparable-Company Check (single stocks only)

Before any individual-stock entry, sanity-check relative value: P/E and
EV/EBITDA vs. the sector median, and whether the company is gaining or losing
share against its peer set. A name trading at a large premium to its peers
(e.g., ~2× the sector multiple) requires an exceptional, specific catalyst to
justify — note it explicitly in the thesis or pass.

---

## 8. Exits & Stop Management

Every position carries a **live GTC stop order** from the moment it is filled.

- **Initial stop:** placed at entry per Section 5
  (`entry − min(2.5 × ATR, 8%)`).
- **Trailing rule (chandelier-style):** the stop ratchets to
  `highest close since entry − (k × ATR)`. It only ever moves **up**, never down,
  and is never placed within 3% of the current price.
- **Tightening schedule** (reduce `k` as the gain matures):
  - at **+15%** unrealized: tighten to `k = 2.0`
  - at **+20%** unrealized: tighten to `k = 1.5`
  - starters tighten one step earlier (at +10%), since the position is smaller
    and the goal is to lock the asymmetry.
- **No separate fixed-percent cut.** The ATR stop (capped at the 8% initial loss)
  is the single, authoritative downside mechanism. This removes the old
  redundancy where a -7% manual cut pre-empted the 10% trailing stop.

### 8.1 Thesis-Invalidation Exit

Independent of price, exit if the *reason you bought* breaks: the catalyst fails
or is cancelled, guidance is cut, the competitive position deteriorates, or the
sector thesis reverses. Document the trigger when entering (Section 10) so the
exit is mechanical, not emotional.

### 8.2 Sector-Rotation Exit

- Exit a sector after **2 consecutive failed trades** in it.
- When a sector falls from the top-3 to the bottom-3 by relative strength, exit
  all positions in that sector.

---

## 9. Portfolio-Level Risk Controls

Individual stops protect single positions; these protect the *book*, because a
momentum book of 5–6 leaders is effectively one concentrated factor bet and its
stops tend to fire together in a drawdown.

- **Drawdown circuit breaker.** If account equity falls **12% from its
  high-water mark**, halt all new entries, tighten every trailing stop by one
  `k` step, and reduce gross exposure toward the neutral band. Resume normal
  entries only after equity recovers above the −8%-from-high level *and* the
  regime filter is no longer risk-off.
- **Factor/correlation awareness.** Treat the 5–6 names as correlated momentum
  exposure, not independent bets. The 2-per-sector cap is necessary but not
  sufficient; avoid stacking names that are effectively the same trade (same
  theme, same beta profile) even across different sectors.
- **Momentum crash guard.** In the risk-off rebound regime (Section 4.1), do not
  add exposure — this is the single environment most associated with momentum
  crashes.
- **Earnings calendar.** Track earnings dates for all holdings; flag any position
  reporting within 3 days in the daily scan. Never *open* a position the day
  before its report (Section 6 vetoes).
- **Macro calendar.** Track FOMC, CPI, PPI, and jobs releases for the week and
  avoid initiating fresh risk into the print.

---

## 10. Thesis Documentation (mandatory per position)

Record in `TRADE-LOG.md` at entry:

1. **Thesis** — one sentence: why this name, why now.
2. **Three pillars** supporting the trade.
3. **Two–three invalidators** — what would prove the thesis wrong.
4. **Conviction score** with the per-factor breakdown (Section 7).
5. **Levels** — entry, initial stop, target, and resulting R:R.
6. **Early-exit trigger** — the thesis-invalidation condition (Section 8.1).

No position is opened without this record.

---

## 11. Idea Generation

Screen, in order of preference:

1. Relative-strength sector leaders (top-3 YTD), then the top-5 single names
   *within* each leading sector's ETF as individual-stock candidates.
2. Stocks breaking out on volume confirmation.
3. Post-earnings drift: beats accompanied by guidance raises.
4. Thematic tailwinds (AI, energy, defense, infrastructure, etc.).
5. **Avoid:** declining revenue, margin compression, insider selling, names
   trading at large unexplained premiums to peers.

Score the *name*, not the theme. A good theme with a mediocre single-name score
is, at most, a starter — or an ETF expression.

---

## 12. Weekly Review (every Friday)

Assess and record:

- **Regime & rotation:** which sectors gained/lost relative strength; current
  regime classification and the gross-exposure target it implies.
- **Process audit (the key check):** were there setups that *passed the Entry
  Gate but were not taken*? If yes → process failure, diagnose it. If deployment
  was low because *nothing qualified*, that is acceptable and is recorded as
  such. This is how paralysis is policed without forcing trades.
- **Held-position health:** thesis still intact? catalyst still pending?
  competitive position holding? stop levels current?
- **Valuation drift:** are any names now expensive vs. peers on the thesis?

---

## 13. Performance Accountability

- **Evaluation window.** Judge performance vs. the S&P 500 over a **rolling
  60-trading-day (≈ quarter) window**, not a 2-week window. A concentrated 5–6
  name book has high tracking error; ±5% deviations over two weeks are statistical
  noise, and reacting to them would just curve-fit the strategy to recent luck.
- **Underperformance trigger.** If the strategy trails the benchmark by more than
  the rolling window's expected tracking error over a full quarter, the review
  must diagnose the cause and propose a concrete, *rule-level* fix — not a
  one-off discretionary override.
- **Acceptable vs. unacceptable diagnoses.** "We skipped qualifying setups" is
  actionable (tighten execution). "Nothing qualified and we held cash through a
  rally" is examined but is not automatically a fault — it may mean the regime
  filter or relative-strength screen needs recalibration, which is a deliberate,
  tested change, not a forced-deployment patch.
- **Anti-overfitting principle.** Do not re-architect the strategy on small
  samples (a few weeks / a handful of sessions). Rule changes require a stated
  hypothesis and, where feasible, evidence — not a reaction to the last losing
  streak.

---

## Appendix A — Rationale & Grounding

**Why the Escalation Ladder was removed.** The prior framework forced deployment
after a fixed number of idle sessions and lowered the conviction floor over time
(7 → 6 → 5.5), eventually mandating a purchase regardless of setup quality. This
inverts sound risk management: the environments in which a quality-gated process
finds nothing to buy are typically the choppy or topping tapes where cash is the
correct position. A time-based forcing function guarantees deployment into weak
setups in exactly those conditions, and it contradicted the document's own stated
preference for patience over activity. The replacement (Section 4) keeps the
useful half of the original intent — *don't skip qualifying setups out of
hesitation* — while discarding the harmful half — *don't manufacture trades when
nothing qualifies.*

**Why thresholds now reconcile.** The old document set a 60% deployment floor yet
defined escalation triggers around <30% deployment and a ≥40% target — mutually
inconsistent numbers. Here, gross exposure is a regime-conditioned *target range*,
not an absolute floor, so "low deployment in a weak regime" is consistent with the
rules rather than a violation of them.

**Why stops and sizing are ATR-based.** Fixed-percent stops apply one width to
every name regardless of its volatility — too tight on a high-beta name, too loose
on a low-beta one. ATR-based stops (Wilder) scale to each name's actual volatility,
and the risk-based sizing formula derived from them gives more volatile names
smaller dollar allocations for the same portfolio risk. The 8% cap preserves a
hard worst-case loss per position.

**Why the momentum crash guard exists.** Daniel & Moskowitz show momentum's
largest, most persistent drawdowns ("momentum crashes") cluster in panic states —
after market declines, in high volatility, contemporaneous with rebounds — because
the strategy behaves like a short call option in those rebounds. The risk-off
rebound regime in Section 4.1 and the crash guard in Section 9 are the direct
response.

**Why PDT language was corrected.** The strategy runs in a cash account, where PDT
(a margin-account rule) does not apply; and FINRA eliminated the $25,000 PDT
minimum effective 4 June 2026 in any case. The real mechanical constraint is T+1
settlement and the cash-account violations (good-faith, freeriding, cash
liquidation) that limit recycling unsettled proceeds.

### Sources

- FINRA, *Regulatory Notice 26-10* — elimination of the $25k PDT minimum / new
  intraday-margin standards (effective 4 June 2026):
  https://www.finra.org/rules-guidance/notices/26-10
- Charles Schwab, *SEC Approves Scrapping $25,000 Day Trader Minimum*:
  https://www.schwab.com/learn/story/sec-approves-scrapping-25000-day-trader-minimum
- Fidelity, *Avoiding Cash Account Trading Violations* (good-faith / freeriding /
  cash-liquidation, T+1):
  https://www.fidelity.com/learning-center/trading-investing/trading/avoiding-cash-trading-violations
- Kent Daniel & Tobias Moskowitz, *Momentum Crashes* (NBER WP 20439):
  https://www.nber.org/system/files/working_papers/w20439/w20439.pdf
- Charles Schwab, *The Average True Range Indicator and Volatility*:
  https://www.schwab.com/learn/story/average-true-range-indicator-and-volatility

---
