# World Cup data model

[Project overview](../README.md) · [Methodology](methodology.md)

This inventory is based on references in the author's saved working SQL. It is not a verified database DDL export. Run the column inventory in `sql/00_validation.sql` before executing the analysis.

| Table | Intended grain to verify | Fields used by the published queries |
| --- | --- | --- |
| `worldcup_summary` | One row per edition | `year`, `champions`, `runner_up`, `teams`, `matches_played`, `goals_scored` |
| `worldcup_matches` | One row per match | `match_id`, `year`, `stage`, `home_team`, `away_team`, `home_goals`, `away_goals` |
| `worldcup_nations_history` | One row per team per edition | `year`, `team`, `position`, `games_played`, `wins`, `draws`, `losses`, `goals_for`, `goals_against`, `goal_difference` |
| `worldcup_attendance` | One row per edition | `year`, `hosts`, `total_attendance`, `matches`, `average_attendance` |
| `worldcup_awards` | Award representation to confirm | `year`, `host`, `golden_ball`, `golden_boot`, `goals`, `golden_glove`, `clean_sheets`, `young_player_award`, `fair_play_trophy` |
| `worldcup_goals` | Goal-event or scorer grain not established here | `year` only, used for coverage checks |
| `country_lookup` | Source-name mapping | `original_country`, `modern_country`, `region`; the selected African analysis uses `original_country` and `region` |

## Expected types

The scripts expect numeric year, score, match-count, position and attendance-total fields, and text team/region fields. Verify the actual database types rather than assuming that Excel display formatting reflects stored numeric values.

Do not rename `host` to `hosts` globally: the saved project uses these names in different tables.

## Keys and joins

Confirm that summary and attendance years are unique, match IDs are non-null and unique, and team-edition combinations are not duplicated.

A historical-name lookup can contain several aliases for a modern reporting label. Joining aggregate facts directly to that label can duplicate totals. The published African filter uses `EXISTS` instead of a multiplying join, but its classification is still only as complete and correct as the lookup.

## Not yet included

The original `CREATE TABLE` definitions, import commands, complete datasets and Power BI model are not bundled in this release. They are required before another person can reproduce the project from an empty database.
