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

## 3. WhatsApp Notifications (via CallMeBot — free)

1. Save **+34 644 71 86 55** to your WhatsApp contacts (name it "CallMeBot")
2. Send this exact message to that number: **I allow callmebot to send me messages**
3. You'll receive a reply with your **API key**
4. Your phone number with country code (no + or spaces) is your WHATSAPP_PHONE
   - Example: India +91 98765 43210 → `919876543210`

**Add to your .env:**
```
WHATSAPP_PHONE=919876543210
WHATSAPP_API_KEY=<the key CallMeBot sent you>
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
- [ ] WhatsApp CallMeBot activated + API key received
- [ ] All credentials added to local `.env` (copied from `env.template`)
- [ ] `bash scripts/alpaca.sh account` returns valid JSON
- [ ] Repo pushed to a **private** GitHub repo
- [ ] Claude GitHub App installed on the repo
- [ ] First cloud routine (pre-market) created and tested with "Run now"
