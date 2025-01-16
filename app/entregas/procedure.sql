-- Primeira Procedure

CREATE OR REPLACE PROCEDURE pr_converter_weight_para_kg()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE 
        player
    SET 
        weight = weight * 0.453592
    WHERE 
        weight IS NOT NULL;
END;
$$;

CALL pr_converter_weight_para_kg();

-- Segunda Procedure

ALTER TABLE team
ADD COLUMN goals_scored INT DEFAULT 0,
ADD COLUMN goals_conceded INT DEFAULT 0,
ADD COLUMN goal_difference INT DEFAULT 0;

CREATE OR REPLACE PROCEDURE pr_atualiza_estatisticas_time()
LANGUAGE plpgsql
AS $$
BEGIN

    UPDATE 
		team
    SET 
		goals_scored = 0, 
		goals_conceded = 0, 
		goal_difference = 0;

-- Gols Feitos Casa
    UPDATE 
		team
    SET 
		goals_scored = goals_scored + subquery.gols_casa
    FROM (
        SELECT 
			home_team_api_id AS id_time, 
			SUM(home_team_goal) AS gols_casa
        FROM 
			match
        GROUP BY 
			home_team_api_id
    ) AS subquery
    WHERE 
		team.team_api_id = subquery.id_time;

-- Gols Feitos Visitante
    UPDATE 
		team
    SET 
		goals_scored = goals_scored + subquery.gols_visitante
    FROM (
        SELECT 
			away_team_api_id AS id_time, 
			SUM(away_team_goal) AS gols_visitante
        FROM 
			match
        GROUP BY 
			away_team_api_id
    ) AS subquery
    WHERE 
		team.team_api_id = subquery.id_time;

-- Gols Sofrido Em Casa
    UPDATE 
		team
    SET 
		goals_conceded = goals_conceded + subquery.gols_visitante
    FROM (
        SELECT 
			home_team_api_id AS id_time, 
			SUM(away_team_goal) AS gols_visitante
        FROM 
			match
        GROUP BY 
			home_team_api_id
    ) AS subquery
    WHERE 
		team.team_api_id = subquery.id_time;

-- Gols sofrido Como Visitante
    UPDATE 
		team
    SET 
		goals_conceded = goals_conceded + subquery.gols_casa
    FROM (
        SELECT 
			away_team_api_id AS id_time, 
			SUM(home_team_goal) AS gols_casa
        FROM 
			match
        GROUP BY 
			away_team_api_id
    ) AS subquery
    WHERE 
		team.team_api_id = subquery.id_time;

-- Saldo de gols
    UPDATE 
		team
    SET 
		goal_difference = goals_scored - goals_conceded;

END;
$$;

CALL pr_atualiza_estatisticas_time();

-- Terceira procedure

ALTER TABLE team 
ADD COLUMN wins INT DEFAULT 0,
ADD COLUMN losses INT DEFAULT 0,
ADD COLUMN draws INT DEFAULT 0;

CREATE OR REPLACE PROCEDURE pr_resultados_times()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE team
    SET wins = 0,
        losses = 0,
        draws = 0;

	-- Vitoria Casa
    UPDATE 
		team
    SET 
		wins = wins + subquery.vitorias
    FROM (
        SELECT 
            home_team_api_id AS id_time,
            COUNT(*) AS vitorias
        FROM 
			match
        WHERE 
			home_team_goal > away_team_goal
        GROUP BY 
			home_team_api_id
    ) AS subquery
    WHERE 
		team.team_api_id = subquery.id_time;

    -- Vitoria Visitante
    UPDATE team
    SET 
        wins = wins + subquery.vitorias
    FROM (
        SELECT 
            away_team_api_id AS id_time,
            COUNT(*) AS vitorias
        FROM 
            match
        WHERE 
            away_team_goal > home_team_goal
        GROUP BY 
            away_team_api_id
    ) AS subquery
    WHERE 
        team.team_api_id = subquery.id_time;

    -- Empates Casa
    UPDATE 
        team
    SET 
        draws = draws + subquery.empates
    FROM (
        SELECT 
            home_team_api_id AS id_time,
            COUNT(*) AS empates
        FROM 
            match
        WHERE 
            home_team_goal = away_team_goal
        GROUP BY 
            home_team_api_id
    ) AS subquery
    WHERE 
        team.team_api_id = subquery.id_time;

    -- Empates Visitante
    UPDATE 
        team
    SET 
        draws = draws + subquery.empates
    FROM (
        SELECT 
            away_team_api_id AS id_time,
            COUNT(*) AS empates
        FROM 
            match
        WHERE 
            home_team_goal = away_team_goal
        GROUP BY 
            away_team_api_id
    ) AS subquery
    WHERE 
        team.team_api_id = subquery.id_time;

    -- Derrota Casa
    UPDATE 
        team
    SET 
        losses = losses + subquery.derrota
    FROM (
        SELECT 
            home_team_api_id AS id_time,
            COUNT(*) AS derrota
        FROM
            match
        WHERE 
            home_team_goal < away_team_goal
        GROUP BY 
            home_team_api_id
    ) AS subquery
    WHERE 
        team.team_api_id = subquery.derrota;

    -- Derrota Visitante
    UPDATE 
        team
    SET 
        losses = losses + subquery.derrota
    FROM (
        SELECT 
            away_team_api_id AS id_time,
            COUNT(*) AS derrota
        FROM 
            match
        WHERE 
            home_team_goal < away_team_goal
        GROUP BY 
            away_team_api_id
    ) AS subquery
    WHERE 
        team.team_api_id = subquery.id_time;

END;
$$;

CALL pr_resultados_times();
