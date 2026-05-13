#!/usr/bin/env bash
# Notification wrapper. Sends to WhatsApp via CallMeBot API.
# Usage: bash scripts/notify.sh "<message>"
# If credentials are unset, appends to a local fallback file.
#
# Setup: https://www.callmebot.com/blog/free-api-whatsapp-messages/
# 1. Add +34 644 71 86 55 to your WhatsApp contacts
# 2. Send "I allow callmebot to send me messages" to that number
# 3. You'll get an API key — set WHATSAPP_API_KEY in your env
# 4. Set WHATSAPP_PHONE to your number with country code (e.g. 919876543210)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/.env"
FALLBACK="$ROOT/DAILY-SUMMARY.md"

if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi

if [[ $# -gt 0 ]]; then
  msg="$*"
else
  msg="$(cat)"
fi

if [[ -z "${msg// /}" ]]; then
  echo "usage: bash scripts/notify.sh \"<message>\"" >&2
  exit 1
fi

stamp="$(date '+%Y-%m-%d %H:%M %Z')"

if [[ -z "${WHATSAPP_PHONE:-}" || -z "${WHATSAPP_API_KEY:-}" ]]; then
  printf "\n---\n## %s (fallback — WhatsApp not configured)\n%s\n" "$stamp" "$msg" >> "$FALLBACK"
  echo "[whatsapp fallback] appended to DAILY-SUMMARY.md"
  echo "$msg"
  exit 0
fi

# URL-encode the message
encoded="$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$msg")"

curl -fsS -X GET \
  "https://api.callmebot.com/whatsapp.php?phone=${WHATSAPP_PHONE}&text=${encoded}&apikey=${WHATSAPP_API_KEY}"
echo
