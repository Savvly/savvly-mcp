# syntax=docker/dockerfile:1
# Savvly MCP server (stdio) — for the Docker MCP Catalog ("Built by Docker").
#
# Docker's registry pipeline (github.com/docker/mcp-registry) clones the PUBLIC
# Savvly/savvly-mcp repo (server.json#repository.url), builds THIS Dockerfile, then
# signs (SBOM + provenance) and hosts the image at mcp/savvly. We install the
# already-published npm package instead of rebuilding from source, so the build
# context is just this one file — no source mirror, no committed bundle blob.
#
# TEMPLATE: the release workflow (publish-mcp-server.yml) syncs a copy of this file
# to Savvly/savvly-mcp with 1.0.26 replaced by the released version, so the
# catalog image is pinned + reproducible. Do not hand-pin a version here.
FROM node:24-slim

LABEL io.modelcontextprotocol.server.name="com.savvly/savvly"
LABEL org.opencontainers.image.source="https://github.com/Savvly/savvly-mcp"
LABEL org.opencontainers.image.description="Savvly MCP server (stdio transport)"
LABEL org.opencontainers.image.licenses="Apache-2.0"

ENV NODE_ENV=production

# Pinned to the released version (filled from the template at release time).
RUN npm install -g @savvly/mcp-server@1.0.26

# Non-root at runtime, mirroring Dockerfile.stdio.
RUN useradd --uid 1001 --shell /bin/false appuser
USER appuser

# stdio transport: no EXPOSE / HEALTHCHECK (no port to probe).
ENTRYPOINT ["savvly-mcp"]
