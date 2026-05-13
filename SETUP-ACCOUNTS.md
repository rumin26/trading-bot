# Account Setup Guide

Follow these steps to get all three services configured. Start with paper trading.

---

## 1. Alpaca (Trading) — Start with Paper

1. Go to **https://alpaca.markets** and click "Sign Up"
2. Complete identity verification (required even for paper trading)
3. Once approved, go to **Paper Trading** in the left sidebar
4. Click **API Keys** → **Generate New Key**
5. Copy both the **API Key ID** and **Secret Key** immediately (secret shown only once)
6. For paper trading, your endpoint is: `https://paper-api.alpaca.markets/v2`
7. Data endpoint stays: `https://data.alpaca.markets/v2`

**Add to your .env:**
```
ALPACA_ENDPOINT=https://paper-api.alpaca.markets/v2
ALPACA_DATA_ENDPOINT=https://data.alpaca.markets/v2
ALPACA_API_KEY=<your key ID>
ALPACA_SECRET_KEY=<your secret key>
```

> When ready for live trading, switch ALPACA_ENDPOINT to `https://api.alpaca.markets/v2`
> and generate new API keys under the Live Trading section.

---

## 2. Perplexity (Research)

1. Go to **https://www.perplexity.ai/settings/api**
2. Sign up / log in
3. Add a payment method (pay-per-use, typically pennies per query)
4. Click **Generate API Key**
5. Copy the key

**Add to your .env:**
```
PERPLEXITY_API_KEY=<your key>
PERPLEXITY_MODEL=sonar
```

---

## 3. ClickUp (Notifications)

1. Go to **https://clickup.com** and create a free account
2. Create a new **Space** (e.g., "Trading Bot")
3. Open the **Chat** view in that space — create a new chat channel (e.g., "Bot Alerts")
4. Get your API key: **Settings** → **Apps** → **API Token** → **Generate**
5. Get your Workspace ID: look at the URL when in ClickUp — it's the number after `/`
6. Get your Channel ID: open the chat channel, check the URL or use the ClickUp API:
   ```
   curl -s -H "Authorization: YOUR_API_KEY" \
     "https://api.clickup.com/api/v3/workspaces/YOUR_WORKSPACE_ID/chat/channels" | python3 -m json.tool
   ```
   The channel ID format is like `4-XXXXXXX-X`

**Add to your .env:**
```
CLICKUP_API_KEY=<your key>
CLICKUP_WORKSPACE_ID=<numeric workspace ID>
CLICKUP_CHANNEL_ID=<channel ID like 4-XXXXXXX-X>
```

---

## Quick Smoke Test

After filling in your `.env`:

```bash
cd trading-bot
bash scripts/alpaca.sh account
```

You should see JSON with your equity, cash, and buying power. If you see an error about keys, double-check your `.env` values.

---

## Checklist

- [ ] Alpaca paper account created + API keys generated
- [ ] Perplexity API key generated
- [ ] ClickUp account + chat channel created + API key + IDs noted
- [ ] All credentials added to local `.env` (copied from `env.template`)
- [ ] `bash scripts/alpaca.sh account` returns valid JSON
- [ ] Repo pushed to a **private** GitHub repo
- [ ] Claude GitHub App installed on the repo
- [ ] First cloud routine (pre-market) created and tested with "Run now"
