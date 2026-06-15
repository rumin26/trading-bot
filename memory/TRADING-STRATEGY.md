# Trading Strategy

> 1. **A regime-conditioned participation FLOOR**, filled by a benchmark proxy,
>    so the *neutral* position is the benchmark — not cash. Cash above the floor
>    requires a written, dated bearish thesis, not an accretion of vetoes.
> 2. **A quantitative, falsifiable, auto-expiring regime filter** — "rebound"
>    can no longer be invoked indefinitely.
> 3. **A trend/momentum entry path** that does not require a dated catalyst,
>    reconciling the gate with the strategy's own 30% momentum weight.
> 4. **An anti-paralysis recalibration trigger** — N idle sessions in a
>    permitting regime forces a diagnosis, not another identical HOLD.
> 5. **A macro-veto scope fix** — prints pause *fresh single-name risk* in the
>    session before them only; they never unwind the benchmark floor.
> 6. **An operational exception halt** — an unexplained position/cash change
>    stops the loop and escalates, instead of becoming the new baseline.
>
> See **Appendix A** for the full rationale and sources.

---

## 1. Mission

Generate risk-adjusted returns that beat the S&P 500 total-return index over the
challenge window. Stocks and ETFs only — no options, ever; no crypto.

**The benchmark is 100% invested. That fact is structural, not incidental.**
Holding cash is therefore not a neutral act: relative to the benchmark, every
dollar in cash is an active short on the equity market. The correct *default*
exposure for a book measured against the S&P is the S&P itself (held via a broad
proxy), with alpha expressed by tilting *away* from it into researched names.
Going to cash is a deliberate bearish decision that must be defended in writing
(Section 10.1) — never a residue left behind when nothing clears the gate.

---

## 2. Operating Account & Mechanical Constraints

The strategy executes in a single account. These constraints are structural and
bound everything below.

- **Cash account, long-only.** No margin, no leverage, no short selling. Every
  buy must be covered by *settled* cash at the time of purchase.
- **T+1 settlement.** Proceeds from a sale settle one business day after the
  trade. Unsettled proceeds cannot fund a new purchase without risking a
  **good-faith violation**, and buying-then-selling before paying with settled
  funds risks a **freeriding violation** (Reg T). The natural cadence is
  position/swing trading, *not* intraday recycling of capital.
- **Pattern Day Trader rule does not apply.** PDT is a margin-account concept;
  this is a cash account. FINRA eliminated the $25,000 PDT minimum effective
  4 June 2026 in any case. The binding constraint is settlement, above.
- **Capital.** Sizing rules below are expressed as percentages of current
  account equity (E).
