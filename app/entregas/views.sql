-- Primeira view

CREATE OR REPLACE VIEW view_avg_goals_per_season AS
SELECT
    match.season,
    team.team_api_id,
    team.team_long_name,
    AVG(
        CASE WHEN 
            match.home_team_api_id = team.team_api_id 
        THEN 
            match.home_team_goal 
        ELSE 
            match.away_team_goal 
        END
    ) AS average_goals_scored,
    AVG(
        CASE WHEN 
            match.home_team_api_id = team.team_api_id 
        THEN 
            match.away_team_goal 
        ELSE 
            match.home_team_goal
        END
    ) AS average_goals_conceded
FROM
    match
JOIN
    team 
ON 
    team.team_api_id = match.home_team_api_id 
        OR 
    team.team_api_id = match.away_team_api_id
GROUP BY
    match.season, team.team_api_id, team.team_long_name
ORDER BY
    match.season, team.team_long_name;

-- Segunda View

CREATE OR REPLACE VIEW player_stats_per_match AS
SELECT
    m.match_api_id,
    p.player_api_id,
    p.player_name,
    COUNT(DISTINCT mg.id) AS goals_scored,
    COUNT(DISTINCT ms.id) AS shots_on_target,
    COUNT(DISTINCT mc.id) AS crosses
FROM
    match m
LEFT JOIN
    match_goals mg
ON 
	mg.match_api_id = m.match_api_id
LEFT JOIN
    match_shoton ms
ON 
	ms.match_api_id = m.match_api_id
LEFT JOIN
    match_cross mc
ON 
	mc.match_api_id = m.match_api_id
JOIN
    player p
ON 
	p.player_api_id = mg.player_api_id 
		OR 
	p.player_api_id = ms.player_api_id 
		OR 
	p.player_api_id = mc.player_api_id
GROUP BY
    m.match_api_id, p.player_api_id, p.player_name
ORDER BY
    m.match_api_id, p.player_name;

-- Terceira View

CREATE OR REPLACE VIEW match_odds_results AS
SELECT
    m.match_api_id,
    m.date,
    home_team.team_long_name AS home_team,
    away_team.team_long_name AS away_team,
    m.home_team_goal,
    m.away_team_goal,
    bh.name AS bets_house,
    mo.home_win_odds,
    mo.draw_odds,
    mo.away_win_odds
FROM
    match m
JOIN
    team AS home_team 
ON 
	home_team.team_api_id = m.home_team_api_id
JOIN
    team AS away_team 
ON 
	away_team.team_api_id = m.away_team_api_id
JOIN
    match_odds mo
ON 
	mo.match_api_id = m.match_api_id
JOIN
    bets_house bh
ON 
	bh.id_bets_house = mo.id_bets_house
ORDER BY
    m.date, bh.name;