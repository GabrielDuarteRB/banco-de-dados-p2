CREATE SCHEMA dw;

SET search_path TO dw;

DROP TABLE dim_league, dim_team, dim_player, dim_player_attributes, dim_team_attributes, fact_match

CREATE TABLE dim_league (
    league_id bigint PRIMARY KEY,
    league_name text,
	  country_name text
);

CREATE TABLE dim_team (
    team_api_id bigint PRIMARY KEY,
    team_fifa_api_id bigint,
    team_long_name text,
    team_short_name text
);

CREATE TABLE dim_player (
    player_api_id bigint PRIMARY KEY,
    player_name text,
    player_fifa_api_id bigint,
    birthday text,
    height double precision,
    weight bigint
);

CREATE TABLE dim_player_attributes (
    player_api_id bigint PRIMARY KEY,
    overall_rating bigint,
    potential bigint,
    preferred_foot text,
    attacking_work_rate text,
    defensive_work_rate text,
    crossing bigint,
    finishing bigint,
    heading_accuracy bigint,
    short_passing bigint,
    volleys bigint,
    dribbling bigint,
    curve bigint,
    free_kick_accuracy bigint,
    long_passing bigint,
    ball_control bigint,
    acceleration bigint,
    sprint_speed bigint,
    agility bigint,
    reactions bigint,
    balance bigint,
    shot_power bigint,
    jumping bigint,
    stamina bigint,
    strength bigint,
    long_shots bigint,
    aggression bigint,
    interceptions bigint,
    positioning bigint,
    vision bigint,
    penalties bigint,
    marking bigint,
    standing_tackle bigint,
    sliding_tackle bigint,
    gk_diving bigint,
    gk_handling bigint,
    gk_kicking bigint,
    gk_positioning bigint,
    gk_reflexes bigint
);

CREATE TABLE dim_team_attributes (
    team_api_id bigint PRIMARY KEY,
    buildupplayspeed bigint,
    buildupplayspeedclass text,
    buildupplaydribbling bigint,
    buildupplaydribblingclass text,
    buildupplaypassing bigint,
    buildupplaypassingclass text,
    buildupplaypositioningclass text,
    chancecreationpassing bigint,
    chancecreationpassingclass text,
    chancecreationcrossing bigint,
    chancecreationcrossingclass text,
    chancecreationshooting bigint,
    chancecreationshootingclass text,
    chancecreationpositioningclass text,
    defencepressure bigint,
    defencepressureclass text,
    defenceaggression bigint,
    defenceaggressionclass text,
    defenceteamwidth bigint,
    defenceteamwidthclass text,
    defencedefenderlineclass text
);

CREATE TABLE dim_player_match (
    player_match_id Serial PRIMARY KEY,
    home_player_x1 bigint,
    home_player_x2 bigint,
    home_player_x3 bigint,
    home_player_x4 bigint,
    home_player_x5 bigint,
    home_player_x6 bigint,
    home_player_x7 bigint,
    home_player_x8 bigint,
    home_player_x9 bigint,
    home_player_x10 bigint,
    home_player_x11 bigint,
    away_player_x1 bigint,
    away_player_x2 bigint,
    away_player_x3 bigint,
    away_player_x4 bigint,
    away_player_x5 bigint,
    away_player_x6 bigint,
    away_player_x7 bigint,
    away_player_x8 bigint,
    away_player_x9 bigint,
    away_player_x10 bigint,
    away_player_x11 bigint
);

CREATE TABLE dim_match_bet (
    match_bet_id SERIAL PRIMARY KEY,
    b365h numeric,
    b365d numeric,
    b365a numeric
);

CREATE TABLE dim_time (
  time_id Serial PRIMARY KEY,
  date_match DATE,
  year INT,
  mounth INT,
  day INT
);

CREATE TABLE fact_match (
    match_id bigint PRIMARY KEY,
    time_id int NOT NULL,
    country_id bigint NOT NULL,
    league_id bigint NOT NULL,
    home_team_api_id bigint NOT NULL,
    away_team_api_id bigint NOT NULL,
    player_match_id int NOT NULL,
    match_bet_id int NOT NULL,
    home_team_goal int,
    away_team_goal int,
    FOREIGN KEY (time_id) REFERENCES dim_time(time_id),
    FOREIGN KEY (league_id) REFERENCES dim_league(league_id),
    FOREIGN KEY (home_team_api_id) REFERENCES dim_team(team_api_id),
    FOREIGN KEY (away_team_api_id) REFERENCES dim_team(team_api_id),
    FOREIGN KEY (player_match_id) REFERENCES dim_player_match(player_match_id),
    FOREIGN KEY (match_bet_id) REFERENCES dim_match_bet(match_bet_id)
);