- **Instrument whitelist.** Common stocks and ETFs only. No options, futures,
  crypto, or leveraged/inverse ETFs. **One broad-market ETF (the "benchmark
  proxy", e.g. an S&P 500 / total-market fund) is designated for floor
  participation under Section 4.1a.**

---

## 3. Portfolio Construction

| Parameter | Rule |
|-----------|------|
| Core alpha positions | 5–6 names when fully deployed |
| Max single position | 20% of E (concentration cap) |
| Max per sector | 2 positions |
| Individual-stock floor | ≥ 2 of the held *alpha* names must be single stocks, not ETFs |
| Benchmark proxy | Held to satisfy the participation floor (Section 4.1a); not counted against the alpha-name caps above |
| Gross exposure | Regime-conditioned **floor and target** (Section 4.1) |

**Two layers, one book.** The book has a *core* layer (the benchmark proxy,
satisfying the participation floor and capturing market beta) and an *alpha*
layer (5–6 researched single names + sector ETFs that tilt the book away from
the index). As single names qualify, they are funded by trimming the proxy —
rotating beta into alpha. As names exit or are stopped, proceeds return to the
proxy, not to idle cash, unless a bearish thesis is on file.

**Why the individual-stock floor exists.** A book of sector ETFs at index weight
*is* the index minus fees. Alpha requires single-name selection. The alpha layer
must always carry at least two researched individual names whenever it holds
anything at all.

---

## 4. Deployment Logic

Deployment answers two independent questions every session: **(a) what gross
exposure does the regime require (floor) and allow (ceiling), and (b) which
alpha setups qualify?** The proxy fills any gap between the floor and what the
qualifying alpha names consume. Capital is never deployed *or withheld* because
time has passed.

### 4.1 Market Regime Filter — quantitative, falsifiable, auto-expiring

Classify the regime from the S&P 500 each session using hard thresholds. Where
inputs conflict, take the **more cautious** classification.

| Regime | Conditions (all-of unless noted) | Gross floor | Gross ceiling |
|--------|----------------------------------|:-----------:|:-------------:|
| **Risk-on** | SPX > 200-DMA **and** > 50-DMA; VIX < 18; breadth (% of S&P above 200-DMA) ≥ 50% | **60%** | 85% |
| **Neutral** | SPX > 200-DMA, but not all risk-on conditions met (VIX 18–26, or price near 50-DMA, or breadth 40–50%) | **30%** | 60% |
| **Risk-off / crash-guard** | SPX < 200-DMA, **OR** VIX > 26, **OR** the crash-guard-rebound trigger below is active | **0%** | 30% |

**Crash-guard-rebound trigger (precise definition).** Active only when *both*:
(i) the SPX fell **≥ 5% peak-to-trough within the last 10 trading sessions**,
*and* (ii) **VIX > 26** at the time of assessment. This is the panic-tail state
Daniel & Moskowitz identify as the home of momentum crashes — high volatility,
contemporaneous with a rebound off a sharp decline.

**Auto-expiry (kills the indefinite-rebound excuse).** The crash-guard-rebound
trigger **lifts automatically** once VIX closes **< 22 for two consecutive
sessions**, regardless of the prior decline. After expiry the regime reverts to
whatever the price/breadth table dictates. A "rebound" may not be cited as a
reason to stay flat once volatility has demonstrably normalized.

> *Calibration note vs. the v2.0 logs:* a −1.6% day with VIX ~19–21 and SPX above
> both moving averages is **Neutral**, not crash-guard. Under v2.1 that regime
> carries a 30% floor — the benchmark proxy would have been held, not cash.

### 4.1a Participation Floor (the core counterweight)

The book's gross exposure **must meet the regime floor** in Section 4.1 at every
EOD, satisfied by the benchmark proxy if qualifying alpha names do not yet fill
it. Holding gross exposure *below the floor* is permitted **only** when a current,
dated **bearish thesis** is recorded in the research log (Section 10.1) with an
explicit invalidation level. Absent that written thesis, the proxy is bought to
the floor — mechanically, not discretionarily.

The macro calendar (Section 9) does **not** override the floor: you are measured
against an index that itself sits through every print, so baseline index
participation is never paused for a scheduled release. Only *fresh single-name
risk* is paused pre-print (Section 9).

### 4.2 Entry Trigger — alpha layer

Within the regime ceiling, an alpha position is opened **whenever, and only
when**, a candidate clears an Entry Gate (Section 6), portfolio risk budget
remains (Section 5), and the portfolio is not in a de-risk state (Section 8).

- **If a name clears the gate and budget exists, the bot MUST act.** Hesitation
  in the presence of a qualifying, budgeted setup is a process failure flagged
  in the weekly review.
- **If no name clears the gate, the floor is held via the proxy — not cash.**
  "Nothing qualified" is information about the *alpha* layer; it is never a
  reason to drop below the regime floor (Section 4.1a).

### 4.3 Turnover Cap

Maximum **3 new alpha positions opened per rolling 7-day window.** A brake on
overtrading, not a quota — there is no minimum. Buying/trimming the benchmark
proxy to maintain the floor does **not** count against this cap.

### 4.4 Anti-Paralysis Recalibration Trigger (the missing counterweight)

If the regime is **Neutral or Risk-on** and **3 consecutive sessions** produce
**zero alpha-gate clears**, the next session must run a **recalibration audit**
before logging another HOLD. The audit explicitly tests whether the *process*,
not the market, is the blocker:

1. **Score calibration:** are conviction scores clustering just below threshold
   (e.g. a run of 6.0–6.9)? A persistent sub-threshold cluster in a rising tape
   is a calibration red flag, not evidence the market is uninvestable.
2. **Catalyst-path coherence:** is the dated-catalyst requirement (Section 6.2)
   wrongly being applied to trend/momentum candidates that should be judged on
   the trend path (Section 6.1)?
3. **Screen breadth:** has the idea-generation screen (Section 11) actually been
   run across all leading sectors, or only re-checked the same one name?

The audit resolves in exactly one of two ways, both recorded:
- **(a)** A name that in fact clears a gate is identified and deployed; or
- **(b)** A specific, defensible reason the *entire* qualifying universe is
  uninvestable is written down — at which point the benchmark floor still
  stands, so the book is never below the regime floor regardless.

This does **not** force a low-conviction single-name trade (the v1.0 error). It
forces a *diagnosis*, and guarantees benchmark participation in the meantime.

---

## 5. Risk Budgeting & Position Sizing (alpha layer)

Sizing is risk-based, not notional-based. Each alpha position is sized so that
being stopped out costs a fixed, known fraction of equity.

**Definitions**

- `R` = risk per trade = **0.75% of E** (full) / **0.40% of E** (starter).
- `ATR` = 14-day Average True Range of the candidate (Wilder).
- Initial stop distance = `min(2.5 × ATR, 8% of entry price)`.

**Position size**

```
Shares = (R × E) / (initial stop distance in $)
Dollar size = Shares × entry price
```

Then apply two caps, taking the smaller:
1. **Concentration cap:** dollar size ≤ 20% of E.
2. **Settled-cash cap:** dollar size ≤ available settled cash.

**Portfolio open-risk cap.** The sum of `R` across all open *alpha* positions must
not exceed **5% of E** — roughly 5–7 full positions, consistent with the 5–6
target.

**Benchmark proxy is exempt from per-name risk budgeting.** The proxy is index
beta held to satisfy the participation floor, not a stop-managed single bet. It
carries no `R` allocation and no GTC stop (Section 8); it is managed by the
regime floor/ceiling (Section 4.1) and trimmed to fund qualifying alpha names. It
*does* count toward gross exposure.

---

## 6. Entry Gates — alpha layer

A candidate is scored on Section 7, then must clear the checklist for **one of
two entry paths**. The earnings veto is a hard veto on both paths.

> **Why two paths.** v2.0 required a "specific, dated catalyst" *and* vetoed
> entry within 5 days of earnings — yet earnings are the most common dated
> catalyst, and trend-following (30% of the conviction weight) needs no discrete
> catalyst at all. The result was that clean momentum leaders were perpetually
> disqualified for "no dated catalyst." v2.1 splits the gate so a confirmed trend
> in a leading sector is sufficient on its own.

### 6.1 Path A — Trend / Momentum entry (no dated catalyst required)

For names whose thesis *is* the trend. The confirmed trend plus relative-strength
leadership **is** the trigger.

- [ ] **Confirmed uptrend:** price > 50-DMA > 200-DMA, **or** a fresh breakout to
      an N-week high on above-average volume
- [ ] Candidate's sector is a current relative-strength leader (top-3 YTD)
- [ ] Conviction score ≥ **7.0** (full) / ≥ **6.0** (starter). For this path the
      *Catalyst* factor is scored on **trend quality** — freshness, slope, and
      strength of the breakout and the sector's RS (Section 7)
- [ ] Initial stop defined per Section 5; reward-to-risk ≥ 2:1 to a defined target
- [ ] **Earnings veto:** not reporting within 5 trading days (full) / 3 (starter)
- [ ] Would not become a 3rd position in the same sector
- [ ] Portfolio open-risk budget available (Section 5)

### 6.2 Path B — Event / Catalyst entry

For event-driven setups built around a discrete, dated trigger.

- [ ] **Specific, dated catalyst** (deal close, product launch, index inclusion,
      guidance event, etc.) — *not* an earnings report inside the veto window
- [ ] Conviction score ≥ **7.0** (full) / ≥ **6.0** (starter)
- [ ] Sector in top-3 RS, or a clearly identified thematic tailwind
- [ ] Initial stop defined per Section 5; R:R ≥ 2:1 to a defined target
- [ ] **Earnings veto:** not reporting within 5 trading days (full) / 3 (starter)
- [ ] Would not become a 3rd position in the same sector
- [ ] Portfolio open-risk budget available

### 6.3 Starter sizing & limits (both paths)

A starter is a deliberately smaller position (`R` = 0.40% of E, ~6–8% notional),
score ≥ 6.0, max **3 concurrent starters**. Available whenever it qualifies — not
gated on the passage of time.

### 6.4 Promoting a Starter to Full Size

Promote (up to full size / the 20% cap) when **either**:
1. It is **+5% or more** from average entry and its sector remains a leader, **or**
2. It pulls back toward entry **and** its conviction score now reads ≥ 7.0.

Promotion requires open-risk budget; added shares are sized per Section 5 against
the *current* price and ATR.

---

## 7. Conviction Scoring

Score each factor 1–10, take the **weighted** average. **Full ≥ 7.0; starter ≥ 6.0.**

| Factor | Weight | Question |
|--------|:------:|----------|
| Momentum | 30% | Is price trend *and* sector relative strength in our favor? |
| Catalyst | 25% | **Path A:** how fresh/strong is the trend signal? **Path B:** is there a specific, near-term, dated trigger? |
| Risk/Reward | 20% | Is R:R ≥ 2:1 to a defensible target with a defined stop? |
| Moat | 15% | Durable competitive advantage / pricing power? |
| Valuation | 10% | Reasonable vs. peers and own history given the growth? |

**Scoring discipline & anti-gaming.** Score the *individual name* against the
absolute rubric, not relative to whatever threshold would force a decision. The
score is recorded *before* entry in `TRADE-LOG.md`. There is no "document why the
score is below threshold and buy anyway." Conversely, a **persistent cluster of
scores 6.0–6.9 across multiple sessions in a Neutral/Risk-on regime** is a
calibration failure to be caught by Section 4.4 and the weekly review — not a
neutral observation about the market.

### 7.1 Comparable-Company Check (single stocks only)

Before any individual-stock entry, sanity-check relative value: P/E and EV/EBITDA
vs. the sector median, and share gain/loss vs. peers. A large unexplained premium
(~2× the sector multiple) requires an exceptional, specific catalyst — note it in
the thesis or pass.

---

## 8. Exits & Stop Management (alpha layer)

Every *alpha* position carries a **live GTC stop order** from the moment it is
filled. (The benchmark proxy does not — Section 5.)

- **Initial stop:** `entry − min(2.5 × ATR, 8%)`, placed at entry.
- **Trailing rule (chandelier-style):** stop ratchets to
  `highest close since entry − (k × ATR)`. Moves **up** only, never down; never
  placed within 3% of current price.
- **Tightening schedule** (reduce `k` as the gain matures):
  - **+15%** unrealized → `k = 2.0`
  - **+20%** unrealized → `k = 1.5`
  - starters tighten one step earlier (at +10%)
- **No separate fixed-percent cut.** The ATR stop (capped at the 8% initial loss)
  is the single authoritative downside mechanism.

**Proceeds routing.** When an alpha position is closed or stopped, proceeds (once
settled) return to the **benchmark proxy** to maintain the regime floor — not to
idle cash — unless a dated bearish thesis is on file (Section 10.1).

### 8.1 Thesis-Invalidation Exit

Independent of price, exit if the *reason you bought* breaks: catalyst fails or is
cancelled, guidance is cut, competitive position deteriorates, or the sector
thesis reverses. Document the trigger at entry (Section 10) so the exit is
mechanical.

### 8.2 Sector-Rotation Exit

- Exit a sector after **2 consecutive failed trades** in it.
- When a sector falls from top-3 to bottom-3 by relative strength, exit all alpha
  positions in that sector.

---

## 9. Portfolio-Level Risk Controls

Individual stops protect single positions; these protect the *book*.

- **Drawdown circuit breaker.** If equity falls **12% from its high-water mark**,
  halt new *alpha* entries, tighten every trailing stop by one `k` step, and
  reduce gross exposure toward the **neutral** band (the proxy floor still
  applies). Resume normal entries only after equity recovers above the
  −8%-from-high level *and* the regime is no longer risk-off.
- **Factor/correlation awareness.** Treat the 5–6 alpha names as correlated
  momentum exposure. The 2-per-sector cap is necessary but not sufficient; avoid
  stacking names that are effectively the same trade.
- **Momentum crash guard.** In the crash-guard-rebound regime (Section 4.1), do
  not add *alpha* exposure. (The proxy floor in that regime is 0%, so the book
  may be fully de-risked — but only when the regime is *quantitatively*
  risk-off, not on a discretionary "feels like a bounce" call.)
- **Macro calendar — scoped veto.** Pause *initiating fresh single-name risk*
  in the **single trading session immediately before** a scheduled FOMC, CPI,
  PPI, or jobs print. This veto:
  - applies to **new alpha entries only** — never to the benchmark proxy floor
    (you are measured against an index that takes the print);
  - lasts **one session**, not a week — a cluster of prints does not compound
    into a multi-session block of the floor;
  - lifts at the open of the session *after* the print.
- **Earnings calendar.** Track earnings for all alpha holdings; flag any
  reporting within 3 days. Never *open* a position inside the earnings veto
  window (Section 6).

---

## 10. Thesis Documentation (mandatory per alpha position)

Record in `TRADE-LOG.md` at entry:

1. **Entry path** (A trend / B catalyst) and **thesis** — one sentence.
2. **Three pillars** supporting the trade.
3. **Two–three invalidators** — what would prove it wrong.
4. **Conviction score** with the per-factor breakdown (Section 7).
5. **Levels** — entry, initial stop, target, resulting R:R.
6. **Early-exit trigger** — the thesis-invalidation condition (Section 8.1).

No alpha position is opened without this record.

### 10.1 Bearish-Thesis Documentation (mandatory to hold cash below the floor)

To carry gross exposure *below the regime floor* (Section 4.1a), record in
`RESEARCH-LOG.md`:

1. **Bearish thesis** — one sentence: why the market itself is a sell here.
2. **Evidence** — the specific signals (breadth, trend break, vol regime).
3. **Invalidation level** — the price/VIX/date at which the proxy floor is
   restored.
4. **Review date** — when the thesis is re-tested.

Absent this record, the proxy is bought to the floor. "Nothing in the alpha
layer qualified" is **not** a bearish thesis and never justifies sub-floor cash.

---

## 11. Idea Generation

Screen, in order of preference:

1. Relative-strength sector leaders (top-3 YTD), then the top-5 single names
   *within* each leading sector as individual-stock candidates.
2. Stocks breaking out on volume confirmation (Path A candidates).
3. Dated event setups: deal closes, launches, index inclusions (Path B).
4. Post-earnings drift: beats with guidance raises (outside the earnings veto).
5. Thematic tailwinds (AI, energy, defense, infrastructure, etc.).
6. **Avoid:** declining revenue, margin compression, insider selling, names at
   large unexplained premiums to peers.

Score the *name*, not the theme. A good theme with a mediocre single-name score
is, at most, a starter — or an ETF expression.

---

## 12. Weekly Review (every Friday)

Assess and record:

- **Regime & rotation:** which sectors gained/lost RS; current regime and the
  floor/ceiling it implies.
- **Process audit (key check):** (i) were there setups that *cleared a gate but
  were not taken*? → process failure. (ii) Did the book sit **below the regime
  floor** without a written bearish thesis on any session? → control failure,
  diagnose it. (iii) Did conviction scores **cluster 6.0–6.9** in a permitting
  regime? → calibration failure (Section 4.4).
- **Floor adherence:** confirm gross exposure met the regime floor every session,
  or that a dated bearish thesis covered each exception.
- **Held-position health:** thesis intact? catalyst pending? stops current?
- **Valuation drift:** any names now expensive vs. peers on the thesis?

---

## 13. Performance Accountability

- **Evaluation window.** Judge vs. the S&P 500 over a **rolling 60-trading-day
  (≈ quarter) window.** A concentrated book has high tracking error; ±5% over two
  weeks is noise.
- **Underperformance trigger.** If the strategy trails the benchmark by more than
  the window's expected tracking error over a full quarter, the review must
  propose a concrete, *rule-level* fix.
- **Acceptable vs. unacceptable diagnoses.** "We skipped qualifying setups" →
  actionable. "We sat below the regime floor with no bearish thesis through a
  rally" → **a control failure, not acceptable** (this is the v2.0 cash-drag, now
  prohibited by Section 4.1a). "We held the benchmark floor but our alpha names
  lagged" → examined; may indicate a screen-calibration issue.
