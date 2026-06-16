<!--
  CANONICAL PUBLIC README for the Savvly MCP server.
  Source of truth lives here in savvly-public-api (private); the release workflow
  (.github/workflows/publish-mcp-server.yml) syncs this file — plus server.json and
  LICENSE — to the PUBLIC Savvly/savvly-mcp repo on every production release. Do not
  edit it directly in savvly-mcp; edit here.
-->
# Savvly MCP server — `com.savvly/savvly`

Savvly offers longevity-linked, SEC-registered investment products — built on the Savvly 80+ fund — that invests pooled contributions in a low-cost S&P 500 ETF and makes milestone cash payouts at ages 80, 85, 90, and 95, turning a longer life into a financial reward rather than a risk.

Savvly MCP lets financial advisors, planning tools, and AI agents query fund data, model projections, and compare against alternative retirement products directly, in real time, in any conversation, and without any manual lookup.

Listed on the [MCP Registry](https://registry.modelcontextprotocol.io) as
`com.savvly/savvly` and published to **five package types plus a hosted remote** — use
whichever fits your client.

## Install

| Channel | Command / config |
| --- | --- |
| **Remote (hosted)** | `https://api.savvly.com/mcp` (streamable-http) |
| **npm** | `npx @savvly/mcp-server` |
| **PyPI** | `uvx savvly-mcp-server` |
| **NuGet** | `dnx Savvly.McpServer` (or `dotnet tool install -g Savvly.McpServer`) |
| **Docker / OCI** | `docker run -i --rm ghcr.io/savvly/savvly-mcp-server` |
| **MCPB** | download the `.mcpb` from [Releases](https://github.com/Savvly/savvly-mcp/releases) and open it in an MCPB-capable host |

### Claude Desktop / Cursor / Windsurf (stdio)

```json
{
  "mcpServers": {
    "savvly": { "command": "npx", "args": ["@savvly/mcp-server"] }
  }
}
```
Swap `command`/`args` for `uvx savvly-mcp-server`, `dnx Savvly.McpServer`, or
`docker run -i --rm ghcr.io/savvly/savvly-mcp-server` as you prefer. Hosts that support
remote MCP can point straight at `https://api.savvly.com/mcp`.

## Tools

- `get_savvly_product_info` — full product overview
- `compare_savvly_vs_alternative` — Savvly vs annuities, target-date funds, etc.
- `check_savvly_eligibility` — age / residency / channel eligibility
- `get_savvly_faq` — FAQ by topic
- `search_savvly_content` — audience-tagged Q&A library
- `project_savvly_lumpsum` / `project_savvly_monthly` — payout projections (milestone ages)
- `project_retirement_with_savvly` — full retirement trajectory with vs. without Savvly

Projection tools emit interactive MCP Apps chart widgets on hosts that support them.

## Links

- Website: https://savvly.com
- Disclosures: https://www.savvly.com/disclosures

## Privacy Policy

Savvly's privacy policy: https://www.savvly.com/privacy-policy

This MCP server is public and unauthenticated — it exposes Savvly product information, comparisons, eligibility, and illustrative projections, and requires no account or credentials. It collects **no personal information** and **no end-user identifier** (no client IP is captured; no user is identified).

The hosted endpoint (`https://api.savvly.com/mcp`) records **anonymous usage analytics** via [MCPcat](https://mcpcat.io), a third-party processor, to improve the tools — which tools are called and their non-identifying numeric scenario inputs (e.g. age, contribution amount). Email, phone, SSN, and payment-card patterns are redacted from any text before it is sent. The local `npx @savvly/mcp-server` (stdio) sends **no** analytics.

## License

Apache-2.0.

<!-- mcp-name: com.savvly/savvly -->
