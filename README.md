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

This MCP server is public and unauthenticated — it exposes Savvly product information, comparisons, eligibility, and illustrative projections, and requires no account or credentials. It identifies no user. Its own logs record only a keyed hash of a caller's network address, and Savvly's edge (Azure Front Door) masks the address in its logs. Log rows written before that began (2026-10-11 for this server's logs, 2026-10-12 for the edge's) keep the address until they expire, 90 days after they were written.

The hosted endpoint (`https://api.savvly.com/mcp`) sends **no** call data to any third-party analytics service. For each call, Savvly's own logs record the tool, a keyed hash of its inputs, a keyed hash of the caller's network address, and the caller's User-Agent header.

The installed packages (`npx @savvly/mcp-server`, the `.mcpb` bundle, the Docker image, `savvly-mcp-server` on PyPI and `Savvly.McpServer` on NuGet) keep no log of their own. They send Savvly a usage record for each tool call, in small batches, to `https://api.savvly.com/usage/v1`. A record holds only:

- the tool's name;
- whether the call succeeded, and for a failure a fixed reason code (such as `tool_arguments_refused` or `estimator_unreachable`);
- how long the call took, in milliseconds;
- the name your MCP host reports for itself (such as `claude-ai` or `cursor`);
- the package's language and version.

It never holds the tool's arguments, a hash of them, the result, an error's text, or anything else you or your AI assistant typed. Savvly's logs record each record like a hosted call: with a keyed hash of the sending network address and the User-Agent header, never the address itself. Sending happens in the background: it never slows or fails a tool call, and a record that cannot be sent is dropped. To turn it off, set `SAVVLY_TELEMETRY=0` or `DO_NOT_TRACK=1` in the server's own `env` settings in your MCP host (for Docker, `docker run -e SAVVLY_TELEMETRY=0`); in Claude Desktop's `.mcpb` extension, switch off **Send usage records** in the extension's settings. A variable set only in your shell often does not reach the server: MCP hosts start a stdio server with a few variables (such as `PATH` and `HOME`) plus its own `env` settings, and an app started from the Dock or Start menu never sees your shell's variables.

## License

Apache-2.0.

<!-- mcp-name: com.savvly/savvly -->