- **Anti-overfitting principle.** Do not re-architect on small samples. Rule
  changes require a stated hypothesis and, where feasible, evidence.

---

## 14. Operational Controls & Exception Handling

The bot manages a **live** account. State changes it did not originate are
control events, not market data.

- **Reconciliation each session.** Compare live Alpaca positions/orders/cash
  against the expected state implied by the bot's own last logged orders.
- **Exception halt.** If positions, orders, or cash changed **without a
  corresponding bot-originated, logged order** (e.g. an external/manual flatten):
  1. **HALT** — open no new positions and modify no orders;
  2. send one alert (`scripts/notify.sh`) naming the discrepancy;
  3. write a dated **exception entry** in `TRADE-LOG.md`;
  4. **do not adopt the changed state as the new baseline** — remain halted until
     the owner confirms/reconciles, then resume per the strategy.

  An unexplained change is never silently absorbed into the status quo, and a
  reconciliation question is never carried forward unanswered across sessions.

---

## Appendix A — Rationale & Grounding

**Why v1.0's Escalation Ladder was removed (retained from v2.0).** It forced
deployment after a fixed number of idle sessions and lowered the conviction floor
over time (7 → 6 → 5.5), eventually mandating a purchase regardless of setup
quality — guaranteeing deployment into weak setups in exactly the choppy/topping
tapes where cash (or the benchmark) is the right posture.

