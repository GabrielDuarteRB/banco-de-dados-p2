-- Criando a posicao do jogador por partida

create table match_player_position (
	id SERIAL PRIMARY KEY,
    match_api_id BIGINT NOT NULL,
    team_id BIGINT NOT NULL,
    player_id BIGINT,
    position_x BIGINT,
    position_y BIGINT,
    FOREIGN KEY (match_api_id) REFERENCES match(match_api_id),
    FOREIGN KEY (team_id) REFERENCES team(team_api_id)
)

CREATE OR REPLACE FUNCTION populate_player_position()
RETURNS void AS
$$
DECLARE
    player_number INTEGER;
BEGIN
    FOR player_number IN 1..11 LOOP
        EXECUTE format('
            INSERT INTO match_player_position (
                match_api_id, 
                team_id, 
                player_id, 
                position_x, 
                position_y
            )
            SELECT 
                m.match_api_id, 
                m.home_team_api_id AS team_id,
                m.home_player_%s AS player_id, 
                m.home_player_x%s AS position_x, 
                m.home_player_y%s AS position_y
            FROM 
                match m', 
            player_number, player_number, player_number);
    END LOOP;

    FOR player_number IN 1..11 LOOP
        EXECUTE format('
            INSERT INTO match_player_position (
                match_api_id, 
                team_id, 
                player_id, 
                position_x, 
                position_y
            )
            SELECT 
                m.match_api_id, 
                m.away_team_api_id AS team_id,
                m.away_player_%s AS player_id, 
                m.away_player_x%s AS position_x, 
                m.away_player_y%s AS position_y
            FROM 
                match m', 
            player_number, player_number, player_number);
    END LOOP;
END $$
LANGUAGE plpgsql;

select populate_player_position();

ALTER TABLE match 
DROP COLUMN home_player_1, 
DROP COLUMN home_player_2, 
DROP COLUMN home_player_3, 
DROP COLUMN home_player_4, 
DROP COLUMN home_player_5, 
DROP COLUMN home_player_6, 
DROP COLUMN home_player_7, 
DROP COLUMN home_player_8, 
DROP COLUMN home_player_9, 
DROP COLUMN home_player_10, 
DROP COLUMN home_player_11,
DROP COLUMN away_player_1, 
DROP COLUMN away_player_2, 
DROP COLUMN away_player_3, 
DROP COLUMN away_player_4, 
DROP COLUMN away_player_5, 
DROP COLUMN away_player_6, 
DROP COLUMN away_player_7, 
DROP COLUMN away_player_8, 
DROP COLUMN away_player_9, 
DROP COLUMN away_player_10, 
DROP COLUMN away_player_11;

ALTER TABLE match 
DROP COLUMN home_player_x1, 
DROP COLUMN home_player_x2, 
DROP COLUMN home_player_x3, 
DROP COLUMN home_player_x4, 
DROP COLUMN home_player_x5, 
DROP COLUMN home_player_x6, 
DROP COLUMN home_player_x7, 
DROP COLUMN home_player_x8, 
DROP COLUMN home_player_x9, 
DROP COLUMN home_player_x10, 
DROP COLUMN home_player_x11,
DROP COLUMN away_player_x1, 
DROP COLUMN away_player_x2, 
DROP COLUMN away_player_x3, 
DROP COLUMN away_player_x4, 
DROP COLUMN away_player_x5, 
DROP COLUMN away_player_x6, 
DROP COLUMN away_player_x7, 
DROP COLUMN away_player_x8, 
DROP COLUMN away_player_x9, 
DROP COLUMN away_player_x10, 
DROP COLUMN away_player_x11;

ALTER TABLE match 
DROP COLUMN home_player_y1, 
DROP COLUMN home_player_y2, 
DROP COLUMN home_player_y3, 
DROP COLUMN home_player_y4, 
DROP COLUMN home_player_y5, 
DROP COLUMN home_player_y6, 
DROP COLUMN home_player_y7, 
DROP COLUMN home_player_y8, 
DROP COLUMN home_player_y9, 
DROP COLUMN home_player_y10, 
DROP COLUMN home_player_y11,
DROP COLUMN away_player_y1, 
DROP COLUMN away_player_y2, 
DROP COLUMN away_player_y3, 
DROP COLUMN away_player_y4, 
DROP COLUMN away_player_y5, 
DROP COLUMN away_player_y6, 
DROP COLUMN away_player_y7, 
DROP COLUMN away_player_y8, 
DROP COLUMN away_player_y9, 
DROP COLUMN away_player_y10, 
DROP COLUMN away_player_y11;

-- Criando as Bets

create table bets_house (
	id_bets_house Serial Primary key,
	name varchar(100) NOT NULL UNIQUE
);

