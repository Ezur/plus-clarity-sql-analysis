"""Build plus.db from the Clarity CSV exports plus the hand-transcribed CTA table."""
import csv
import sqlite3
from pathlib import Path

ROOT = Path(__file__).parent
DB = ROOT / "plus.db"

REPORTS = {
    "homepage_pc":        ("data/homepage_clicks_pc.csv",        "/",                          "PC"),
    "become_a_tutor_pc":  ("data/become_a_tutor_clicks_pc.csv",  "/get-involved/become-a-tutor", "PC"),
}

# Transcribed by hand from the Assignment 1 Q4 slide (bar chart values).
CTA_CLICKS = [
    ("Apply now",         "tutor",  752),
    ("Become a Tutor",    "tutor",  192),
    ("Tutor with us",     "tutor",   86),
    ("Try our demo",      "school", 145),
    ("Contact us",        "school",  57),
    ("Get PLUS tutoring", "school",  15),
]


def read_report(path):
    """Return (page_views, total_clicks, rows) from one Clarity click CSV."""
    page_views = total_clicks = None
    rows = []
    with open(path, newline="", encoding="utf-8-sig") as f:
        for rec in csv.reader(f):
            if not rec:
                continue
            if rec[0] == "Page views":
                page_views = int(rec[1])
            elif rec[0] == "Total clicks":
                total_clicks = int(rec[1])
            elif rec[0].isdigit() and len(rec) == 4:
                rows.append((int(rec[0]), rec[1], int(rec[2]), float(rec[3].rstrip("%"))))
    return page_views, total_clicks, rows


def main():
    if DB.exists():
        DB.unlink()
    con = sqlite3.connect(DB)
    con.executescript((ROOT / "sql/01_schema.sql").read_text())

    for report_id, (path, page, device) in REPORTS.items():
        pv, tc, rows = read_report(ROOT / path)
        con.execute("INSERT INTO click_report VALUES (?,?,?,?,?)", (report_id, page, device, pv, tc))
        con.executemany(
            "INSERT INTO element_clicks VALUES (?,?,?,?,?)",
            [(report_id, r, sel, c, p) for r, sel, c, p in rows],
        )
    con.executemany("INSERT INTO cta_clicks VALUES (?,?,?)", CTA_CLICKS)
    con.commit()
    con.close()
    print("built", DB)


if __name__ == "__main__":
    main()
