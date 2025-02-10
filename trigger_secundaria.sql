-- Função e trigger para a tabela bets_house
CREATE OR REPLACE FUNCTION sync_bets_house() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.bets_house (id_bets_house, "name") 
    VALUES (NEW.id_bets_house, NEW."name");
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.bets_house 
    SET "name" = NEW."name" 
    WHERE id_bets_house = OLD.id_bets_house;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.bets_house 
    WHERE id_bets_house = OLD.id_bets_house;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_bets_house
AFTER INSERT OR UPDATE OR DELETE ON public.bets_house
FOR EACH ROW
EXECUTE FUNCTION sync_bets_house();


-- Função e trigger para a tabela country
CREATE OR REPLACE FUNCTION sync_country() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.country (id, "name") 
    VALUES (NEW.id, NEW."name");
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.country 
    SET "name" = NEW."name" 
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.country 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_country
AFTER INSERT OR UPDATE OR DELETE ON public.country
FOR EACH ROW
EXECUTE FUNCTION sync_country();


-- Função e trigger para a tabela player
CREATE OR REPLACE FUNCTION sync_player() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.player (id, player_api_id, player_name, player_fifa_api_id, birthday, height, weight) 
    VALUES (NEW.id, NEW.player_api_id, NEW.player_name, NEW.player_fifa_api_id, NEW.birthday, NEW.height, NEW.weight);
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.player 
    SET player_name = NEW.player_name, player_fifa_api_id = NEW.player_fifa_api_id, 
        birthday = NEW.birthday, height = NEW.height, weight = NEW.weight
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.player 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_player
AFTER INSERT OR UPDATE OR DELETE ON public.player
FOR EACH ROW
EXECUTE FUNCTION sync_player();


-- Função e trigger para a tabela team
CREATE OR REPLACE FUNCTION sync_team() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.team (id, team_api_id, team_fifa_api_id, team_long_name, team_short_name) 
    VALUES (NEW.id, NEW.team_api_id, NEW.team_fifa_api_id, NEW.team_long_name, NEW.team_short_name);
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.team 
    SET team_api_id = NEW.team_api_id, team_fifa_api_id = NEW.team_fifa_api_id, 
        team_long_name = NEW.team_long_name, team_short_name = NEW.team_short_name
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.team 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_team
AFTER INSERT OR UPDATE OR DELETE ON public.team
FOR EACH ROW
EXECUTE FUNCTION sync_team();


-- Função e trigger para a tabela "match"
CREATE OR REPLACE FUNCTION sync_match() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario."match" (id, country_id, league_id, season, stage, "date", match_api_id, home_team_api_id, away_team_api_id, home_team_goal, away_team_goal, "cross") 
    VALUES (NEW.id, NEW.country_id, NEW.league_id, NEW.season, NEW.stage, NEW."date", NEW.match_api_id, NEW.home_team_api_id, NEW.away_team_api_id, NEW.home_team_goal, NEW.away_team_goal, NEW."cross");
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario."match" 
    SET country_id = NEW.country_id, league_id = NEW.league_id, season = NEW.season, stage = NEW.stage, 
        "date" = NEW."date", match_api_id = NEW.match_api_id, home_team_api_id = NEW.home_team_api_id, 
        away_team_api_id = NEW.away_team_api_id, home_team_goal = NEW.home_team_goal, 
        away_team_goal = NEW.away_team_goal, "cross" = NEW."cross"
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario."match" 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_match
AFTER INSERT OR UPDATE OR DELETE ON public."match"
FOR EACH ROW
EXECUTE FUNCTION sync_match();

-- Função e trigger para a tabela match_cross
CREATE OR REPLACE FUNCTION sync_match_cross() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.match_cross (id, match_api_id, team_api_id, player_api_id, event_incident_typefk, elapsed, subtype, "type", n) 
    VALUES (NEW.id, NEW.match_api_id, NEW.team_api_id, NEW.player_api_id, NEW.event_incident_typefk, NEW.elapsed, NEW.subtype, NEW."type", NEW.n);
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.match_cross 
    SET match_api_id = NEW.match_api_id, team_api_id = NEW.team_api_id, player_api_id = NEW.player_api_id, 
        event_incident_typefk = NEW.event_incident_typefk, elapsed = NEW.elapsed, subtype = NEW.subtype, 
        "type" = NEW."type", n = NEW.n
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.match_cross 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_match_cross
AFTER INSERT OR UPDATE OR DELETE ON public.match_cross
FOR EACH ROW
EXECUTE FUNCTION sync_match_cross();

-- Função e trigger para a tabela match_foulcommit
CREATE OR REPLACE FUNCTION sync_match_foulcommit() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.match_foulcommit (id, match_api_id, team_api_id, player_api_id, player2_id, event_incident_typefk, elapsed, subtype, "type", n) 
    VALUES (NEW.id, NEW.match_api_id, NEW.team_api_id, NEW.player_api_id, NEW.player2_id, NEW.event_incident_typefk, NEW.elapsed, NEW.subtype, NEW."type", NEW.n);
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.match_foulcommit 
    SET match_api_id = NEW.match_api_id, team_api_id = NEW.team_api_id, player_api_id = NEW.player_api_id, 
        player2_id = NEW.player2_id, event_incident_typefk = NEW.event_incident_typefk, 
        elapsed = NEW.elapsed, subtype = NEW.subtype, "type" = NEW."type", n = NEW.n
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.match_foulcommit 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_match_foulcommit
AFTER INSERT OR UPDATE OR DELETE ON public.match_foulcommit
FOR EACH ROW
EXECUTE FUNCTION sync_match_foulcommit();


