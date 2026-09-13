#!/usr/bin/env bash
# Reusable test script for the s4tobtp CAP service on BTP.
# Usage: source this file, or run individual sections as needed.
#   source test-s4tobtp.sh        # sets env vars + fetches a token
#   ./test-s4tobtp.sh post        # fetch token, then POST a test record
#   ./test-s4tobtp.sh get         # fetch token, then GET all records
#   ./test-s4tobtp.sh get 1000124 # fetch token, then GET one record by VBELN

set -e

# ---------------------------------------------------------------------------
# 1. Credentials (update after any service-key rotation)
# ---------------------------------------------------------------------------
export CLIENT_ID='sb-s4tobtp-f4b744betrial-dev!t703015'
export CLIENT_SECRET='d1fd9be2-28fc-4d8e-8013-b02b8cc42420$ZYudZ1biVyZKNBuLOaxiz9QYN1TNALP7HKkXVh36-2g='
export TOKEN_URL='https://f4b744betrial.authentication.us10.hana.ondemand.com/oauth/token'
export SRV_URL='https://f4b744betrial-dev-s4tobtp-srv.cfapps.us10-001.hana.ondemand.com'

# ---------------------------------------------------------------------------
# 2. Fetch a token
# ---------------------------------------------------------------------------
fetch_token() {
  if command -v jq >/dev/null 2>&1; then
    TOKEN=$(curl -s -X POST "$TOKEN_URL" \
      -d 'grant_type=client_credentials' \
      -d "client_id=$CLIENT_ID" \
      --data-urlencode "client_secret=$CLIENT_SECRET" \
      | jq -r .access_token)
  else
    TOKEN=$(curl -s -X POST "$TOKEN_URL" \
      -d 'grant_type=client_credentials' \
      -d "client_id=$CLIENT_ID" \
      --data-urlencode "client_secret=$CLIENT_SECRET" \
      | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
  fi
  export TOKEN
  echo "Token fetched (first 20 chars): ${TOKEN:0:20}..."
}

# ---------------------------------------------------------------------------
# 3. POST a test record
# ---------------------------------------------------------------------------
post_record() {
  curl -i -X POST "$SRV_URL/odata/v4/legacy-fields/LegacyOrderFields" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"VBELN":"1000124","LegacyFld1":"test2","LegacyFld2":"abc"}'
}

# ---------------------------------------------------------------------------
# 4. GET all records
# ---------------------------------------------------------------------------
get_all() {
  if command -v jq >/dev/null 2>&1; then
    curl -s "$SRV_URL/odata/v4/legacy-fields/LegacyOrderFields" \
      -H "Authorization: Bearer $TOKEN" | jq .
  else
    curl -s "$SRV_URL/odata/v4/legacy-fields/LegacyOrderFields" \
      -H "Authorization: Bearer $TOKEN"
  fi
}

# ---------------------------------------------------------------------------
# 5. GET a single record by key
# ---------------------------------------------------------------------------
get_one() {
  local vbeln="$1"
  if command -v jq >/dev/null 2>&1; then
    curl -s "$SRV_URL/odata/v4/legacy-fields/LegacyOrderFields('$vbeln')" \
      -H "Authorization: Bearer $TOKEN" | jq .
  else
    curl -s "$SRV_URL/odata/v4/legacy-fields/LegacyOrderFields('$vbeln')" \
      -H "Authorization: Bearer $TOKEN"
  fi
}

# ---------------------------------------------------------------------------
# Command dispatch (only runs when executed directly, not when sourced)
# ---------------------------------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  fetch_token
  case "$1" in
    post) post_record ;;
    get)  if [[ -n "$2" ]]; then get_one "$2"; else get_all; fi ;;
    "")   echo "Token ready. Call post_record / get_all / get_one <VBELN> after sourcing this file." ;;
    *)    echo "Unknown command: $1 (use: post | get [VBELN])" ;;
  esac
fi