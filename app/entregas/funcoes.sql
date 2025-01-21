-- Primeira função

CREATE OR REPLACE FUNCTION fn_aniversario_jogador(id_jogador int)
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

select fn_aniversario_jogador(505942);

-- Segunda funcao

CREATE FUNCTION fn_gols_temporada(temporada text)
RETURNS INT
AS $$
DECLARE
	total_gols INT := 0;
BEGIN
    SELECT 
        COALESCE(SUM(home_team_goal), 0) + COALESCE(SUM(away_team_goal), 0)
    INTO 
        total_gols
    FROM 
        match
    WHERE  
		season = temporada; 

    RETURN total_gols;
END;
$$ LANGUAGE plpgsql;
		
select fn_gols_temporada('2008/2009')

-- Terceira funcao

CREATE OR REPLACE FUNCTION fn_percentual_gols_time(temporada text, id_time INT)
RETURNS NUMERIC
AS $$
DECLARE
    total_gols INT := 0;
    gols_time_casa INT := 0;
	gols_time_visitante INT := 0;
    percentual NUMERIC := 0;
BEGIN

    SELECT 
        COALESCE(SUM(home_team_goal), 0) + COALESCE(SUM(away_team_goal), 0)
    INTO 
        total_gols
    FROM 
        match
    WHERE 
       	season = temporada;

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

    IF total_gols > 0 THEN
        percentual := (gols_time_visitante + gols_time_casa / total_gols) * 100;
    END IF;

    RETURN percentual;
END;
$$ LANGUAGE plpgsql;

SELECT fn_percentual_gols_time('2008/2009', 10000);