INSERT INTO bets_house (name) VALUES
('Bet365'),
('BetWorld'),
('Interwetten'),
('Ladbrokes'),
('Pinnacle Sports'),
('William Hill'),
('Sportingbet'),
('VC Bet'),
('Gamebookers'),
('BetSharks');

CREATE TABLE match_odds (
    id SERIAL PRIMARY KEY,
    match_api_id BIGINT NOT NULL,
    id_bets_house INT NOT NULL,
    home_win_odds NUMERIC,
    draw_odds NUMERIC,
    away_win_odds NUMERIC,
    FOREIGN KEY (match_api_id) REFERENCES match(match_api_id),
    FOREIGN KEY (id_bets_house) REFERENCES bets_house(id_bets_house)
);

CREATE FUNCTION insert_odds_from_match() 
RETURNS VOID 
AS $$
DECLARE
    r_match RECORD;
BEGIN
    FOR r_match IN 
        SELECT match_api_id, 
               b365h, b365d, b365a, 
               bwh, bwd, bwa, 
               iwh, iwd, iwa, 
               lbh, lbd, lba, 
               psh, psd, psa, 
               whh, whd, wha, 
               sjh, sjd, sja, 
               vch, vcd, vca, 
               gbh, gbd, gba, 
               bsh, bsd, bsa 
        FROM match
    LOOP
        INSERT INTO match_odds 
			(match_api_id, id_bets_house, home_win_odds, draw_odds, away_win_odds) 
        VALUES 
			(r_match.match_api_id, 1, r_match.b365h, r_match.b365d, r_match.b365a);
        
        INSERT INTO match_odds 
			(match_api_id, id_bets_house, home_win_odds, draw_odds, away_win_odds) 
        VALUES 
			(r_match.match_api_id, 2, r_match.bwh, r_match.bwd, r_match.bwa);
        
        INSERT INTO match_odds 
			(match_api_id, id_bets_house, home_win_odds, draw_odds, away_win_odds) 
        VALUES 
			(r_match.match_api_id, 3, r_match.iwh, r_match.iwd, r_match.iwa);
        
        INSERT INTO match_odds 
			(match_api_id, id_bets_house, home_win_odds, draw_odds, away_win_odds) 
        VALUES 
			(r_match.match_api_id, 4, r_match.lbh, r_match.lbd, r_match.lba);
        
        INSERT INTO match_odds 
			(match_api_id, id_bets_house, home_win_odds, draw_odds, away_win_odds) 
        VALUES 
			(r_match.match_api_id, 5, r_match.psh, r_match.psd, r_match.psa);
        
        INSERT INTO match_odds 
			(match_api_id, id_bets_house, home_win_odds, draw_odds, away_win_odds) 
        VALUES 
			(r_match.match_api_id, 6, r_match.whh, r_match.whd, r_match.wha);
        
        INSERT INTO match_odds 
			(match_api_id, id_bets_house, home_win_odds, draw_odds, away_win_odds) 
        VALUES 
			(r_match.match_api_id, 7, r_match.sjh, r_match.sjd, r_match.sja);
        
        INSERT INTO match_odds 
			(match_api_id, id_bets_house, home_win_odds, draw_odds, away_win_odds) 
        VALUES 
			(r_match.match_api_id, 8, r_match.vch, r_match.vcd, r_match.vca);
        
        INSERT INTO match_odds 
			(match_api_id, id_bets_house, home_win_odds, draw_odds, away_win_odds) 
        VALUES 
			(r_match.match_api_id, 9, r_match.gbh, r_match.gbd, r_match.gba);
        
        INSERT INTO match_odds 
			(match_api_id, id_bets_house, home_win_odds, draw_odds, away_win_odds) 
        VALUES 
			(r_match.match_api_id, 10, r_match.bsh, r_match.bsd, r_match.bsa);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT insert_odds_from_match();

ALTER TABLE match 
DROP COLUMN b365h, 
DROP COLUMN b365d, 
DROP COLUMN b365a, 
DROP COLUMN bwh, 
DROP COLUMN bwd, 
DROP COLUMN bwa, 
DROP COLUMN iwh, 
DROP COLUMN iwd, 
DROP COLUMN iwa, 
DROP COLUMN lbh, 
DROP COLUMN lbd, 
DROP COLUMN lba, 
DROP COLUMN psh, 
DROP COLUMN psd, 
DROP COLUMN psa, 
DROP COLUMN whh, 
DROP COLUMN whd, 
DROP COLUMN wha, 
DROP COLUMN sjh, 
DROP COLUMN sjd, 
DROP COLUMN sja, 
DROP COLUMN vch, 
DROP COLUMN vcd, 
DROP COLUMN vca, 
DROP COLUMN gbh, 
DROP COLUMN gbd, 
DROP COLUMN gba, 
DROP COLUMN bsh, 
DROP COLUMN bsd, 
DROP COLUMN bsa;

-- goals

