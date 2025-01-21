-- Primeira view

CREATE VIEW view_time_performance AS
SELECT 
    t.team_long_name AS nome,
    SUM(
        CASE WHEN 
            m.home_team_api_id = t.team_api_id 
        THEN 
            m.home_team_goal 
        ELSE 
            0 
        END
    ) AS gols_marcados,
    SUM(
        CASE WHEN 
            m.away_team_api_id = t.team_api_id 
        THEN 
            m.away_team_goal 
        ELSE 
            0 
        END
    ) AS gols_concedidos
FROM 
    team t
LEFT JOIN 
    match m 
ON 
    t.team_api_id = m.home_team_api_id 
    OR 
    t.team_api_id = m.away_team_api_id
GROUP BY 
    t.team_long_name;

-- Segunda View

CREATE VIEW view_media_estatisticas_jogadores AS
SELECT 
    p.player_name AS nome_jogador,
    AVG(pa.overall_rating) AS media_classificacao_geral,
    AVG(pa.potential) AS media_potencial,
    AVG(pa.crossing) AS media_cruzamentos,
    AVG(pa.finishing) AS media_finalizacao,
    AVG(pa.short_passing) AS media_passes_curtos,
    AVG(pa.dribbling) AS media_drible,
    AVG(pa.stamina) AS media_resistencia
FROM 
    player p
JOIN 
    player_attributes pa 
ON 
    p.player_api_id = pa.player_api_id
GROUP BY 
    p.player_name;

-- Terceira View

CREATE VIEW view_resumo_partida AS
SELECT 
    m.date,
    t1.team_long_name AS time_casa,
    t2.team_long_name AS time_visitante,
    m.home_team_goal as gols_time_casa,
    m.away_team_goal AS gols_time_visitante
FROM 
    match m
JOIN 
    team t1 
ON 
	m.home_team_api_id = t1.team_api_id
JOIN 
    team t2 
ON 
	m.away_team_api_id = t2.team_api_id;