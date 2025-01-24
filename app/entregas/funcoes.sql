-- Primeira função

CREATE OR REPLACE FUNCTION fn_calculated_age_player(id_jogador int)
RETURNS INTEGER 
AS $$
DECLARE
	aniversario TEXT;
BEGIN
	
	select 
		birthday
	INTO
		aniversario
	from 
		player
	WHERE
		player_api_id = id_jogador;
		
	IF aniversario IS NULL THEN
        RAISE EXCEPTION 'Jogador com ID % não encontrado ou aniversário não definido.', id_jogador;
    END IF;

    RETURN DATE_PART('year', CURRENT_DATE) - DATE_PART('year', TO_DATE(aniversario, 'YYYY-MM-DD'));
END;
$$ LANGUAGE plpgsql;

select fn_calculated_age_player(505942);

-- Segunda funcao

CREATE OR REPLACE FUNCTION fn_player_stats_in_match(p_match_id BIGINT, p_player_id BIGINT)
RETURNS TABLE (
    player_id BIGINT,
    player_name TEXT,
    goals_scored BIGINT,
    shots_on_target BIGINT,
    crosses BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p_player_id AS player_id,
        player.player_name AS player_name,
        (SELECT COUNT(*) FROM match_goals WHERE match_api_id = p_match_id AND player_api_id = p_player_id) AS goals_scored,
        (SELECT COUNT(*) FROM match_shoton WHERE match_api_id = p_match_id AND player_api_id = p_player_id) AS shots_on_target,
        (SELECT COUNT(*) FROM match_cross WHERE match_api_id = p_match_id AND player_api_id = p_player_id) AS crosses
    FROM
        player
    WHERE
        player.player_api_id = p_player_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fn_player_stats_in_match(539770, 111862);

-- Terceira funcao

CREATE OR REPLACE FUNCTION fn_goals_team_in_season(temporada text, id_time INT)
RETURNS NUMERIC
AS $$
DECLARE
    gols_time_casa INT := 0;
	gols_time_visitante INT := 0;
    percentual NUMERIC := 0;
BEGIN

    SELECT 
        SUM(home_team_goal)
    INTO 
        gols_time_casa
    FROM 
        match
    WHERE 
        season = temporada
        AND 
		home_team_api_id = id_time;
		
	SELECT 
        SUM(away_team_goal)
    INTO 
        gols_time_visitante
    FROM 
        match
    WHERE 
        season = temporada
        AND 
		away_team_api_id = id_time;

    RETURN gols_time_visitante + gols_time_casa;
END;
$$ LANGUAGE plpgsql;

SELECT fn_goals_team_in_season('2008/2009', 10000);