CREATE TABLE match_goals (
	id SERIAL PRIMARY KEY,
    match_api_id INT REFERENCES match (match_api_id),
    team_api_id INT REFERENCES team (team_api_id),
	player_api_id INT,
    goal_type VARCHAR(50),
    event_incident_typefk INT,
    elapsed INT,
    n INT
)

CREATE OR REPLACE FUNCTION insert_goals_from_all_matches() 
RETURNS VOID AS $$
DECLARE
    goal_xml XML;
    player_id INT;
    team_id INT;
    goal_type VARCHAR(50);
    event_incident_type INT;
    elapsed_time INT;
    goal_n INT;
    match_record RECORD;
    i INT;
BEGIN

    FOR match_record IN
        SELECT 
			match_api_id, 
			goal
        FROM 
			match
        WHERE 
			goal IS NOT NULL
			AND goal != '<goal />'
			AND home_team_goal + away_team_goal >= 1
    LOOP
        goal_xml := match_record.goal;

        FOR i IN 1..array_length(xpath('/goal/value', goal_xml), 1) LOOP
		
            player_id := (xpath('/goal/value/player1/text()', goal_xml))[i]::text::int;
            team_id := (xpath('/goal/value/team/text()', goal_xml))[i]::text::int;
            goal_type := (xpath('/goal/value/goal_type/text()', goal_xml))[i]::text;
            event_incident_type := (xpath('/goal/value/event_incident_typefk/text()', goal_xml))[i]::text::int;
            elapsed_time := (xpath('/goal/value/elapsed/text()', goal_xml))[i]::text::int;
            goal_n := (xpath('/goal/value/n/text()', goal_xml))[i]::text::int;

            INSERT INTO match_goals
				(match_api_id, player_api_id, team_api_id, goal_type, event_incident_typefk, elapsed, n)
            VALUES 
				(match_record.match_api_id, player_id, team_id, goal_type, event_incident_type, elapsed_time, goal_n);
        END LOOP;
    END LOOP;
    
    RETURN;
END;
$$ LANGUAGE plpgsql;


select insert_goals_from_all_matches()

ALTER TABLE match 
DROP COLUMN goal

-- Shoton

CREATE TABLE match_shoton (
    id SERIAL PRIMARY KEY,
    match_api_id INT REFERENCES match (match_api_id),
    team_api_id INT REFERENCES team (team_api_id),
    player_api_id INT,
    event_incident_typefk INT,
    elapsed INT,
    subtype VARCHAR(50),
	type VARCHAR(50),
    n INT
);

CREATE OR REPLACE FUNCTION insert_shoton_from_all_matches()
RETURNS VOID AS $$
DECLARE
    shoton_xml XML;
    player_id INT;
    team_id INT;
    event_incident_type INT;
    elapsed_time INT;
    subtype VARCHAR(50);
    shot_n INT;
    type VARCHAR(50);
    match_record RECORD;
    i INT;
BEGIN

    FOR match_record IN
        SELECT 
            match_api_id, 
            shoton
        FROM 
            match
        WHERE 
            shoton IS NOT NULL
            AND shoton != '<shoton />'
    LOOP
        shoton_xml := match_record.shoton;

        FOR i IN 1..array_length(xpath('/shoton/value', shoton_xml), 1) LOOP
        
            player_id := (xpath('/shoton/value/player1/text()', shoton_xml))[i]::text::int;
            team_id := (xpath('/shoton/value/team/text()', shoton_xml))[i]::text::int;
            event_incident_type := (xpath('/shoton/value/event_incident_typefk/text()', shoton_xml))[i]::text::int;
            elapsed_time := (xpath('/shoton/value/elapsed/text()', shoton_xml))[i]::text::int;
            subtype := (xpath('/shoton/value/subtype/text()', shoton_xml))[i]::text;
            shot_n := (xpath('/shoton/value/n/text()', shoton_xml))[i]::text::int;
            type := (xpath('/shoton/value/type/text()', shoton_xml))[i]::text;

            INSERT INTO match_shoton
                (match_api_id, player_api_id, team_api_id, event_incident_typefk, elapsed, subtype, type, n)
            VALUES 
                (match_record.match_api_id, player_id, team_id, event_incident_type, elapsed_time, subtype, type, shot_n);
        END LOOP;
    END LOOP;
    
    RETURN;
END;
$$ 
LANGUAGE plpgsql;


select insert_shoton_from_all_matches();

ALTER TABLE match 
DROP COLUMN shoton

-- foulcommit

CREATE TABLE match_foulcommit (
    id SERIAL PRIMARY KEY,
    match_api_id INT REFERENCES match (match_api_id),
    team_api_id INT REFERENCES team (team_api_id),
    player_api_id INT,
    player2_id INT,
    event_incident_typefk INT,
    elapsed INT,
    subtype VARCHAR(50),
    type VARCHAR(50),
    n INT
);

