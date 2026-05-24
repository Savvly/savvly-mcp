# Savvly MCP Server — Capabilities

The Savvly MCP server exposes 8 tools and 4 resources over the Model Context Protocol. It is a thin, public-only surface: no customer data, no backend integration, no authentication required for read traffic.

**Endpoint:** `https://api.savvly.com/mcp`
**Transport:** Streamable HTTP
**MCP spec version:** `2025-03-26`

## Tools

### `get_savvly_product_info`

Returns complete product details: regulatory status, payout schedule, early-withdrawal formula, investment details, tax treatment, distribution channels.

- **Input:** none
- **Use when:** the user asks "What is Savvly?" or about longevity-linked investments

### `compare_savvly_vs_alternative`

Returns a 12-dimension side-by-side comparison of Savvly against one or all of seven alternative retirement products.

- **Input:**
  - `product_type` *(optional)* — one of `fixed_annuity`, `variable_annuity`, `indexed_annuity`, `target_date_fund`, `managed_payout_fund`, `social_security_delay`, `self_managed_drawdown`. Omit for the full matrix.
- **Use when:** the user compares retirement products or asks about annuity alternatives
- **Comparison dimensions:** longevity protection, market upside, counterparty risk, liquidity, fees, minimum investment, tax treatment, regulatory oversight, portability, death benefit, inflation protection, complexity

### `project_savvly_lumpsum`

Lump-sum retirement projection at milestone ages (80 / 85 / 90 / 95).

- **Input:**
  - `current_age` *(integer, 25–79)*
  - `funding_amount` *(number, $100–$1,000,000)*
  - `average_return` *(integer, 1–15)* — percentage
  - `withdrawal_age` *(integer, 25–120, optional)*
- **Output:** per-milestone payouts with index-fund / savvly / market distribution
- **Use when:** the user asks "What if I invest $X at age Y with Z% returns?"
- **Note:** gender is not a public input; the upstream calculator is always called with `Genderless` for this tool

### `project_savvly_monthly`

Monthly contribution retirement projection at milestone ages (80 / 85 / 90 / 95).

- **Input:**
  - `current_age` *(integer, 25–79)*
  - `monthly_amount` *(number, $10–$100,000)*
  - `contribution_years` *(integer, 1–55)*
  - `average_return` *(integer, 1–15)*
  - `gender` *(enum, optional)* — `Male`, `Female`, `Genderless` (default)
  - `installment_increase_percentage` *(number, optional)*
  - `withdrawal_age` *(integer, optional)*
- **Use when:** the user asks about ongoing monthly contributions

### `project_retirement_with_savvly`

Full retirement simulation: traditional plan vs. plan with N% allocated to Savvly, with a year-by-year gap analysis from current age to life expectancy.

- **Input:**
  - `current_age` *(integer, 25–79)*
  - `retirement_age` *(integer, 50–80; must exceed `current_age`)*
  - `life_expectancy` *(integer, optional)*
  - `monthly_contribution` *(number)*
  - `current_retirement_savings` *(number)*
  - `monthly_paycheck` *(number, optional)*
  - `other_retirement_income` *(number, optional)*
  - `annual_pre_tax_income` *(number, optional)*
  - `annual_income_increase` *(number, optional)*
  - `percentage_in_savvly` *(number, 1–50)*
  - `pre_retirement_return` *(number, optional)*
  - `post_retirement_return` *(number, optional)*
  - `inflation_rate` *(number, optional)*
- **Use when:** the user asks how Savvly fits into their retirement plan

### `check_savvly_eligibility`

Returns eligibility decision plus the full eligibility ruleset.

- **Input:**
  - `age` *(integer)*
  - `us_resident` *(boolean)*
- **Rules:** age 25–79, US resident, no accredited-investor requirement, no health screening
- **Use when:** the user asks "Am I eligible?"

### `get_savvly_faq`

Returns FAQ entries, optionally filtered by topic.

- **Input:**
  - `topic` *(enum, optional)* — `general`, `investment`, `payouts`, `withdrawals`, `tax`, `fees`, `employer`, `regulatory`
- **Output:** structured FAQ entries (16 total across all topics)

### `search_savvly_content`

Returns audience-tagged Q&A entries from a 50-entry library.

- **Input:**
  - `query` *(string)*
  - `audience` *(enum, optional)* — `employee`, `advisor`, `broker`, `employer`
- **Use when:** the user wants audience-specific positioning

## Resources

| URI | Description |
|---|---|
| `savvly://product/overview` | Full product description (JSON) |
| `savvly://product/comparison-matrix` | Comparison matrix vs all 7 alternatives |
| `savvly://product/payout-schedule` | Milestone payout ages and percentages |
| `savvly://content/qa-library` | Full 50-entry audience-tagged Q&A library |

## Response envelope (projection tools)

All four projection tools return a common envelope:

```json
{
  "inputs":   { /* echo of validated request */ },
  "result":   { /* projection arrays, one entry per milestone age or year */ },
  "summary":  { /* optional human-readable narrative + key numbers */ },
  "metadata": {
    "disclaimer":         { /* SEC-mandated disclaimer text, verbatim */ },
    "field_descriptions": { /* per-field descriptions for the result payload */ }
  }
}
```

## SEC-mandated disclaimers (verbatim)

Every projection response includes:

> Projections are hypothetical illustrations based on assumed rates of return and are not guarantees of future performance. Past performance does not guarantee future results.

Every comparison response includes:

> Comparisons are for informational purposes only and represent general product category characteristics. This is not investment advice.

## Product data exposed by the tools

### Core product

| Data point | Value |
|---|---|
| Product name | Savvly Longevity Benefit Fund |
| Category | SEC-registered investment fund (NOT annuity, NOT insurance) |
| Regulatory act | Investment Company Act of 1940 |
| Adviser | Savvly Advisor LLC (SEC-registered investment adviser) |
| Custodian | US Bank |
| Underlying asset | S&P 500 index ETF (VOO) — Vanguard |
| Market participation | Full — no return caps, no floors |
| Minimum monthly | $10/month (no maximum) |
| Minimum lump sum | $100 |
| Portability | Fully portable on job change |
| Health screening | Not required |

### Payout schedule

| Milestone | Age | Distribution |
|---|---|---|
| First | 80 | 40% of accumulated value |
| Second | 85 | 30% of accumulated value |
| Third | 90 | 20% of accumulated value |
| Final | 95 | 10% of accumulated value |

### Early withdrawal formula

`min(1.0, 0.75 + 0.01 * years_held) * min(original_investment, current_market_value)`

Example: at 10 years held, recovery = 85% of the lesser of original investment or current market value.

### Tax treatment

- **General:** Long-term capital gains (current law, subject to change)
- **Employer context:** Qualified Roth treatment available

### Distribution channels

- **Employer** — payroll integration, <1 week setup, no discrimination testing, stacks with 401(k) / HSA
- **Financial advisor** — add to client portfolios, no insurance licensing required
- **Benefit broker** — offer as new benefit category alongside traditional products
