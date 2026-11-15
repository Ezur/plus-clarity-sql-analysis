-- Q4: Are users clicking the CTAs for all three audiences, or mostly tutors?
-- Table used: cta_clicks (6 named CTAs, hand-transcribed from the Assignment 1 Q4 slide).
-- No funder CTA is in this table, so this query compares tutor vs school only.

SELECT
    audience,
    SUM(clicks)                                           AS cta_clicks,   -- top number
    (SELECT SUM(clicks) FROM cta_clicks)                  AS all_cta_clicks, -- bottom number
    ROUND(100.0 * SUM(clicks)
          / (SELECT SUM(clicks) FROM cta_clicks), 1)      AS pct_of_cta_clicks
FROM cta_clicks
GROUP BY audience
ORDER BY cta_clicks DESC;

-- Finding: Across the six named CTAs (1,247 clicks, Clarity, Jun 16 2025 to Jan 1 2026,
-- all devices), tutor CTAs received 83% of clicks (1,030) and school CTAs 17% (217).
-- This table has no funder CTA, so it cannot show how funders compare.
--
-- Note: the Assignment 1 slide says "78% tutor" and "~2% school". Those do not tie out to
-- this table; they likely use a different denominator that the slide does not state.