CREATE OR REPLACE FUNCTION insert_foulcommit_from_all_matches()
RETURNS VOID AS $$
DECLARE
    foulcommit_xml XML;
    team_id INT;
    event_incident_type INT;
    elapsed_time INT;
    subtype VARCHAR(50);
    foul_n INT;
    type VARCHAR(50);
    match_record RECORD;
    i INT;
BEGIN

    FOR match_record IN
        SELECT 
            match_api_id, 
            foulcommit
        FROM 
            match
        WHERE 
            foulcommit IS NOT NULL
            AND foulcommit != '<foulcommit />'
    LOOP
        foulcommit_xml := match_record.foulcommit;

        FOR i IN 1..array_length(xpath('/foulcommit/value', foulcommit_xml), 1) LOOP

            team_id := (xpath('/foulcommit/value/team/text()', foulcommit_xml))[i]::text::int;
            event_incident_type := (xpath('/foulcommit/value/event_incident_typefk/text()', foulcommit_xml))[i]::text::int;
            elapsed_time := (xpath('/foulcommit/value/elapsed/text()', foulcommit_xml))[i]::text::int;
            subtype := (xpath('/foulcommit/value/subtype/text()', foulcommit_xml))[i]::text;
            foul_n := (xpath('/foulcommit/value/n/text()', foulcommit_xml))[i]::text::int;
            type := (xpath('/foulcommit/value/type/text()', foulcommit_xml))[i]::text;

            INSERT INTO match_foulcommit
                (match_api_id, player_api_id, player2_id, team_api_id, event_incident_typefk, elapsed, subtype, type, n)
            VALUES 
                (
                    match_record.match_api_id,
                    nullif(coalesce((xpath('/foulcommit/value/player1/text()', foulcommit_xml))[i]::text, NULL), 'Unknown player')::int,
                    nullif(coalesce((xpath('/foulcommit/value/player2/text()', foulcommit_xml))[i]::text, NULL), 'Unknown player')::int,
                    team_id, 
                    event_incident_type, 
                    elapsed_time, 
                    subtype, 
                    type, 
                    foul_n
                );
        END LOOP;
    END LOOP;
    
    RETURN;
END;
$$ LANGUAGE plpgsql;

select insert_foulcommit_from_all_matches();

ALTER TABLE match 
DROP COLUMN foulcommit;

-- cross

CREATE TABLE match_cross (
    id SERIAL PRIMARY KEY,
    match_api_id INT REFERENCES match (match_api_id),
    team_api_id INT REFERENCES team (team_api_id),
    player_api_id INT,
    event_incident_typefk INT,
    elapsed INT,
    subtype VARCHAR(50),
    type VARCHAR(50),
    n INT
);

CREATE OR REPLACE FUNCTION insert_cross_from_all_matches()
RETURNS VOID AS $$
DECLARE
    cross_xml XML;
    player1_id INT;
    team_id INT;
    event_incident_type INT;
    elapsed_time INT;
    subtype VARCHAR(50);
    cross_n INT;
    type VARCHAR(50);
    match_record RECORD;
    i INT;
BEGIN

    FOR match_record IN
        SELECT 
			match_api_id, 
			"cross"
		FROM 
			match
		WHERE 
			"cross" IS NOT NULL
			AND "cross" != '<cross />'

    LOOP
        cross_xml := match_record.cross;

        FOR i IN 1..array_length(xpath('/cross/value', cross_xml), 1) LOOP
        
            player1_id := (xpath('/cross/value/player1/text()', cross_xml))[i]::text::int;
            team_id := (xpath('/cross/value/team/text()', cross_xml))[i]::text::int;
            event_incident_type := (xpath('/cross/value/event_incident_typefk/text()', cross_xml))[i]::text::int;
            elapsed_time := (xpath('/cross/value/elapsed/text()', cross_xml))[i]::text::int;
            subtype := (xpath('/cross/value/subtype/text()', cross_xml))[i]::text;
            cross_n := (xpath('/cross/value/n/text()', cross_xml))[i]::text::int;
            type := (xpath('/cross/value/type/text()', cross_xml))[i]::text;

            INSERT INTO match_cross
                (match_api_id, player_api_id, team_api_id, event_incident_typefk, elapsed, subtype, type, n)
            VALUES 
                (match_record.match_api_id, player1_id, team_id, event_incident_type, elapsed_time, subtype, type, cross_n);
        END LOOP;
    END LOOP;
    
    RETURN;
END;
$$ LANGUAGE plpgsql;

select insert_cross_from_all_matches();

ALTER TABLE match 
DROP COLUMN "cross";

-- Cut columns

ALTER TABLE match 
DROP COLUMN shotoff,
DROP COLUMN card,
DROP COLUMN corner,
DROP COLUMN possession;