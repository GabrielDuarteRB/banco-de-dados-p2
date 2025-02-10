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

-- Segunda procedure

CREATE OR REPLACE PROCEDURE pr_update_odds(
    p_match_id BIGINT,
    p_bets_house_id INTEGER,
    p_home_win_odds NUMERIC,
    p_draw_odds NUMERIC,
    p_away_win_odds NUMERIC
)
AS $$
DECLARE
    match_exists BOOLEAN;
BEGIN
    SELECT EXISTS (SELECT 1 FROM match WHERE match_api_id = p_match_id) INTO match_exists;

    IF match_exists THEN
        UPDATE match_odds
        SET home_win_odds = p_home_win_odds,
            draw_odds = p_draw_odds,
            away_win_odds = p_away_win_odds
        WHERE match_api_id = p_match_id
          AND id_bets_house = p_bets_house_id;

        IF NOT FOUND THEN
            INSERT INTO match_odds (match_api_id, id_bets_house, home_win_odds, draw_odds, away_win_odds)
            VALUES (p_match_id, p_bets_house_id, p_home_win_odds, p_draw_odds, p_away_win_odds);
        END IF;
    ELSE
        RAISE NOTICE 'Match ID % does not exist.', p_match_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

call pr_update_odds(5000, 1, 5, 3.4, 2);

-- Terceira Procedure

CREATE OR REPLACE PROCEDURE convert_stringDate_to_Date()
AS $$
BEGIN
    ALTER TABLE match ADD COLUMN date_tmp DATE;

    UPDATE match 
    SET date_tmp = date::DATE;

    ALTER TABLE match DROP COLUMN date;

    ALTER TABLE match RENAME COLUMN date_tmp TO date;

    ALTER TABLE match ALTER COLUMN date SET NOT NULL;
    
    RAISE NOTICE 'Coluna date convertida com sucesso!';
END;
$$ LANGUAGE plpgsql;
