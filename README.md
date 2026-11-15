# PLUS Website Analytics: SQL analysis of Microsoft Clarity data

DRAFT. Only Q4 is complete. Sections marked TODO are not finished.

## Question
PLUS (Personalized Learning Squared) is a nonprofit offering AI-powered tutoring. Its website
(tutors.plus) is meant to serve three audiences equally: tutors, school partners, and funders.
This project asks whether site behavior matches that goal, using Microsoft Clarity data from
Jun 16, 2025 to Jan 1, 2026.

## Data source and its limits
Read this before the findings.

- **The data is aggregate, not row-level.** Clarity exports counts per page element and per
  page, not one row per session. There is no user-level data, and nothing here was generated.
- **Device mix varies.** The click CSVs are PC only. The funnel and some dashboard figures
  cover all devices.
- **The click CSVs are incomplete.** Their element rows sum to 1,514 of the 3,499 total clicks
  in the header (43%), so they cannot be used to compute audience shares. See `sql/02_checks.sql`.
- **Elements are named by CSS selector**, with no human-readable label in the export.
- **Q4's table was transcribed by hand** from a course slide (Clarity Click Area, all devices).
- **"Share of clicks" is not click-through rate.** Clarity's "CTR" in the Area report divides
  by total clicks, not page views (verified in `sql/02_checks.sql`).
- **Bounce rate is approximated** (exit sessions / entry sessions), since Clarity has no native
  bounce rate. TODO: document when Q1 is built.

## How to rebuild
    python3 load.py        # builds plus.db from data/ and sql/01_schema.sql
    sqlite3 plus.db < sql/02_checks.sql

## Findings
- **Q4, CTA split by audience.** Across the six named CTAs (1,247 clicks, Clarity, Jun 16 2025
  to Jan 1 2026, all devices), tutor CTAs received 83% of clicks (1,030) and school CTAs 17%
  (217). The table has no funder CTA, so it cannot show how funders compare.
  Query: `sql/q4_cta_audience_split.sql`
- Q1 to Q3, Q5: TODO

## Proposed experiment (not run)
TODO: one-page plan for the school funnel drop-off.
