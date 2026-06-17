# savvly-mcp — repository contents

The PUBLIC face of the Savvly MCP server (`com.savvly/savvly`). Most files
here are GENERATED on each release by `scripts/gen-public-repo-assets.ts` in
the private `savvly-public-api` repo. Do not edit generated files here; change
the source and re-release. This map is rendered from the same script, so it
stays in lockstep with the actual files.

| Path | Managed | Purpose | Depended on by |
| --- | --- | --- | --- |
| `server.json` | generated | MCP Registry server manifest (5 package types + remote endpoint); the .mcpb fileSha256 is injected at publish. | MCP Registry (com.savvly/savvly), mcp.so, Glama, Docker MCP Catalog |
| `README.md` | generated | Public README (mirror of public/README.md in savvly-public-api). | GitHub repo page, ghcr image page, Glama / mcp.so / Smithery listings |
| `LICENSE` | generated | Apache-2.0 license text. | all distributions |
| `.mcp.json` | generated | Claude Code plugin MCP config: remote Streamable HTTP to api.savvly.com/mcp. | the Claude plugin (auto-discovered at the plugin root) |
| `.claude-plugin/marketplace.json` | generated | Single-plugin Claude marketplace; lists the savvly plugin at source "./". | /plugin marketplace add Savvly/savvly-mcp; the community plugin directory |
| `.claude-plugin/plugin.json` | generated | Claude Code plugin manifest (name, version, rich description, author). | /plugin install savvly@savvly |
| `CONTENTS.md` | generated | This file: the repo map, rendered from PUBLIC_REPO_INVENTORY. | maintainers / readers |
| `logo.png` | manual | 400x400 brand logo, committed directly (NOT generated). | Docker MCP Catalog icon, all directory submission forms, the API /logo.png |
| `assets/screenshots/` | manual | MCP App UI promotional screenshots (4 PNGs), committed directly (NOT generated). | Anthropic + OpenAI submission forms, Cline submission #1738 |

**generated** = overwritten every release (edit in savvly-public-api).  
**manual** = committed directly to this repo; the sync never writes or removes it.

