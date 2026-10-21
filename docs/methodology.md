# Methodology and SQL publication notes

[Project overview](../README.md) · [Data model](data-model.md)

## Scope and provenance

The project covers **1930–2026**. It began with 1930–2022 data and was later expanded by the author. Both the README and the selected analysis queries now include 2026.

`sql/01_analysis.sql` contains nine selected queries adapted from the author's saved working analysis. It is a publication-oriented selection, not a verbatim copy of the full development script or an export of every Power BI reporting view. `sql/00_validation.sql` is a companion set of publication checks.

Changes made during packaging include an inclusive 2026 cutoff, zero-denominator guards, numeric division, weighted era scoring, source-label descriptions and a lookup-based African filter. The scripts do not contain table resets, data updates or view replacements.

## Running order

Use a separate review database with the project's source tables in `public`. Run the column inventory in `00_validation.sql` first. Compare it with the data-model document and correct missing tables or incompatible column types before proceeding.

Review coverage, duplicate-key, accounting and reconciliation outputs before running `01_analysis.sql`. The scripts use read-only transactions and end with `ROLLBACK`. They do not create or populate a database. If a statement fails, roll back the failed transaction before continuing in the query tool.

## Definitions

**Source labels:** national-team and champion tables retain the labels stored in the source. These are not automatically equivalent to an official historical succession policy. Country-name aggregation must be documented before presenting unified all-time nation totals.

**Top-two finishes:** the champion and runner-up fields describe final tournament positions. The query deliberately labels these as top-two finishes rather than assuming every edition ended with the same single-final format.

**Scoring rates:** goals per match are recomputed from totals. Era scoring uses total goals divided by total matches, rather than an unweighted average of edition rates. The selected query uses four descriptive periods from the earlier working analysis, extending the last to 2026; it is not a claim that every dashboard uses the same grouping.

**Standardised points:** `3 × wins + draws` is a common comparison scale, not a reconstruction of points awarded under historical tournament rules.

**Match results:** the queries use recorded scores and stored win/draw/loss fields. The treatment of shootouts must be checked in the dataset. Do not combine incompatible definitions across tables.

**Attendance:** total attendance divided by tournament matches assumes the total covers those matches. Compare with the source average and document missing match-level attendance before interpreting differences.

**African comparisons:** the query uses the author's country lookup rather than a hardcoded pre-2026 participant list. It accepts the region label `Africa` or a label ending in ` africa`, case-insensitively. Run the region-vocabulary and missing-mapping checks first. This is not a general geographic or confederation taxonomy. Source team names are retained and no new nations or results are invented.

**Tournament progress:** a final numerical position is not automatically a round reached across changing formats. The African query returns the best recorded position without converting it into an unsupported round label.

## Validation status

The scripts were checked for read-only transaction wrappers, absence of data-changing statements and inclusion of the 2026 scope. They were **not executed against PostgreSQL or the author's final database** during this update. No result tables or historical findings are certified by this publication.

The project title establishes the intended coverage, not independent verification of every record. Each dataset release should identify source URLs, extraction dates, definitions and any simulated or scenario records separately from observed results.

## Reproducibility still required

Publish the final schema, permitted datasets, import instructions, lookup decisions and verified query outputs. Attach genuine dashboard screenshots and the public dashboard link when available. Third-party data and images retain their own reuse conditions.