**Why v2.0 still failed, and what v2.1 fixes.** v2.0 deleted the forcing function
but added nothing to counterbalance three serially-stacked vetoes (regime,
conviction gate, macro calendar). With `P(trade) = P(regime) × P(gate) ×
P(no veto)` and each factor frequently near 0, the product was ≈ 0: the book sat
100% cash for a full week while the S&P set record highs (+1.6%), and every HOLD
was "defended" by whichever veto was active. v2.1's six counterweights
(participation floor, quantitative/auto-expiring regime, dual entry paths,
anti-paralysis trigger, scoped macro veto, exception halt) break the ratchet
without reinstating forced single-name trades.

**Why the neutral position is the benchmark, not cash.** The mandate is to *beat*
a 100%-invested index. Relative to that index, cash is a short. The only coherent
default for a benchmark-relative book is to hold the benchmark and express alpha
as tilts away from it; cash then becomes an explicit, defended bearish bet
(Section 10.1), as it should be.

**Why the regime filter is now quantitative and auto-expiring.** v2.0's
"sharp decline followed by a high-volatility rebound" had no defined magnitude,
lookback, or exit, so it could be — and was — invoked indefinitely, and applied
to a −1.6% day at VIX ~19. The momentum-crash literature is about *genuine* panic
tails (high VIX, sharp drawdown), so v2.1 gates crash-guard on a ≥5%/10-session
drawdown *and* VIX > 26, and auto-lifts it once VIX closes < 22 for two sessions.

**Why stops and sizing stay ATR-based (retained).** Fixed-percent stops misfit
volatility; ATR scales to each name and yields smaller dollar size for more
volatile names at constant portfolio risk. The 8% cap preserves a hard worst case.

**Why the momentum crash guard exists (retained).** Daniel & Moskowitz show
momentum's largest, most persistent drawdowns cluster in panic states — after
declines, in high volatility, contemporaneous with rebounds — because the
strategy behaves like a short call option there.

**Why PDT language was corrected (retained).** Cash account → PDT (a
margin-account rule) does not apply; FINRA eliminated the $25k minimum effective
4 June 2026 regardless. The real constraint is T+1 settlement and cash-account
violations (good-faith, freeriding, cash-liquidation).

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
