-- Primeira Procedure

CREATE OR REPLACE PROCEDURE convert_weight_to_kg()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE player
    SET weight = weight * 0.453592
    WHERE weight IS NOT NULL;
END;
$$;

CALL convert_weight_to_kg();