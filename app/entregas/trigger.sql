-- Primeira trigger 

CREATE OR REPLACE FUNCTION insert_team_goals_in_match()
RETURNS TRIGGER 
AS $$
BEGIN
    IF NEW.goal_type IN ('n', 'p') THEN
        IF NEW.team_api_id = (
            SELECT home_team_api_id FROM match WHERE match_api_id = NEW.match_api_id
        ) THEN
            UPDATE 
                match
            SET 
                home_team_goal = home_team_goal + 1
            WHERE 
                match_api_id = NEW.match_api_id;
        ELSIF NEW.team_api_id = (
            SELECT away_team_api_id FROM match WHERE match_api_id = NEW.match_api_id
        ) THEN
            UPDATE 
                match
            SET 
                away_team_goal = away_team_goal + 1
            WHERE 
                match_api_id = NEW.match_api_id;
        END IF;
    ELSIF NEW.goal_type = 'o' THEN
        IF NEW.team_api_id = (
            SELECT 
                home_team_api_id 
            FROM 
                match 
            WHERE 
                match_api_id = NEW.match_api_id
        ) THEN

            UPDATE 
                match
            SET 
                away_team_goal = away_team_goal + 1
            WHERE 
                match_api_id = NEW.match_api_id;

        ELSIF NEW.team_api_id = (
            SELECT away_team_api_id FROM match WHERE match_api_id = NEW.match_api_id
        ) THEN

            UPDATE
                match
            SET 
                home_team_goal = home_team_goal + 1
            WHERE 
                match_api_id = NEW.match_api_id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_insert_team_goals_in_match
AFTER INSERT ON match_goals
FOR EACH ROW
EXECUTE FUNCTION insert_team_goals_in_match();

-- Segunda Trigger 

CREATE OR REPLACE FUNCTION update_team_goals_in_match()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.goal_type IN ('n', 'p') THEN
        IF OLD.team_api_id = (
            SELECT home_team_api_id FROM match WHERE match_api_id = OLD.match_api_id
        ) THEN
            UPDATE
                match
            SET 
                home_team_goal = home_team_goal - 1
            WHERE 
                match_api_id = OLD.match_api_id;
        ELSIF OLD.team_api_id = (
            SELECT away_team_api_id FROM match WHERE match_api_id = OLD.match_api_id
        ) THEN
            UPDATE 
                match
            SET 
                away_team_goal = away_team_goal - 1
            WHERE  
                match_api_id = OLD.match_api_id;
        END IF;
    ELSIF OLD.goal_type = 'o' THEN
        IF OLD.team_api_id = (
            SELECT home_team_api_id FROM match WHERE match_api_id = OLD.match_api_id
        ) THEN
            UPDATE
                match
            SET 
                away_team_goal = away_team_goal - 1
            WHERE 
                match_api_id = OLD.match_api_id;
        ELSIF OLD.team_api_id = (
            SELECT away_team_api_id FROM match WHERE match_api_id = OLD.match_api_id
        ) THEN
            UPDATE 
                match
            SET 
                home_team_goal = home_team_goal - 1
            WHERE 
                match_api_id = OLD.match_api_id;
        END IF;
    END IF;

    IF NEW.goal_type IN ('n', 'p') THEN
        IF NEW.team_api_id = (
            SELECT home_team_api_id FROM match WHERE match_api_id = NEW.match_api_id
        ) THEN
            UPDATE
                match
            SET     
                home_team_goal = home_team_goal + 1
            WHERE 
                match_api_id = NEW.match_api_id;
        ELSIF NEW.team_api_id = (
            SELECT away_team_api_id FROM match WHERE match_api_id = NEW.match_api_id
        ) THEN
            UPDATE 
                match
            SET 
                away_team_goal = away_team_goal + 1
            WHERE 
                match_api_id = NEW.match_api_id;
        END IF;
    ELSIF NEW.goal_type = 'o' THEN
        IF NEW.team_api_id = (
            SELECT home_team_api_id FROM match WHERE match_api_id = NEW.match_api_id
        ) THEN
            UPDATE 
                match
            SET 
                away_team_goal = away_team_goal + 1
            WHERE 
                match_api_id = NEW.match_api_id;
        ELSIF NEW.team_api_id = (
            SELECT away_team_api_id FROM match WHERE match_api_id = NEW.match_api_id
        ) THEN
            UPDATE
                match
            SET 
                home_team_goal = home_team_goal + 1
            WHERE 
                match_api_id = NEW.match_api_id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_team_goals_in_match
AFTER UPDATE ON match_goals
FOR EACH ROW
EXECUTE FUNCTION update_team_goals_in_match();

-- Terceira Trigger

CREATE OR REPLACE FUNCTION delete_team_goals_in_match()
RETURNS TRIGGER 
AS $$
BEGIN
    IF OLD.goal_type IN ('n', 'p') THEN
        IF OLD.team_api_id = (
            SELECT home_team_api_id FROM match WHERE match_api_id = OLD.match_api_id
        ) THEN
            UPDATE 
                match
            SET 
                home_team_goal = home_team_goal - 1
            WHERE 
                match_api_id = OLD.match_api_id;
        ELSIF OLD.team_api_id = (
            SELECT away_team_api_id FROM match WHERE match_api_id = OLD.match_api_id
        ) THEN
            UPDATE 
                match
            SET 
                away_team_goal = away_team_goal - 1
            WHERE 
                match_api_id = OLD.match_api_id;
        END IF;
    ELSIF OLD.goal_type = 'o' THEN
        IF OLD.team_api_id = (
            SELECT home_team_api_id FROM match WHERE match_api_id = OLD.match_api_id
        ) THEN
            UPDATE
                match
            SET 
                away_team_goal = away_team_goal - 1
            WHERE 
                match_api_id = OLD.match_api_id;
        ELSIF OLD.team_api_id = (
            SELECT away_team_api_id FROM match WHERE match_api_id = OLD.match_api_id
        ) THEN
            UPDATE 
                match
            SET 
                home_team_goal = home_team_goal - 1
            WHERE 
                match_api_id = OLD.match_api_id;
        END IF;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_delete_team_goals_in_match
AFTER DELETE ON match_goals
FOR EACH ROW
EXECUTE FUNCTION delete_team_goals_in_match();

