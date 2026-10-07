# FIFA World Cup Historical Analysis
### From Street Charts to Data Analytics

**Bolaji Ibrahim Ajibola** | **SQL (PostgreSQL) · Power BI · Excel · Power Query**

An independent football analytics project exploring World Cup growth, historical dominance, goal-scoring patterns, attendance, and national-team performance, with a dedicated focus on African nations.

## The story behind the project

My interest in World Cup history began with the football charts I studied growing up in Lagos. This project takes that curiosity into a structured analytical workflow: collating tournament records, preparing data, writing SQL and communicating patterns through Power BI.

The aim is not just to display football statistics. It is to make the underlying questions, calculations and data decisions visible.

## What the analysis investigates

| Analytical question | Approach |
| --- | --- |
| How has the tournament changed? | Compare participating teams, matches, goals, scoring rates, and changes between editions. |
| Which nations sustain success? | Examine titles, top-two finishes, runners-up, podium finishes, and conversion rates. |
| How have scoring patterns evolved? | Compare total goals with goals per match and examine differences across editions and stages. |
| What does attendance reveal? | Compare total and average crowds, tournament scale, venues, and stages. |
| How have African nations performed? | Examine participation, match records, scoring, and tournament finishes. |

Host distribution and individual awards provide additional context.

## Tools and workflow

**Data collation → Excel / Power Query preparation → PostgreSQL analysis and reporting views → Power BI → written insights**

| Tool | Role in the project |
| --- | --- |
| Excel and Power Query | Collating, cleaning, transforming, and preparing datasets. |
| PostgreSQL | Validating records, investigating analytical questions and preparing reporting views. |
| Power BI | Building interactive visuals, measures, and dashboard pages. |

The working SQL includes common table expressions, joins, conditional classifications, aggregations, window functions such as `LAG`, and reporting-view development.

## Analytical approach

The project considers both scale and performance. Total goals and total attendance describe tournament volume, while goals per match and average attendance offer a different basis for comparison between editions.

National-team analysis considers participation alongside results, rather than treating appearance counts alone as evidence of success. A dedicated African-nations section examines participation and performance within the wider World Cup story.

Country-name conventions, changing tournament formats, match-result definitions, and missing attendance records require explicit treatment. Methodology notes will accompany the published query files so these decisions can be reviewed.

## Repository status

**Repository setup is in progress.** This README introduces the project. SQL scripts, methodology documentation, datasets, dashboard screenshots and a public Power BI link still need to be added to this repository.

The working SQL initially described a historical scope of **1930–2022**. Later working sections also referred to 2026 records. The final published date range will be confirmed against the source data; unverified 2026 entries are not presented here as established historical findings.

This repository is not yet a fully reproducible release. Prepared SQL modules require testing against the final PostgreSQL database and numerical findings will be published with their validated outputs.

## Planned repository structure

The following folders will be added as their contents are reviewed:

```text
README.md
sql/        SQL analysis and validation queries
 data/      Datasets and source documentation
 docs/      Data model, methodology, and interpretation notes
 powerbi/   Dashboard documentation and model assets
 assets/    Genuine dashboard screenshots
```

## Data and source notes

Data-source references and reuse terms will be documented before datasets are published. Country mappings and other analytical assumptions should be read alongside any all-time rankings. No licence has been selected automatically for the code or third-party data.

## Author

**Bolaji Ibrahim Ajibola**  
Football data analysis and Business intelligence  
GitHub: **bj985**
