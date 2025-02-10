CREATE TABLE match_fact (
    id bigserial PRIMARY KEY,
    match_api_id int8 NOT NULL,
    country_id int8 NULL,
    league_id int8 NULL,
    season text NULL,
    stage int8 NULL,
    date date NULL,
    home_team_goal int8 NULL,
    away_team_goal int8 NULL,
    id_bets_house int4 NULL,
    home_win_odds numeric NULL,
    draw_odds numeric NULL,
    away_win_odds numeric NULL,
    id_match_cross int8 NULL,
    id_foulcommit int8 NULL,
    id_goal int8 NULL,
    id_match_shoton int8 NULL,
    id_player int8 NULL,
    id_teams int8 NULL
);

-- TABELAS DIMENSÃO
CREATE TABLE dim_match_cross (
    id bigserial PRIMARY KEY,
    subtype varchar(50) NULL,
    type varchar(50) NULL
);

CREATE TABLE dim_foulcommit (
    id bigserial PRIMARY KEY,
    subtype varchar(50) NULL,
    type varchar(50) NULL
);

CREATE TABLE dim_goal (
    id bigserial PRIMARY KEY,
    goal_type varchar(50) NULL
);

CREATE TABLE dim_match_shoton (
    id bigserial PRIMARY KEY,
    type varchar(50) NULL,
    subtype varchar(50) NULL
);

CREATE TABLE dim_player (
    id bigserial PRIMARY KEY,
    nome text NULL,
    position_x int8 NULL,
    position_y int8 NULL
);

CREATE TABLE dim_teams (
    id_teams bigserial PRIMARY KEY,
    nome_home_team text NOT NULL,
    nome_away_team text NOT NULL,
    away_team_id int8 NOT NULL,
    home_team_id int8 NOT NULL
);

ALTER TABLE match_fact ADD CONSTRAINT fk_match_cross FOREIGN KEY (id_match_cross) REFERENCES dim_match_cross(id);
ALTER TABLE match_fact ADD CONSTRAINT fk_foulcommit FOREIGN KEY (id_foulcommit) REFERENCES dim_foulcommit(id);
ALTER TABLE match_fact ADD CONSTRAINT fk_goal FOREIGN KEY (id_goal) REFERENCES dim_goal(id);
ALTER TABLE match_fact ADD CONSTRAINT fk_match_shoton FOREIGN KEY (id_match_shoton) REFERENCES dim_match_shoton(id);
ALTER TABLE match_fact ADD CONSTRAINT fk_player FOREIGN KEY (id_player) REFERENCES dim_player(id);
ALTER TABLE match_fact ADD CONSTRAINT fk_teams FOREIGN KEY (id_teams) REFERENCES dim_teams(id_teams);

ALTER TABLE match_fact ADD CONSTRAINT fk_league FOREIGN KEY (league_id) REFERENCES league(id);
ALTER TABLE match_fact ADD CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES country(id);
ALTER TABLE match_fact ADD CONSTRAINT fk_bets_house FOREIGN KEY (id_bets_house) REFERENCES bets_house(id_bets_house);
