<!--
  CANONICAL PUBLIC README for the Savvly MCP server.
  Source of truth lives here in savvly-public-api (private); the release workflow
  (.github/workflows/publish-mcp-server.yml) syncs this file — plus server.json and
  LICENSE — to the PUBLIC Savvly/savvly-mcp repo on every production release. Do not
  edit it directly in savvly-mcp; edit here.
-->
# Savvly MCP server — `com.savvly/savvly`

MCP server for the **Savvly Longevity Benefit Fund**: product info, Savvly-vs-alternative
comparisons, eligibility checks, an audience-tagged Q&A library, and retirement /
lump-sum / monthly **projections** (with inline MCP Apps chart widgets).

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

## Configuration

| Env var | Default | Purpose |
| --- | --- | --- |
| `ADVISOR_FUNCTIONS_URL` | `https://savvly-estimator.azurewebsites.net` | Projection backend |
| `ADVISOR_FUNCTIONS_TIMEOUT_MS` | `15000` | Upstream request timeout |

Product / comparison / FAQ / Q&A content is bundled and served offline; projections
call Savvly's hosted estimator.

## Links

- Website: https://savvly.com
- Disclosures: https://www.savvly.com/disclosures

## License

Apache-2.0.

<!-- mcp-name: com.savvly/savvly -->
