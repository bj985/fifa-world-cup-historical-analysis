# FIFA World Cup Historical Analysis (1930–2026)
*From Street Charts to Data Analytics*

**Bolaji Ibrahim Ajibola** | **SQL (PostgreSQL) · Power BI · Excel · Power Query**

An independent football analytics project exploring World Cup growth, historical dominance, goal-scoring patterns, attendance and national-team performance, with a dedicated focus on African nations.

[Explore the SQL](sql/01_analysis.sql) · [Validation checks](sql/00_validation.sql) · [Methodology](docs/methodology.md) · [All projects](https://github.com/bj985/jibol)

## The story behind the project

My interest in World Cup history began with the football charts I studied growing up in Lagos. This project takes that curiosity into a structured analytical workflow: collating tournament records, preparing data, writing SQL, and communicating patterns through Power BI.

The aim is not just to display football statistics. It is to make the underlying questions, calculations and data decisions visible.

## What the analysis investigates

| Analytical question | Approach |
| --- | --- |
| How has the tournament changed? | Compare participating teams, matches, goals, scoring rates and changes between editions. |
| Which nations sustain success? | Examine titles, top-two finishes and longer-term team records. |
| How have scoring patterns evolved? | Compare goals per match and weighted scoring rates across periods. |
| What does attendance reveal? | Compare total crowds, attendance per match and changes between editions. |
| How have African nations performed? | Examine participation, match records, scoring and best recorded positions. |

Match-level scoring and individual awards provide additional context.

## Tools and workflow

**Data collation → Excel / Power Query preparation → PostgreSQL analysis and reporting views → Power BI → written insights**

| Tool | Role |
| --- | --- |
| Excel and Power Query | Collating, cleaning, transforming and preparing datasets |
| PostgreSQL | Validating records, investigating questions and preparing reporting views |
| Power BI | Interactive visuals, measures and dashboard pages |

The published SQL demonstrates common table expressions, joins, aggregations, conditional logic, window functions, zero-denominator handling and data-quality checks.

## Project coverage

**1930–2026.** The project was initially developed using 1930–2022 data and was subsequently expanded to include 2026. References to 2022 in older working files describe an earlier development stage, not the current project scope.

The selected analysis queries published here explicitly include years through 2026. The validation file also reports 2026 row counts for each source table. The final era grouping in the selected analysis extends through 2026.

## Published files

| File | Contents |
| --- | --- |
| [Validation SQL](sql/00_validation.sql) | Eleven inspection queries covering column types, coverage, keys, match/goal reconciliation, accounting and mappings |
| [Analysis SQL](sql/01_analysis.sql) | Nine selected queries covering overview, evolution, eras, top-two finishes, teams, matches, attendance, awards and African teams |
| [Data model](docs/data-model.md) | Observed source tables, expected grains and required fields |
| [Methodology](docs/methodology.md) | Metric definitions, scope, packaging changes and limitations |

The SQL is adapted from selected parts of the working project. It is not a complete export of the original development script or every dashboard view.

## Run the SQL

Use a separate review database containing the project's source tables in the `public` schema. Begin with the column inventory in the validation file, compare it with the data-model document, then review validation outputs before running the analysis.

Both scripts use read-only transactions and end with `ROLLBACK`; they do not create or populate the database. They received non-mutating-statement and date-scope checks, but have **not been executed against the final PostgreSQL database** during this publication update.

## Interpretation and release status

Compare scale with rates, and participation with performance. The selected queries preserve source team labels rather than silently merging historical teams. Standardised points are labelled separately from historical official points; best recorded positions are not automatically translated into rounds reached.

The final datasets, schema export, Power BI model, verified dashboard URL, screenshots and validated result tables remain to be published. This repository now contains inspectable SQL and documentation, but is not yet reproducible from an empty database.

## Sources and reuse

Record original source URLs, extraction dates and reuse terms before adding datasets. Numerical findings should be accompanied by their checked outputs and filter context. No licence has been selected automatically for the code or third-party data.

## Author

**Bolaji Ibrahim Ajibola**  
Football Data Analysis and Business Intelligence  
[Portfolio](https://ibrahimbolaji.framer.website/) · [LinkedIn](https://www.linkedin.com/in/ajibola-bolaji/) · [GitHub](https://github.com/bj985)