-- Função e trigger para a tabela match_goals
CREATE OR REPLACE FUNCTION sync_match_goals() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.match_goals (id, match_api_id, team_api_id, player_api_id, goal_type, event_incident_typefk, elapsed, n) 
    VALUES (NEW.id, NEW.match_api_id, NEW.team_api_id, NEW.player_api_id, NEW.goal_type, NEW.event_incident_typefk, NEW.elapsed, NEW.n);
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.match_goals 
    SET match_api_id = NEW.match_api_id, team_api_id = NEW.team_api_id, player_api_id = NEW.player_api_id, 
        goal_type = NEW.goal_type, event_incident_typefk = NEW.event_incident_typefk, 
        elapsed = NEW.elapsed, n = NEW.n
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.match_goals 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_match_goals
AFTER INSERT OR UPDATE OR DELETE ON public.match_goals
FOR EACH ROW
EXECUTE FUNCTION sync_match_goals();

CREATE OR REPLACE FUNCTION sync_league() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.league (id, name, country_id, season) 
    VALUES (NEW.id, NEW.name, NEW.country_id, NEW.season);
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.league 
    SET name = NEW.name, country_id = NEW.country_id, season = NEW.season
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.league 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_league
AFTER INSERT OR UPDATE OR DELETE ON public.league
FOR EACH ROW
EXECUTE FUNCTION sync_league();


-- Função e trigger para a tabela match_odds
CREATE OR REPLACE FUNCTION sync_match_odds() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.match_odds (id, id_bets_house, match_api_id, home_win_odds, draw_odds, away_win_odds) 
    VALUES (NEW.id, NEW.id_bets_house, NEW.match_api_id, NEW.home_win_odds, NEW.draw_odds, NEW.away_win_odds);
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.match_odds 
    SET match_api_id = NEW.match_api_id,
        home_win_odds = NEW.home_win_odds, draw_odds = NEW.draw_odds, away_win_odds = NEW.away_win_odds, id_bets_house = NEW.id_bets_house
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.match_odds 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_match_odds
AFTER INSERT OR UPDATE OR DELETE ON public.match_odds
FOR EACH ROW
EXECUTE FUNCTION sync_match_odds();


-- Função e trigger para a tabela match_player_position
CREATE OR REPLACE FUNCTION sync_match_player_position() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.match_player_position (id, match_api_id, player_api_id, team_api_id, position) 
    VALUES (NEW.id, NEW.match_api_id, NEW.player_api_id, NEW.team_api_id, NEW.position);
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.match_player_position 
    SET match_api_id = NEW.match_api_id, player_api_id = NEW.player_api_id, 
        team_api_id = NEW.team_api_id, position = NEW.position
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.match_player_position 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_match_player_position
AFTER INSERT OR UPDATE OR DELETE ON public.match_player_position
FOR EACH ROW
EXECUTE FUNCTION sync_match_player_position();


-- Função e trigger para a tabela match_shoton
CREATE OR REPLACE FUNCTION sync_match_shoton() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.match_shoton (id, match_api_id, team_api_id, player_api_id, shots_on_target) 
    VALUES (NEW.id, NEW.match_api_id, NEW.team_api_id, NEW.player_api_id, NEW.shots_on_target);
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.match_shoton 
    SET match_api_id = NEW.match_api_id, team_api_id = NEW.team_api_id, 
        player_api_id = NEW.player_api_id, shots_on_target = NEW.shots_on_target
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.match_shoton 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_match_shoton
AFTER INSERT OR UPDATE OR DELETE ON public.match_shoton
FOR EACH ROW
EXECUTE FUNCTION sync_match_shoton();


-- Função e trigger para a tabela player_attributes
CREATE OR REPLACE FUNCTION sync_player_attributes() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.player_attributes (id, player_api_id, date, overall_rating, potential, total_stats) 
    VALUES (NEW.id, NEW.player_api_id, NEW.date, NEW.overall_rating, NEW.potential, NEW.total_stats);
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.player_attributes 
    SET player_api_id = NEW.player_api_id, date = NEW.date, overall_rating = NEW.overall_rating, 
        potential = NEW.potential, total_stats = NEW.total_stats
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.player_attributes 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_player_attributes
AFTER INSERT OR UPDATE OR DELETE ON public.player_attributes
FOR EACH ROW
EXECUTE FUNCTION sync_player_attributes();


-- Função e trigger para a tabela team_attributes
CREATE OR REPLACE FUNCTION sync_team_attributes() 
RETURNS trigger AS
$$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO secundario.team_attributes (id, team_api_id, date, overall_rating, attack_rating, midfield_rating, defense_rating) 
    VALUES (NEW.id, NEW.team_api_id, NEW.date, NEW.overall_rating, NEW.attack_rating, NEW.midfield_rating, NEW.defense_rating);
  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE secundario.team_attributes 
    SET team_api_id = NEW.team_api_id, date = NEW.date, overall_rating = NEW.overall_rating, 
        attack_rating = NEW.attack_rating, midfield_rating = NEW.midfield_rating, 
        defense_rating = NEW.defense_rating
    WHERE id = OLD.id;
  ELSIF (TG_OP = 'DELETE') THEN
    DELETE FROM secundario.team_attributes 
    WHERE id = OLD.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_team_attributes
AFTER INSERT OR UPDATE OR DELETE ON public.team_attributes
FOR EACH ROW
EXECUTE FUNCTION sync_team_attributes();