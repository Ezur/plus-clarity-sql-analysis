-- PLUS tutors.plus Clarity analysis: schema
-- Every table is AGGREGATE data (counts per element/page), not one row per session.
-- Each table says where its numbers came from so a reader can check them.

DROP TABLE IF EXISTS click_report;
DROP TABLE IF EXISTS element_clicks;
DROP TABLE IF EXISTS cta_clicks;

-- One row per exported Clarity click report (the header numbers of each CSV).
CREATE TABLE click_report (
    report_id    TEXT PRIMARY KEY,   -- short name we give the report
    page         TEXT NOT NULL,      -- page the report covers
    device       TEXT NOT NULL,
    page_views   INTEGER NOT NULL,   -- from the CSV header
    total_clicks INTEGER NOT NULL    -- from the CSV header
);

-- One row per page element in a click report (Clarity names elements by CSS selector).
CREATE TABLE element_clicks (
    report_id   TEXT NOT NULL REFERENCES click_report(report_id),
    rank        INTEGER NOT NULL,
    selector    TEXT NOT NULL,       -- raw CSS selector; no human label in the export
    clicks      INTEGER NOT NULL,
    pct_clicks  REAL NOT NULL        -- as exported by Clarity (share of total clicks)
);

-- Human-readable CTA clicks, transcribed by hand from Assignment 1, Q4 slide.
-- Source on the slide: Clarity Heatmap & Click Area, all devices, Jun 16 2025 - Jan 1 2026.
CREATE TABLE cta_clicks (
    cta       TEXT PRIMARY KEY,
    audience  TEXT NOT NULL CHECK (audience IN ('tutor','school')),
    clicks    INTEGER NOT NULL
);
