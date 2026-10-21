-- FIFA World Cup Historical Analysis | Bolaji Ibrahim Ajibola
-- Selected queries adapted from the saved working analysis.
-- Project scope: 1930-2026, inclusive. No data or results are embedded.
-- Not executed against the author's final database in this publication pass.
-- Review docs/methodology.md and run 00_validation.sql first.
BEGIN TRANSACTION READ ONLY;
SET LOCAL search_path TO public, pg_catalog;

-- 1. Coverage and champion labels. Labels are not automatically unified nations.
SELECT MIN(year) AS first_year, MAX(year) AS latest_year,
       COUNT(DISTINCT year) AS editions,
       COUNT(DISTINCT NULLIF(BTRIM(champions), '')) AS champion_labels
FROM public.worldcup_summary
WHERE year BETWEEN 1930 AND 2026;

-- 2. Tournament development. Rates are calculated from totals, not rounded source rates.
WITH editions AS (
    SELECT year, teams, matches_played, goals_scored,
           goals_scored::numeric / NULLIF(matches_played, 0) AS goals_per_match
    FROM public.worldcup_summary
    WHERE year BETWEEN 1930 AND 2026
)
SELECT year, teams, matches_played, goals_scored,
       ROUND(goals_per_match, 2) AS goals_per_match,
       teams - LAG(teams) OVER (ORDER BY year) AS team_count_change,
       ROUND(goals_per_match - LAG(goals_per_match) OVER (ORDER BY year), 2)
           AS goals_per_match_change
FROM editions ORDER BY year;

-- 3. Era comparison. Weighted scoring rate; 2026 belongs to the last group.
WITH editions AS (
    SELECT *, CASE WHEN year <= 1950 THEN '1930-1950'
                   WHEN year <= 1970 THEN '1954-1970'
                   WHEN year <= 1990 THEN '1974-1990'
                   ELSE '1994-2026' END AS era
    FROM public.worldcup_summary
    WHERE year BETWEEN 1930 AND 2026
)
SELECT era, MIN(year) AS first_year, MAX(year) AS last_year,
       COUNT(*) AS editions, SUM(matches_played) AS matches,
       SUM(goals_scored) AS goals,
       ROUND(SUM(goals_scored)::numeric / NULLIF(SUM(matches_played), 0), 2)
           AS weighted_goals_per_match
FROM editions GROUP BY era ORDER BY MIN(year);

-- 4. Titles and top-two finishes by source label.
-- Top-two finishes are not the same as appearances in a single final match.
WITH placements AS (
    SELECT NULLIF(BTRIM(champions), '') AS team, 1 AS title
    FROM public.worldcup_summary WHERE year BETWEEN 1930 AND 2026
    UNION ALL
    SELECT NULLIF(BTRIM(runner_up), ''), 0
    FROM public.worldcup_summary WHERE year BETWEEN 1930 AND 2026
)
SELECT team, SUM(title) AS titles, COUNT(*) AS top_two_finishes,
       ROUND(100.0 * SUM(title) / NULLIF(COUNT(*), 0), 2) AS titles_per_top_two_pct
FROM placements WHERE team IS NOT NULL
GROUP BY team ORDER BY titles DESC, top_two_finishes DESC, team;

-- 5. Team performance by source label. Standardised points are not historical official points.
SELECT team, COUNT(DISTINCT year) AS editions,
       SUM(games_played) AS matches, SUM(wins) AS wins,
       SUM(draws) AS draws, SUM(losses) AS losses,
       SUM(goals_for) AS goals_for, SUM(goals_against) AS goals_against,
       SUM(goals_for) - SUM(goals_against) AS goal_difference,
       ROUND(100.0 * SUM(wins) / NULLIF(SUM(games_played), 0), 2) AS win_pct,
       3 * SUM(wins) + SUM(draws) AS standardised_points
FROM public.worldcup_nations_history
WHERE year BETWEEN 1930 AND 2026
GROUP BY team ORDER BY standardised_points DESC, team;

-- 6. Highest-scoring recorded matches. Preserve source team and stage labels.
SELECT year, stage, home_team, away_team, home_goals, away_goals,
       home_goals + away_goals AS total_goals,
       ABS(home_goals - away_goals) AS goal_margin
FROM public.worldcup_matches
WHERE year BETWEEN 1930 AND 2026
  AND home_goals IS NOT NULL AND away_goals IS NOT NULL
ORDER BY total_goals DESC, goal_margin DESC, year, home_team, away_team
LIMIT 20;

-- 7. Attendance level and change. Zero denominators produce NULL, not a false rate.
WITH attendance AS (
    SELECT year, hosts, total_attendance, matches, average_attendance,
           LAG(total_attendance) OVER (ORDER BY year) AS previous_attendance
    FROM public.worldcup_attendance
    WHERE year BETWEEN 1930 AND 2026
)
SELECT year, hosts, total_attendance, matches,
       ROUND(total_attendance::numeric / NULLIF(matches, 0), 2) AS attendance_per_match,
       average_attendance AS source_average_attendance,
       ROUND(100.0 * (total_attendance - previous_attendance)
             / NULLIF(previous_attendance, 0), 2) AS attendance_change_pct
FROM attendance ORDER BY year;

-- 8. Awards timeline. Missing award values are retained, not replaced with zero.
SELECT year, host, golden_ball, golden_boot, goals, golden_glove,
       clean_sheets, young_player_award, fair_play_trophy
FROM public.worldcup_awards
WHERE year BETWEEN 1930 AND 2026 ORDER BY year;

-- 9. African team records using the project's lookup, not a fixed pre-2026 team list.
-- EXISTS avoids row multiplication. Check missing/ambiguous mappings first.
SELECT n.team AS source_team, COUNT(DISTINCT n.year) AS editions,
       SUM(n.games_played) AS matches, SUM(n.wins) AS wins,
       SUM(n.draws) AS draws, SUM(n.losses) AS losses,
       SUM(n.goals_for) AS goals_for, SUM(n.goals_against) AS goals_against,
       ROUND(100.0 * SUM(n.wins) / NULLIF(SUM(n.games_played), 0), 2) AS win_pct,
       MIN(n.position) AS best_recorded_position
FROM public.worldcup_nations_history n
WHERE n.year BETWEEN 1930 AND 2026
  AND EXISTS (
      SELECT 1 FROM public.country_lookup c
      WHERE BTRIM(c.original_country) = BTRIM(n.team)
        AND (LOWER(BTRIM(c.region)) = 'africa'
             OR LOWER(BTRIM(c.region)) LIKE '% africa')
  )
GROUP BY n.team ORDER BY best_recorded_position, win_pct DESC, source_team;

ROLLBACK;
