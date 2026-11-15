-- TIE-OUT CHECKS: run these before trusting anything.

-- Check 1: do the exported rows add up to the header's total clicks?
-- A gap means Clarity listed only part of the elements, or the export cut rows off.
SELECT r.report_id,
       r.total_clicks            AS header_total,
       SUM(e.clicks)             AS sum_of_rows,
       r.total_clicks - SUM(e.clicks) AS gap
FROM click_report r
JOIN element_clicks e USING (report_id)
GROUP BY r.report_id;

-- Check 2: what does Clarity's pct_clicks divide by? Recompute it two ways for the top row.
-- If the exported value matches share_of_clicks, the divisor is total clicks (not page views).
SELECT r.report_id,
       e.clicks,
       e.pct_clicks                                   AS exported_pct,
       ROUND(100.0 * e.clicks / r.total_clicks, 2)    AS share_of_clicks,
       ROUND(100.0 * e.clicks / r.page_views, 2)      AS share_of_page_views
FROM click_report r
JOIN element_clicks e USING (report_id)
WHERE e.rank = 1;
