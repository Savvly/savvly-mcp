#!/usr/bin/env bash
# 7-call pre-flight that validates the Savvly MCP endpoint end-to-end:
#   1. initialize  (captures Mcp-Session-Id header)
#   2. notifications/initialized
#   3. tools/list
#   4. resources/list
#   5. tools/call get_savvly_product_info
#   6. tools/call check_savvly_eligibility {age: 45, us_resident: true}
#   7. DELETE /mcp  (session cleanup)
#
# Streamable HTTP keeps the SSE connection open, so every call needs
# --max-time to avoid hanging in scripts / CI.
#
# Usage:  ./curl-handshake.sh [endpoint]
#   default endpoint: https://api.savvly.com/mcp

set -euo pipefail

ENDPOINT="${1:-https://api.savvly.com/mcp}"
ACCEPT='application/json, text/event-stream'

echo "==> 1. initialize"
INIT_RESPONSE=$(curl -s -i --max-time 10 -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "Accept: $ACCEPT" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2025-03-26",
      "capabilities": {},
      "clientInfo": { "name": "savvly-mcp-handshake", "version": "1.0.0" }
    }
  }')

SESSION_ID=$(echo "$INIT_RESPONSE" | grep -i '^mcp-session-id:' | awk '{print $2}' | tr -d '\r\n')
if [[ -z "$SESSION_ID" ]]; then
  echo "FAIL: no Mcp-Session-Id header returned"
  echo "$INIT_RESPONSE"
  exit 1
fi
echo "    session: $SESSION_ID"

call() {
  local label="$1"
  local body="$2"
  echo "==> $label"
  curl -s --max-time 10 -X POST "$ENDPOINT" \
    -H "Content-Type: application/json" \
    -H "Accept: $ACCEPT" \
    -H "Mcp-Session-Id: $SESSION_ID" \
    -d "$body" \
    | head -c 400
  echo
}

call "2. notifications/initialized" '{
  "jsonrpc": "2.0",
  "method": "notifications/initialized"
}'

call "3. tools/list" '{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/list"
}'

call "4. resources/list" '{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "resources/list"
}'

call "5. get_savvly_product_info" '{
  "jsonrpc": "2.0",
  "id": 4,
  "method": "tools/call",
  "params": {
    "name": "get_savvly_product_info",
    "arguments": {}
  }
}'

call "6. check_savvly_eligibility" '{
  "jsonrpc": "2.0",
  "id": 5,
  "method": "tools/call",
  "params": {
    "name": "check_savvly_eligibility",
    "arguments": { "age": 45, "us_resident": true }
  }
}'

echo "==> 7. DELETE /mcp"
curl -s --max-time 10 -X DELETE "$ENDPOINT" \
  -H "Mcp-Session-Id: $SESSION_ID" \
  -o /dev/null -w "    HTTP %{http_code}\n"

echo "Done."
