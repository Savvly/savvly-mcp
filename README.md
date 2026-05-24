# Savvly MCP Server

[![Validate server.json](https://github.com/Savvly/savvly-mcp/actions/workflows/validate-server-json.yml/badge.svg)](https://github.com/Savvly/savvly-mcp/actions/workflows/validate-server-json.yml)

Public manifest and connection guide for the **Savvly Longevity Benefit Fund** MCP server. Lets AI agents (Claude Desktop, Cursor, Windsurf, VS Code Copilot) discover and call Savvly tools — product info, comparisons, eligibility, and retirement projections — directly from a conversation.

**Hosted endpoint:** `https://api.savvly.com/mcp` (Streamable HTTP, MCP spec `2025-03-26`)
**Local stdio package:** [`@savvly/mcp-server`](https://www.npmjs.com/package/@savvly/mcp-server) on npm
**Registry manifest:** [`server.json`](server.json) (Official MCP Registry v0.1)
**Namespace:** `com.savvly/mcp-server` (DNS-verified on `savvly.com`)

> The Savvly Longevity Benefit is an **SEC-registered investment fund** — not an annuity, not insurance. The MCP server exposes only public product information and computed projections; it carries no Savvly account or customer data.

## What this server does

| Tool | When an agent should call it |
|---|---|
| `get_savvly_product_info` | User asks "What is Savvly?" or about longevity-linked investments |
| `compare_savvly_vs_alternative` | User compares retirement products or asks about annuity alternatives |
| `project_savvly_lumpsum` | User asks "What if I invest $X at age Y?" |
| `project_savvly_monthly` | User asks about ongoing monthly contributions |
| `project_retirement_with_savvly` | User asks how Savvly fits into their retirement plan |
| `check_savvly_eligibility` | User asks "Am I eligible?" |
| `get_savvly_faq` | User has specific questions about fees, taxes, withdrawals |
| `search_savvly_content` | User wants employee / advisor / broker / employer-specific positioning |

Plus 4 resources: `savvly://product/overview`, `savvly://product/comparison-matrix`, `savvly://product/payout-schedule`, `savvly://content/qa-library`.

See [`CAPABILITIES.md`](CAPABILITIES.md) for the full tool catalog with input schemas, ranges, and disclaimers.

## Connect a client

### Claude Desktop (via `mcp-remote` bridge)

`~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) or `%APPDATA%\Claude\claude_desktop_config.json` (Windows):

```json
{
  "mcpServers": {
    "savvly": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://api.savvly.com/mcp"]
    }
  }
}
```

Full file at [`examples/claude-desktop.json`](examples/claude-desktop.json).

### Cursor

`.cursor/mcp.json` in project root or `~/.cursor/mcp.json` globally:

```json
{
  "mcpServers": {
    "savvly": {
      "url": "https://api.savvly.com/mcp"
    }
  }
}
```

Full file at [`examples/cursor.json`](examples/cursor.json).

### Windsurf

`~/.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "savvly": {
      "serverUrl": "https://api.savvly.com/mcp"
    }
  }
}
```

Full file at [`examples/windsurf.json`](examples/windsurf.json).

### Local stdio (process-spawned)

For clients that prefer a child process over a remote URL, install the npm package:

```json
{
  "mcpServers": {
    "savvly": {
      "command": "npx",
      "args": ["-y", "@savvly/mcp-server"]
    }
  }
}
```

## Verify the endpoint with curl

[`examples/curl-handshake.sh`](examples/curl-handshake.sh) is a 7-call pre-flight that walks through `initialize` → `tools/list` → `resources/list` → two tool calls → cleanup. Quick form:

```bash
curl -i -X POST https://api.savvly.com/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2025-03-26",
      "capabilities": {},
      "clientInfo": { "name": "my-app", "version": "1.0.0" }
    }
  }'
# Returns Mcp-Session-Id header — pass it on subsequent requests.
```

## Compliance and security posture

- **No customer PII.** No names, SSNs, emails, or account numbers ever pass through the MCP server.
- **No backend integration.** No database, no internal service calls, no client data store.
- **SEC disclaimers.** Every projection response includes the required hypothetical-illustration disclaimer; every comparison response includes the not-investment-advice disclaimer.
- **Rate limited.** Open endpoints rate-limited per IP. Projection endpoints support an optional API key for higher throughput.
- **Per-call audit logging.** `client_ip`, `user_agent`, and HMAC-SHA256-hashed inputs are recorded for audit; retention follows SEC 17a-4.
- **Input validation.** All numeric inputs validated against documented ranges (see [`CAPABILITIES.md`](CAPABILITIES.md)).

## Companion artifacts

| URL | What it is |
|---|---|
| `https://api.savvly.com/openapi.json` | OpenAPI 3.1 spec with `x-llm-instructions` |
| `https://api.savvly.com/llms.txt` | llms.txt discovery file |
| `https://api.savvly.com/.well-known/ai-plugin.json` | ChatGPT plugin manifest |
| `https://api.savvly.com/.well-known/agent.json` | Savvly-defined agent discovery file |
| `https://api.savvly.com/v1/product/schema` | JSON-LD Schema.org markup |

## License

[Apache-2.0](LICENSE)
