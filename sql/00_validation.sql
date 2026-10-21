-- Read-only publication checks for the 1930-2026 World Cup project.
-- These queries inspect data; their presence does not certify the data.
-- Run the inventory first and compare it with docs/data-model.md.
BEGIN TRANSACTION READ ONLY;
SET LOCAL search_path TO public, pg_catalog;

-- 1. Actual column inventory and types.
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('worldcup_summary', 'worldcup_matches', 'worldcup_goals',
      'worldcup_nations_history', 'worldcup_attendance', 'worldcup_awards', 'country_lookup')
ORDER BY table_name, ordinal_position;

-- 2. Coverage across source tables, including explicit 2026 counts.
SELECT 'worldcup_summary' AS source_table, COUNT(*) AS rows,
       MIN(year) AS first_year, MAX(year) AS last_year,
       COUNT(*) FILTER (WHERE year = 2026) AS rows_2026
FROM public.worldcup_summary
UNION ALL
SELECT 'worldcup_matches', COUNT(*), MIN(year), MAX(year), COUNT(*) FILTER (WHERE year = 2026)
FROM public.worldcup_matches
UNION ALL
SELECT 'worldcup_goals', COUNT(*), MIN(year), MAX(year), COUNT(*) FILTER (WHERE year = 2026)
FROM public.worldcup_goals
UNION ALL
SELECT 'worldcup_nations_history', COUNT(*), MIN(year), MAX(year), COUNT(*) FILTER (WHERE year = 2026)
FROM public.worldcup_nations_history
UNION ALL
SELECT 'worldcup_attendance', COUNT(*), MIN(year), MAX(year), COUNT(*) FILTER (WHERE year = 2026)
FROM public.worldcup_attendance
UNION ALL
SELECT 'worldcup_awards', COUNT(*), MIN(year), MAX(year), COUNT(*) FILTER (WHERE year = 2026)
FROM public.worldcup_awards;

-- 3. Duplicate summary and attendance years.
SELECT 'worldcup_summary' AS source_table, year, COUNT(*) AS rows
FROM public.worldcup_summary GROUP BY year HAVING COUNT(*) > 1
UNION ALL
SELECT 'worldcup_attendance', year, COUNT(*)
FROM public.worldcup_attendance GROUP BY year HAVING COUNT(*) > 1;

-- 4. Missing or duplicate match identifiers.
SELECT match_id, COUNT(*) AS rows FROM public.worldcup_matches
GROUP BY match_id HAVING match_id IS NULL OR COUNT(*) > 1;

-- 5. Team-edition duplicate keys.
SELECT year, team, COUNT(*) AS rows FROM public.worldcup_nations_history
GROUP BY year, team HAVING COUNT(*) > 1;

-- 6. Match totals versus tournament summaries. Duplicates above must be resolved first.
WITH matches AS (
    SELECT year, COUNT(*) AS match_rows, SUM(home_goals + away_goals) AS goals,
           COUNT(*) FILTER (WHERE home_goals IS NULL OR away_goals IS NULL) AS missing_scores
    FROM public.worldcup_matches WHERE year BETWEEN 1930 AND 2026 GROUP BY year
), summaries AS (
    SELECT year, matches_played, goals_scored FROM public.worldcup_summary
    WHERE year BETWEEN 1930 AND 2026
)
SELECT COALESCE(s.year, m.year) AS year, s.matches_played, m.match_rows,
       s.matches_played - m.match_rows AS match_difference,
       s.goals_scored, m.goals AS goals_from_matches,
       s.goals_scored - m.goals AS goal_difference, m.missing_scores
FROM summaries s FULL JOIN matches m ON s.year = m.year
ORDER BY year;

-- 7. Team accounting and missing numeric fields.
SELECT year, team, games_played, wins, draws, losses, goals_for, goals_against, goal_difference
FROM public.worldcup_nations_history
WHERE year IS NULL OR team IS NULL OR BTRIM(team) = ''
   OR games_played IS NULL OR wins IS NULL OR draws IS NULL OR losses IS NULL
   OR goals_for IS NULL OR goals_against IS NULL OR goal_difference IS NULL
   OR games_played < 0 OR wins < 0 OR draws < 0 OR losses < 0
   OR goals_for < 0 OR goals_against < 0
   OR games_played <> wins + draws + losses
   OR goal_difference <> goals_for - goals_against;

-- 8. Missing country mappings. Do not silently omit these from regional comparisons.
SELECT DISTINCT n.team
FROM public.worldcup_nations_history n
WHERE n.year BETWEEN 1930 AND 2026
  AND NOT EXISTS (SELECT 1 FROM public.country_lookup c
                  WHERE BTRIM(c.original_country) = BTRIM(n.team))
ORDER BY n.team;

-- 9. Repeated mapping keys and conflicting regional classifications.
SELECT BTRIM(original_country) AS original_country, COUNT(*) AS mapping_rows,
       COUNT(DISTINCT LOWER(BTRIM(region))) AS region_labels
FROM public.country_lookup
GROUP BY BTRIM(original_country)
HAVING COUNT(*) > 1 OR COUNT(DISTINCT LOWER(BTRIM(region))) <> 1;

-- 10. Region vocabulary must be inspected before using the Africa predicate.
SELECT region, COUNT(*) AS mappings FROM public.country_lookup
GROUP BY region ORDER BY region;

-- 11. Missing/negative recorded match scores.
SELECT match_id, year, home_team, away_team, home_goals, away_goals
FROM public.worldcup_matches
WHERE year BETWEEN 1930 AND 2026
  AND (home_goals IS NULL OR away_goals IS NULL OR home_goals < 0 OR away_goals < 0);

ROLLBACK;
